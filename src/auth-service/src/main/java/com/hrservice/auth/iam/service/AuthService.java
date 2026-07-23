package com.hrservice.auth.iam.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.hrservice.auth.iam.entity.User;
import com.hrservice.auth.iam.entity.UserPasswordHistory;
import com.hrservice.auth.iam.security.TotpService;
import com.hrservice.auth.iam.sync.UserSyncService;
import com.hrservice.auth.iam.repository.UserPasswordHistoryRepository;
import com.hrservice.auth.iam.repository.UserRepository;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.MediaType;
import org.springframework.http.client.SimpleClientHttpRequestFactory;
import org.springframework.security.crypto.argon2.Argon2PasswordEncoder;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestClient;

import java.nio.charset.StandardCharsets;
import java.security.GeneralSecurityException;
import java.security.KeyFactory;
import java.security.MessageDigest;
import java.security.PublicKey;
import java.security.Signature;
import java.security.spec.X509EncodedKeySpec;
import java.time.Duration;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Arrays;
import java.util.Base64;
import java.util.HexFormat;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Objects;
import java.util.concurrent.atomic.AtomicReference;
import java.util.UUID;
import java.util.regex.Pattern;

@Service
public class AuthService {

    private static final String JWT_ALG = "EdDSA";
    private static final String JWT_TYPE = "JWT";
    private static final String ED25519 = "Ed25519";
    private static final String CREDENTIAL_FIELD_NAME = "credential";
    private static final String PRIMARY_AUTH_METHOD = "primary_auth";
    private static final String SECOND_FACTOR_AUTH_METHOD = "otp";
    private static final String TOKEN_BLACKLIST_PREFIX = "blacklist:token:";
    private static final Pattern PASSWORD_POLICY_PATTERN =
        Pattern.compile("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[^A-Za-z0-9])(?=\\S+$).{8,}$");

    private final UserRepository userRepository;
    private final UserPasswordHistoryRepository userPasswordHistoryRepository;
    private final ObjectMapper objectMapper;
    private final Argon2PasswordEncoder passwordEncoder;
    private final LoginAttemptService loginAttemptService;
    private final UserSyncService userSyncService;
    private final TotpService totpService;
    private final StringRedisTemplate redisTemplate;
    private final RestClient kmsSignerClient;
    private final long jwtExpirationSeconds;
    private final int passwordExpiryDays;
    private final long jwksCacheSeconds;
    private final Object jwksCacheLock = new Object();
    private final AtomicReference<CachedJwks> cachedJwks = new AtomicReference<>();

    public AuthService(
        UserRepository userRepository,
        UserPasswordHistoryRepository userPasswordHistoryRepository,
        ObjectMapper objectMapper,
        LoginAttemptService loginAttemptService,
        UserSyncService userSyncService,
        TotpService totpService,
        StringRedisTemplate redisTemplate,
        @Value("${kms.base-url:http://localhost:8083}") String kmsBaseUrl,
        @Value("${jwt.expiration-seconds:3600}") long jwtExpirationSeconds,
        @Value("${auth.password-policy.expiry-days:90}") int passwordExpiryDays,
        @Value("${auth.jwks-cache-seconds:300}") long jwksCacheSeconds,
        @Value("${auth.argon2.salt-length:16}") int argon2SaltLength,
        @Value("${auth.argon2.hash-length:32}") int argon2HashLength,
        @Value("${auth.argon2.parallelism:1}") int argon2Parallelism,
        @Value("${auth.argon2.memory:16384}") int argon2Memory,
        @Value("${auth.argon2.iterations:2}") int argon2Iterations
    ) {
        this.userRepository = userRepository;
        this.userPasswordHistoryRepository = userPasswordHistoryRepository;
        this.objectMapper = objectMapper;
        // Defaults match Argon2PasswordEncoder.defaultsForSpringSecurity_v5_8() (memory=16384, iterations=2).
        // Overridable via env (e.g. AUTH_ARGON2_MEMORY/AUTH_ARGON2_ITERATIONS) so local/demo stacks can use
        // lighter, faster params without weakening the production defaults.
        this.passwordEncoder = new Argon2PasswordEncoder(
            argon2SaltLength, argon2HashLength, argon2Parallelism, argon2Memory, argon2Iterations);
        this.loginAttemptService = loginAttemptService;
        this.userSyncService = userSyncService;
        this.totpService = totpService;
        this.redisTemplate = redisTemplate;
        SimpleClientHttpRequestFactory kmsRequestFactory = new SimpleClientHttpRequestFactory();
        kmsRequestFactory.setConnectTimeout(Duration.ofSeconds(5));
        kmsRequestFactory.setReadTimeout(Duration.ofSeconds(15));
        this.kmsSignerClient = RestClient.builder()
            .baseUrl(Objects.requireNonNull(kmsBaseUrl))
            .requestFactory(kmsRequestFactory)
            .build();
        this.jwtExpirationSeconds = jwtExpirationSeconds;
        this.passwordExpiryDays = passwordExpiryDays;
        this.jwksCacheSeconds = jwksCacheSeconds;
    }

    @Transactional
    public User register(String username, String password, String role) {
        if (username == null || username.isBlank() || password == null || password.isBlank()) {
            throw new IllegalArgumentException("username and password là bắt buộc");
        }

        String normalizedUsername = normalizeUsername(username);
        if (normalizedUsername.length() > 100) {
            throw new IllegalArgumentException("username phải dưới <= 100 ký tự");
        }

        validatePasswordPolicy(password, CREDENTIAL_FIELD_NAME);

        if (userRepository.existsByUsernameIgnoreCase(normalizedUsername)) {
            throw new IllegalArgumentException("tên đăng nhập đã tồn tại");
        }

        String normalizedRole = role == null || role.isBlank() ? "USER" : role.trim().toUpperCase();
        if (normalizedRole.length() > 50) {
            throw new IllegalArgumentException("role phải dưới <= 50 ký tự");
        }

        User user = new User();
        user.setUsername(normalizedUsername);
        String passwordHash = passwordEncoder.encode(password);
        user.setPasswordHash(passwordHash);
        user.setRole(normalizedRole);
        user.setPasswordUpdatedAt(Instant.now());

        try {
            User savedUser = userRepository.save(user);
            savePasswordHistory(savedUser.getId(), passwordHash);
            userSyncService.enqueueUserCreated(savedUser);
            return savedUser;
        } catch (DataIntegrityViolationException ex) {
            throw new IllegalArgumentException("tên đăng nhập đã tồn tại");
        }
    }

    @Transactional(readOnly = true)
    public UserSyncService.SyncStatusView getUserSyncStatus(UUID userId) {
        return userSyncService.getSyncStatus(userId);
    }

    @Transactional
    public UserSyncService.SyncStatusView retryUserSync(UUID userId) {
        return userSyncService.retrySync(userId);
    }

    @Transactional(readOnly = true)
    public List<User> listUsers() {
        return userRepository.findAll();
    }

    @Transactional
    public User updateUser(UUID userId, String role, Boolean locked) {
        User user = userRepository.findById(userId)
            .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy người dùng"));

        if (role != null && !role.isBlank()) {
            String normalizedRole = role.trim().toUpperCase(Locale.ROOT);
            if (normalizedRole.length() > 50) {
                throw new IllegalArgumentException("role phải dưới <= 50 ký tự");
            }
            user.setRole(normalizedRole);
        }

        if (locked != null) {
            if (locked) {
                user.setLocked(true);
                user.setLockedAt(Instant.now());
            } else {
                user.setLocked(false);
                user.setLockedAt(null);
                loginAttemptService.resetAttempts(user.getUsername());
            }
        }

        return userRepository.save(user);
    }

    @Transactional
    public void deleteUser(UUID userId) {
        if (!userRepository.existsById(userId)) {
            throw new IllegalArgumentException("Không tìm thấy người dùng");
        }
        userPasswordHistoryRepository.deleteByUserId(userId);
        userRepository.deleteById(userId);
    }

    @Transactional
    public void changePassword(String username, String oldPassword, String newPassword) {
        if (username == null || username.isBlank() || oldPassword == null || oldPassword.isBlank() || newPassword == null || newPassword.isBlank()) {
            throw new IllegalArgumentException("tên đăng nhập, mật khẩu cũ và mật khẩu mới là bắt buộc");
        }

        validatePasswordPolicy(newPassword, "newPassword");

        if (oldPassword.equals(newPassword)) {
            throw new IllegalArgumentException("mật khẩu mới phải khác mật khẩu cũ");
        }

        User user = userRepository.findByUsernameIgnoreCase(normalizeUsername(username))
            .orElseThrow(() -> new SecurityException("Thông tin đăng nhập không hợp lệ"));

        if (!passwordEncoder.matches(oldPassword, user.getPasswordHash())) {
            throw new SecurityException("Thông tin đăng nhập không hợp lệ");
        }

        if (isReusedPassword(user.getId(), newPassword)) {
            throw new IllegalArgumentException("mật khẩu mới không được trùng với 3 mật khẩu gần nhất");
        }

        String newPasswordHash = passwordEncoder.encode(newPassword);
        user.setPasswordHash(newPasswordHash);
        user.setPasswordUpdatedAt(Instant.now());
        userRepository.save(user);
        savePasswordHistory(user.getId(), newPasswordHash);
    }

    public String login(String username, String password) {
        LoginResult result = login(username, password, null);
        if (result.mfaRequired()) {
            throw new SecurityException("Yêu cầu mã 2FA");
        }
        return result.accessToken();
    }

    public LoginResult login(String username, String password, String otp) {
        if (username == null || username.isBlank() || password == null || password.isBlank()) {
            throw new IllegalArgumentException("username and password là bắt buộc");
        }

        User user = authenticatePrimaryCredentials(username, password);

        if (user.isTwoFactorEnabled()) {
            if (otp == null || otp.isBlank()) {
                return LoginResult.mfaRequired("totp");
            }
            if (!totpService.verifyCode(user.getTwoFactorSecret(), otp.trim())) {
                throw new SecurityException("Mã 2FA không hợp lệ");
            }
        }

        String token = generateToken(user, user.isTwoFactorEnabled());
        return LoginResult.success(token, jwtExpirationSeconds, "hr.read hr.write");
    }

    @Transactional
    public TwoFactorEnrollment initTwoFactor(String username, String password) {
        User user = authenticatePrimaryCredentials(username, password);
        if (user.isTwoFactorEnabled()) {
            throw new IllegalStateException("2FA đã được bật");
        }

        String secret = totpService.generateSecret();
        user.setTwoFactorSecret(secret);
        user.setTwoFactorEnabled(false);
        user.setTwoFactorEnabledAt(null);
        userRepository.save(user);

        return new TwoFactorEnrollment(secret, totpService.buildOtpAuthUri(user.getUsername(), secret));
    }

    @Transactional
    public void confirmTwoFactor(String username, String password, String otp) {
        if (otp == null || otp.isBlank()) {
            throw new IllegalArgumentException("mã OTP là bắt buộc");
        }

        User user = authenticatePrimaryCredentials(username, password);
        String secret = user.getTwoFactorSecret();
        if (secret == null || secret.isBlank()) {
            throw new IllegalStateException("Đăng ký 2FA chưa được khởi tạo");
        }

        if (!totpService.verifyCode(secret, otp.trim())) {
            throw new SecurityException("Mã 2FA không hợp lệ");
        }

        user.setTwoFactorEnabled(true);
        user.setTwoFactorEnabledAt(Instant.now());
        userRepository.save(user);
    }

    @Transactional
    public void disableTwoFactor(String username, String password, String otp) {
        if (otp == null || otp.isBlank()) {
            throw new IllegalArgumentException("mã OTP là bắt buộc");
        }

        User user = authenticatePrimaryCredentials(username, password);
        if (!user.isTwoFactorEnabled()) {
            throw new IllegalStateException("2FA chưa được bật");
        }

        if (!totpService.verifyCode(user.getTwoFactorSecret(), otp.trim())) {
            throw new SecurityException("Mã 2FA không hợp lệ");
        }

        user.setTwoFactorEnabled(false);
        user.setTwoFactorSecret(null);
        user.setTwoFactorEnabledAt(null);
        userRepository.save(user);
    }

    private User authenticatePrimaryCredentials(String username, String password) {
        String normalizedUsername = normalizeUsername(username);
        if (loginAttemptService.isBlocked(normalizedUsername)) {
            throw new AccountLockedException("Tài khoản bị khóa do đăng nhập sai nhiều lần. Vui lòng thử lại sau 30 phút");
        }

        User user = userRepository.findByUsernameIgnoreCase(normalizedUsername)
            .orElseGet(() -> {
                if (loginAttemptService.recordFailure(normalizedUsername)) {
                    throw new AccountLockedException("Tài khoản bị khóa do đăng nhập sai nhiều lần. Vui lòng thử lại sau 30 phút");
                }
                throw new SecurityException("Thông tin đăng nhập không hợp lệ");
            });

        if (user.isLocked()) {
            throw new AccountLockedException("Tài khoản bị khóa bởi quản trị viên");
        }

        if (!passwordEncoder.matches(password, user.getPasswordHash())) {
            if (loginAttemptService.recordFailure(normalizedUsername)) {
                throw new AccountLockedException("Tài khoản bị khóa do đăng nhập sai nhiều lần. Vui lòng thử lại sau 30 phút");
            }
            throw new SecurityException("Thông tin đăng nhập không hợp lệ");
        }

        if (isPasswordExpired(user)) {
            loginAttemptService.resetAttempts(normalizedUsername);
            throw new PasswordExpiredException("Mật khẩu đã hết hạn. Vui lòng đổi mật khẩu");
        }

        loginAttemptService.resetAttempts(normalizedUsername);
        return user;
    }

    private String generateToken(User user, boolean mfaAuthenticated) {
        long exp = Instant.now().plusSeconds(jwtExpirationSeconds).getEpochSecond();

        Map<String, Object> payload = new LinkedHashMap<>();
        payload.put("userId", user.getId());
        payload.put("username", user.getUsername());
        payload.put("role", user.getRole());
        payload.put("scope", "hr.read hr.write");
        payload.put("amr", mfaAuthenticated ? List.of(PRIMARY_AUTH_METHOD, SECOND_FACTOR_AUTH_METHOD) : List.of(PRIMARY_AUTH_METHOD));
        payload.put("jti", UUID.randomUUID().toString());
        payload.put("exp", exp);

        String encodedPayload = encodeBase64Url(toJsonBytes(payload));

        Map<String, Object> header = new LinkedHashMap<>();
        header.put("alg", JWT_ALG);
        header.put("typ", JWT_TYPE);

        header.put("kid", resolveActiveKeyId());
        String encodedHeader = encodeBase64Url(toJsonBytes(header));

        String signingInput = encodedHeader + "." + encodedPayload;
        KmsSignResponse signed = signByKms(signingInput);

        String signatureBase64 = signed.signature();
        String signatureBase64Url = encodeBase64Url(Base64.getDecoder().decode(signatureBase64));

        return signingInput + "." + signatureBase64Url;
    }

    public Map<String, Object> verifyToken(String token) {
        if (token == null || token.isBlank()) {
            throw new IllegalArgumentException("token là bắt buộc");
        }

        String[] parts = token.split("\\.");
        if (parts.length != 3) {
            throw new SecurityException("Định dạng token không hợp lệ");
        }

        Map<String, Object> header = readJsonMap(decodeBase64Url(parts[0]));
        Map<String, Object> payload = readJsonMap(decodeBase64Url(parts[1]));

        String alg = String.valueOf(header.get("alg"));
        if (!JWT_ALG.equals(alg)) {
            throw new SecurityException("Thuật toán JWT không được hỗ trợ");
        }

        String kid = header.get("kid") == null ? null : String.valueOf(header.get("kid"));
        if (kid == null || kid.isBlank()) {
            throw new SecurityException("Thiếu kid trong header JWT");
        }

        JwkKey jwkKey = loadJwkByKid(kid);
        verifySignature(parts[0] + "." + parts[1], parts[2], jwkKey);
        validateExpiration(payload);

        return payload;
    }

    public void revokeToken(String token) {
        if (token == null || token.isBlank()) {
            throw new IllegalArgumentException("token là bắt buộc");
        }

        String[] parts = token.split("\\.");
        if (parts.length != 3) {
            throw new IllegalArgumentException("Định dạng token không hợp lệ");
        }

        Map<String, Object> payload;
        try {
            payload = readJsonMap(decodeBase64Url(parts[1]));
        } catch (Exception ex) {
            throw new IllegalArgumentException("Token payload không hợp lệ");
        }

        String tokenId = resolveTokenId(payload, token);
        long ttlSeconds = resolveTtlSeconds(payload.get("exp"));

        // Only store in Redis if token hasn't expired yet (TTL > 0)
        if (ttlSeconds > 0) {
            redisTemplate.opsForValue().set(
                TOKEN_BLACKLIST_PREFIX + tokenId,
                "1",
                Objects.requireNonNull(Duration.ofSeconds(ttlSeconds))
            );
        }
        // If already expired, no need to blacklist - it won't be accepted anyway
    }

    private KmsSignResponse signByKms(String payloadToSign) {
        KmsSignResponse response = kmsSignerClient.post()
              .uri("/quan-ly-khoa/internal/sign")
            .contentType(Objects.requireNonNull(MediaType.APPLICATION_JSON))
            .body(new KmsSignRequest(payloadToSign))
            .retrieve()
            .body(KmsSignResponse.class);

        if (response == null || response.keyId() == null || response.signature() == null || response.signature().isBlank()) {
            throw new IllegalStateException("Phản hồi ký KMS trống");
        }

        return response;
    }

    private byte[] toJsonBytes(Object value) {
        try {
            return objectMapper.writeValueAsBytes(value);
        } catch (JsonProcessingException ex) {
            throw new IllegalStateException("Không thể tuần tự hóa dữ liệu JWT", ex);
        }
    }

    private String encodeBase64Url(byte[] data) {
        return Base64.getUrlEncoder().withoutPadding().encodeToString(data);
    }

    private byte[] decodeBase64Url(String encoded) {
        return Base64.getUrlDecoder().decode(encoded);
    }

    private Map<String, Object> readJsonMap(byte[] bytes) {
        try {
            return objectMapper.readValue(bytes, new TypeReference<Map<String, Object>>() {
            });
        } catch (Exception ex) {
            throw new SecurityException("Nội dung JSON JWT không hợp lệ", ex);
        }
    }

    private JwkKey loadJwkByKid(String kid) {
        JwksResponse response = loadJwks();

        return response.keys().stream()
            .filter(key -> kid.equals(key.kid()))
            .findFirst()
            .orElseThrow(() -> new SecurityException("Không tìm thấy khóa ký trong JWKS"));
    }

    private void verifySignature(String signingInput, String encodedSignature, JwkKey jwkKey) {
        if (!"OKP".equals(jwkKey.kty()) || !ED25519.equals(jwkKey.crv()) || !JWT_ALG.equals(jwkKey.alg())) {
            throw new SecurityException("Loại khóa JWK không được hỗ trợ");
        }

        try {
            byte[] x = decodeBase64Url(jwkKey.x());
            if (x.length != 32) {
                throw new SecurityException("Độ dài khóa công khai Ed25519 không hợp lệ");
            }

            byte[] spkiPrefix = new byte[] {
                0x30, 0x2A, 0x30, 0x05, 0x06, 0x03, 0x2B, 0x65, 0x70, 0x03, 0x21, 0x00
            };
            byte[] spki = Arrays.copyOf(spkiPrefix, spkiPrefix.length + x.length);
            System.arraycopy(x, 0, spki, spkiPrefix.length, x.length);

            KeyFactory keyFactory = KeyFactory.getInstance(ED25519);
            PublicKey publicKey = keyFactory.generatePublic(new X509EncodedKeySpec(spki));

            Signature verifier = Signature.getInstance(ED25519);
            verifier.initVerify(publicKey);
            verifier.update(signingInput.getBytes(StandardCharsets.UTF_8));

            byte[] signatureBytes = decodeBase64Url(encodedSignature);
            if (!verifier.verify(signatureBytes)) {
                throw new SecurityException("Chữ ký JWT không hợp lệ");
            }
        } catch (GeneralSecurityException ex) {
            throw new IllegalStateException("Không thể xác minh chữ ký JWT", ex);
        }
    }

    private void validateExpiration(Map<String, Object> payload) {
        Object expObj = payload.get("exp");
        if (expObj == null) {
            throw new SecurityException("Thiếu trường exp");
        }

        long exp;
        if (expObj instanceof Number num) {
            exp = num.longValue();
        } else {
            exp = Long.parseLong(String.valueOf(expObj));
        }

        long now = Instant.now().truncatedTo(ChronoUnit.SECONDS).getEpochSecond();
        if (now >= exp) {
            throw new SecurityException("Token đã hết hạn");
        }
    }

    private String resolveTokenId(Map<String, Object> claims, String token) {
        Object jti = claims.get("jti");
        if (jti != null) {
            String value = String.valueOf(jti).trim();
            if (!value.isBlank()) {
                return value;
            }
        }

        return sha256(token);
    }

    private long resolveTtlSeconds(Object expObj) {
        long exp;
        if (expObj instanceof Number num) {
            exp = num.longValue();
        } else {
            exp = Long.parseLong(String.valueOf(expObj));
        }

        long now = Instant.now().truncatedTo(ChronoUnit.SECONDS).getEpochSecond();
        return exp - now;
    }

    private String sha256(String value) {
        try {
            byte[] digest = MessageDigest.getInstance("SHA-256").digest(value.getBytes(StandardCharsets.UTF_8));
            return HexFormat.of().formatHex(digest);
        } catch (Exception ex) {
            throw new IllegalStateException("Không thể băm token", ex);
        }
    }


    private String resolveActiveKeyId() {
        JwksResponse response = loadJwks();
        return response.keys().stream()
            .findFirst()
            .map(JwkKey::kid)
            .orElseThrow(() -> new IllegalStateException("Phản hồi JWKS không chứa khóa hoạt động"));
    }

    private JwksResponse loadJwks() {
        CachedJwks cached = cachedJwks.get();
        if (cached != null && !cached.isExpired()) {
            return cached.response();
        }

        synchronized (jwksCacheLock) {
            cached = cachedJwks.get();
            if (cached != null && !cached.isExpired()) {
                return cached.response();
            }

            JwksResponse response = kmsSignerClient.get()
                    .uri("/quan-ly-khoa/.well-known/jwks.json")
                .retrieve()
                .body(JwksResponse.class);

            if (response == null || response.keys() == null || response.keys().isEmpty()) {
                throw new IllegalStateException("Phản hồi JWKS trống");
            }

            Instant expiresAt = Instant.now().plusSeconds(Math.max(30, jwksCacheSeconds));
            cachedJwks.set(new CachedJwks(response, expiresAt));
            return response;
        }
    }

    private record CachedJwks(JwksResponse response, Instant expiresAt) {
        private boolean isExpired() {
            return Instant.now().isAfter(expiresAt);
        }
    }

    private void validatePasswordPolicy(String password, String fieldName) {
        if (!PASSWORD_POLICY_PATTERN.matcher(password).matches()) {
            throw new IllegalArgumentException(
                fieldName + " phải có ít nhất 8 ký tự và bao gồm chữ hoa, chữ thường, số, ký tự đặc biệt và không có khoảng trắng"
            );
        }
    }

    private String normalizeUsername(String username) {
        return username.trim().toLowerCase(Locale.ROOT);
    }

    private boolean isReusedPassword(UUID userId, String rawPassword) {
        List<UserPasswordHistory> latestHistory = userPasswordHistoryRepository.findTop3ByUserIdOrderByCreatedAtDesc(userId);
        return latestHistory.stream().anyMatch(history -> passwordEncoder.matches(rawPassword, history.getPasswordHash()));
    }

    private void savePasswordHistory(UUID userId, String passwordHash) {
        UserPasswordHistory history = new UserPasswordHistory();
        history.setUserId(userId);
        history.setPasswordHash(passwordHash);
        userPasswordHistoryRepository.save(history);
    }

    private boolean isPasswordExpired(User user) {
        Instant updatedAt = user.getPasswordUpdatedAt();
        if (updatedAt == null) {
            return true;
        }

        Instant expiresAt = updatedAt.plus(Duration.ofDays(passwordExpiryDays));
        return Instant.now().isAfter(expiresAt);
    }

    @Transactional
    public void lockAccount(String username) {
        if (username == null || username.isBlank()) {
            throw new IllegalArgumentException("tên đăng nhập là bắt buộc");
        }

        String normalizedUsername = normalizeUsername(username);
        User user = userRepository.findByUsernameIgnoreCase(normalizedUsername)
            .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy người dùng"));

        user.setLocked(true);
        user.setLockedAt(Instant.now());
        userRepository.save(user);
    }

    @Transactional
    public void unlockAccount(String username) {
        if (username == null || username.isBlank()) {
            throw new IllegalArgumentException("tên đăng nhập là bắt buộc");
        }

        String normalizedUsername = normalizeUsername(username);
        User user = userRepository.findByUsernameIgnoreCase(normalizedUsername)
            .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy người dùng"));

        user.setLocked(false);
        user.setLockedAt(null);
        loginAttemptService.resetAttempts(normalizedUsername);
        userRepository.save(user);
    }

    private record KmsSignRequest(String payload) {
    }

    private record KmsSignResponse(String keyId, String algorithm, String signature) {
    }

    private record JwksResponse(List<JwkKey> keys) {
    }

    private record JwkKey(
        String kid,
        String kty,
        String crv,
        String use,
        String alg,
        String x
    ) {
    }

    public record LoginResult(
        String accessToken,
        String tokenType,
        long expiresIn,
        String scope,
        boolean mfaRequired,
        String mfaMethod
    ) {
        public static LoginResult success(String accessToken, long expiresIn, String scope) {
            return new LoginResult(accessToken, "Bearer", expiresIn, scope, false, null);
        }

        public static LoginResult mfaRequired(String mfaMethod) {
            return new LoginResult(null, "Bearer", 0, null, true, mfaMethod);
        }
    }

    public record TwoFactorEnrollment(String secret, String otpAuthUri) {
    }
}
