package com.hrservice.auth.iam.controller;

import com.hrservice.auth.iam.entity.AuditLog;
import com.hrservice.auth.iam.repository.UserRepository;
import com.hrservice.auth.iam.service.AuditService;
import com.hrservice.auth.iam.service.AuthService;
import com.hrservice.auth.iam.service.AccountLockedException;
import com.hrservice.auth.iam.service.PasswordExpiredException;
import com.hrservice.auth.iam.service.RoleManagementService;
import com.hrservice.auth.iam.entity.User;
import com.hrservice.auth.security.RequiredRoles;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import java.time.Instant;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/xac-thuc")
public class AuthController {

    private static final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(AuthController.class);

    private final AuthService authService;
    private final RoleManagementService roleManagementService;
    private final com.hrservice.auth.iam.mapper.AuthDtoMapper authDtoMapper;
    private final UserRepository userRepository;
    private final AuditService auditService;

    public AuthController(AuthService authService, RoleManagementService roleManagementService,
                          com.hrservice.auth.iam.mapper.AuthDtoMapper authDtoMapper,
                          UserRepository userRepository,
                          AuditService auditService) {
        this.authService = authService;
        this.roleManagementService = roleManagementService;
        this.authDtoMapper = authDtoMapper;
        this.userRepository = userRepository;
        this.auditService = auditService;
    }

    @PostMapping({"/dang-ky", "/user/register"})
    public ResponseEntity<RegisterResponse> register(@RequestBody RegisterRequest request, HttpServletRequest httpRequest) {
        if (request == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Nội dung yêu cầu là bắt buộc");
        }

        try {
            User savedUser = authService.register(request.username(), request.password(), request.role());
            safeAudit(() -> auditService.record("USER_CREATE", httpRequest, "USER",
                savedUser.getId().toString(), "Tạo tài khoản " + savedUser.getUsername(), null, null));
            return ResponseEntity.status(HttpStatus.CREATED)
                .body(authDtoMapper.toRegisterResponse(savedUser));
        } catch (IllegalArgumentException ex) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, ex.getMessage(), ex);
        }
    }

    @GetMapping("/trang-thai-dong-bo/{userId}")
    public ResponseEntity<SyncStatusResponse> syncStatus(@PathVariable String userId) {
        try {
            UUID parsed = UUID.fromString(userId);
            var status = authService.getUserSyncStatus(parsed);
            return ResponseEntity.ok(authDtoMapper.toSyncStatusResponse(status));
        } catch (IllegalArgumentException ex) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "userId is invalid", ex);
        }
    }

    @RequiredRoles({"ADMIN"})
    @PostMapping("/thu-lai-dong-bo/{userId}")
    public ResponseEntity<SyncStatusResponse> retrySync(@PathVariable String userId) {
        try {
            UUID parsed = UUID.fromString(userId);
            var status = authService.retryUserSync(parsed);
            return ResponseEntity.ok(authDtoMapper.toSyncStatusResponse(status));
        } catch (IllegalArgumentException ex) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, ex.getMessage(), ex);
        }
    }

    @RequiredRoles({"ADMIN"})
    @GetMapping("/quan-tri/tai-khoan")
    public ResponseEntity<List<UserDto>> listUsers() {
        return ResponseEntity.ok(authDtoMapper.toUserDtoList(authService.listUsers()));
    }

    @RequiredRoles({"ADMIN"})
    @PutMapping("/quan-tri/tai-khoan/{userId}")
    public ResponseEntity<UserDto> updateUser(@PathVariable String userId, @RequestBody UpdateUserRequest request,
                                              HttpServletRequest httpRequest) {
        if (request == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Nội dung yêu cầu là bắt buộc");
        }

        try {
            UUID parsed = UUID.fromString(userId);
            User updatedUser = authService.updateUser(parsed, request.role(), request.locked());
            String desc = "Cập nhật tài khoản " + updatedUser.getUsername();
            if (request.role() != null) desc += ", role: " + request.role();
            if (request.locked() != null) desc += ", locked: " + request.locked();
            final String auditDesc = desc;
            safeAudit(() -> auditService.record("USER_UPDATE", httpRequest, "USER", parsed.toString(), auditDesc, null, null));
            return ResponseEntity.ok(authDtoMapper.toUserDto(updatedUser));
        } catch (IllegalArgumentException ex) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, ex.getMessage(), ex);
        }
    }

    @RequiredRoles({"ADMIN"})
    @DeleteMapping("/quan-tri/tai-khoan/{userId}")
    public ResponseEntity<AdminResponse> deleteUser(@PathVariable String userId, HttpServletRequest httpRequest) {
        try {
            UUID parsed = UUID.fromString(userId);
            authService.deleteUser(parsed);
            safeAudit(() -> auditService.record("USER_DELETE", httpRequest, "USER", parsed.toString(), "Xóa tài khoản " + userId, null, null));
            return ResponseEntity.ok(authDtoMapper.toAdminResponse("Xóa người dùng thành công"));
        } catch (IllegalArgumentException ex) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, ex.getMessage(), ex);
        }
    }

    @RequiredRoles({"ADMIN"})
    @GetMapping("/quan-tri/vai-tro")
    public ResponseEntity<List<RoleDto>> getRoles() {
        return ResponseEntity.ok(roleManagementService.listRoles().stream()
            .map(role -> new RoleDto(role.name(), role.description(), role.permissions(), role.userCount()))
            .toList());
    }

    @RequiredRoles({"ADMIN"})
    @PostMapping("/quan-tri/vai-tro")
    public ResponseEntity<RoleDto> createRole(@RequestBody RoleRequest request, HttpServletRequest httpRequest) {
        if (request == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Nội dung yêu cầu là bắt buộc");
        }

        try {
            RoleManagementService.RoleView role = roleManagementService.createRole(
                request.name(),
                request.description(),
                request.permissions()
            );
            safeAudit(() -> auditService.record("ROLE_CREATE", httpRequest, "ROLE", role.name(),
                "Tạo role " + role.name(), null, null));
            return ResponseEntity.status(HttpStatus.CREATED)
                .body(new RoleDto(role.name(), role.description(), role.permissions(), role.userCount()));
        } catch (IllegalArgumentException ex) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, ex.getMessage(), ex);
        }
    }

    @RequiredRoles({"ADMIN"})
    @PutMapping("/quan-tri/vai-tro/{roleName}")
    public ResponseEntity<RoleDto> updateRole(@PathVariable String roleName, @RequestBody RoleRequest request,
                                              HttpServletRequest httpRequest) {
        if (request == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Nội dung yêu cầu là bắt buộc");
        }

        try {
            RoleManagementService.RoleView role = roleManagementService.updateRole(
                roleName,
                request.description(),
                request.permissions()
            );
            safeAudit(() -> auditService.record("ROLE_UPDATE", httpRequest, "ROLE", role.name(),
                "Cập nhật role " + roleName, null, null));
            return ResponseEntity.ok(new RoleDto(role.name(), role.description(), role.permissions(), role.userCount()));
        } catch (IllegalArgumentException ex) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, ex.getMessage(), ex);
        }
    }

    @RequiredRoles({"ADMIN"})
    @DeleteMapping("/quan-tri/vai-tro/{roleName}")
    public ResponseEntity<AdminResponse> deleteRole(@PathVariable String roleName, HttpServletRequest httpRequest) {
        try {
            roleManagementService.deleteRole(roleName);
            safeAudit(() -> auditService.record("ROLE_DELETE", httpRequest, "ROLE", roleName,
                "Xóa role " + roleName, null, null));
            return ResponseEntity.ok(authDtoMapper.toAdminResponse("Xóa vai trò thành công"));
        } catch (IllegalArgumentException ex) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, ex.getMessage(), ex);
        }
    }

    @PostMapping("/dang-nhap")
    public ResponseEntity<LoginResponse> login(@RequestBody LoginRequest request, HttpServletRequest httpRequest) {
        if (request == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Nội dung yêu cầu là bắt buộc");
        }

        try {
            AuthService.LoginResult result = authService.login(request.username(), request.password(), request.otp());
            if (result.mfaRequired()) {
                safeAudit(() -> auditService.record("LOGIN_MFA_REQUIRED", httpRequest, "USER", null,
                    "Yêu cầu MFA cho " + request.username(), null, null));
                return ResponseEntity.status(HttpStatus.ACCEPTED).body(authDtoMapper.toLoginResponse(result));
            }
            safeAudit(() -> auditService.record("LOGIN_SUCCESS", httpRequest, "USER", null,
                "Đăng nhập thành công: " + request.username(), null, null));
            return ResponseEntity.ok(authDtoMapper.toLoginResponse(result));
        } catch (AccountLockedException ex) {
            throw new ResponseStatusException(HttpStatus.LOCKED, ex.getMessage(), ex);
        } catch (SecurityException ex) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, ex.getMessage(), ex);
        } catch (PasswordExpiredException ex) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, ex.getMessage(), ex);
        } catch (IllegalArgumentException ex) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, ex.getMessage(), ex);
        }
    }

    @PostMapping("/oauth2/token")
    public ResponseEntity<OAuth2TokenResponse> oauth2Token(@RequestBody OAuth2TokenRequest request) {
        if (request == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Nội dung yêu cầu là bắt buộc");
        }

        if (request.grantType() == null || !"password".equalsIgnoreCase(request.grantType().trim())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "grant_type không được hỗ trợ");
        }

        try {
            AuthService.LoginResult result = authService.login(request.username(), request.password(), request.otp());
            if (result.mfaRequired()) {
                throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "mfa_required");
            }
            return ResponseEntity.ok(authDtoMapper.toOAuth2TokenResponse(result));
        } catch (AccountLockedException ex) {
            throw new ResponseStatusException(HttpStatus.LOCKED, ex.getMessage(), ex);
        } catch (SecurityException ex) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, ex.getMessage(), ex);
        } catch (PasswordExpiredException ex) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, ex.getMessage(), ex);
        } catch (IllegalArgumentException ex) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, ex.getMessage(), ex);
        }
    }

    @PostMapping("/2fa/khoi-tao")
    public ResponseEntity<TwoFactorInitResponse> initTwoFactor(@RequestBody TwoFactorCredentialRequest request) {
        if (request == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Nội dung yêu cầu là bắt buộc");
        }

        try {
            AuthService.TwoFactorEnrollment enrollment = authService.initTwoFactor(request.username(), request.password());
            return ResponseEntity.ok(new TwoFactorInitResponse(enrollment.secret(), enrollment.otpAuthUri()));
        } catch (IllegalArgumentException | IllegalStateException ex) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, ex.getMessage(), ex);
        } catch (AccountLockedException ex) {
            throw new ResponseStatusException(HttpStatus.LOCKED, ex.getMessage(), ex);
        } catch (SecurityException ex) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, ex.getMessage(), ex);
        }
    }

    @PostMapping("/2fa/xac-nhan")
    public ResponseEntity<AdminResponse> confirmTwoFactor(@RequestBody TwoFactorConfirmRequest request) {
        if (request == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Nội dung yêu cầu là bắt buộc");
        }

        try {
            authService.confirmTwoFactor(request.username(), request.password(), request.otp());
            return ResponseEntity.ok(authDtoMapper.toAdminResponse("Bật 2FA thành công"));
        } catch (IllegalArgumentException | IllegalStateException ex) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, ex.getMessage(), ex);
        } catch (AccountLockedException ex) {
            throw new ResponseStatusException(HttpStatus.LOCKED, ex.getMessage(), ex);
        } catch (SecurityException ex) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, ex.getMessage(), ex);
        }
    }

    @PostMapping("/2fa/tat")
    public ResponseEntity<AdminResponse> disableTwoFactor(@RequestBody TwoFactorConfirmRequest request) {
        if (request == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Nội dung yêu cầu là bắt buộc");
        }

        try {
            authService.disableTwoFactor(request.username(), request.password(), request.otp());
            return ResponseEntity.ok(authDtoMapper.toAdminResponse("Tắt 2FA thành công"));
        } catch (IllegalArgumentException | IllegalStateException ex) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, ex.getMessage(), ex);
        } catch (AccountLockedException ex) {
            throw new ResponseStatusException(HttpStatus.LOCKED, ex.getMessage(), ex);
        } catch (SecurityException ex) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, ex.getMessage(), ex);
        }
    }

    @RequiredRoles({"USER", "EMPLOYEE", "MANAGER", "DEPARTMENT_HEAD", "HR_MANAGER", "PAYROLL_OFFICER", "ADMIN"})
    @PostMapping("/doi-mat-khau")
    public ResponseEntity<ChangePasswordResponse> changePassword(@RequestBody ChangePasswordRequest request,
                                                                 HttpServletRequest httpRequest) {
        if (request == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Nội dung yêu cầu là bắt buộc");
        }

        try {
            authService.changePassword(request.username(), request.oldPassword(), request.newPassword());
            safeAudit(() -> auditService.record("PASSWORD_CHANGE", httpRequest, "USER", null,
                "Đổi mật khẩu: " + request.username(), null, null));
            return ResponseEntity.ok(authDtoMapper.toChangePasswordResponse("Đổi mật khẩu thành công"));
        } catch (IllegalArgumentException ex) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, ex.getMessage(), ex);
        } catch (SecurityException ex) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Thông tin đăng nhập không hợp lệ", ex);
        }
    }

    @RequiredRoles({"USER", "EMPLOYEE", "MANAGER", "DEPARTMENT_HEAD", "HR_MANAGER", "PAYROLL_OFFICER", "ADMIN"})
    @GetMapping("/tai-khoan/cua-toi")
    public ResponseEntity<AccountInfoResponse> myAccount(HttpServletRequest request) {
        @SuppressWarnings("unchecked")
        Map<String, Object> claims = (Map<String, Object>) request.getAttribute("currentUserClaims");
        if (claims == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Chưa xác thực");
        }
        String userId = (String) claims.get("userId");
        if (userId == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Thông tin token không hợp lệ");
        }
        User user = userRepository.findById(UUID.fromString(userId))
            .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Không tìm thấy người dùng"));
        return ResponseEntity.ok(new AccountInfoResponse(
            user.getId().toString(),
            user.getUsername(),
            user.getRole(),
            user.isLocked(),
            user.isTwoFactorEnabled(),
            user.getCreatedAt(),
            user.getPasswordUpdatedAt()
        ));
    }

    @RequiredRoles({"USER", "EMPLOYEE", "MANAGER", "DEPARTMENT_HEAD", "HR_MANAGER", "PAYROLL_OFFICER", "ADMIN"})
    @PostMapping("/kiem-tra")
    public ResponseEntity<VerifyTokenResponse> verify(@RequestBody VerifyTokenRequest request) {
        if (request == null || request.token() == null || request.token().isBlank()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "token is required");
        }

        try {
            Map<String, Object> claims = authService.verifyToken(request.token());
            return ResponseEntity.ok(authDtoMapper.toVerifyTokenResponse(true, claims));
        } catch (IllegalArgumentException ex) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, ex.getMessage(), ex);
        } catch (SecurityException ex) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, ex.getMessage(), ex);
        }
    }

    @PostMapping("/dang-xuat")
    public ResponseEntity<LogoutResponse> logout(@RequestBody LogoutRequest request) {
        if (request == null || request.token() == null || request.token().isBlank()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "token is required");
        }

        try {
            authService.revokeToken(request.token());
            return ResponseEntity.ok(authDtoMapper.toLogoutResponse("Thu hồi token thành công"));
        } catch (IllegalArgumentException ex) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, ex.getMessage(), ex);
        } catch (SecurityException ex) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, ex.getMessage(), ex);
        }
    }

    @RequiredRoles({"ADMIN"})
    @GetMapping("/nhat-ky")
    public ResponseEntity<Page<AuditLogDto>> getAuditLogs(
            @RequestParam(required = false) String eventType,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) Instant from,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) Instant to,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "50") int size) {
        Page<AuditLog> logs = auditService.getLogs(eventType, from, to,
            PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "createdAt")));
        return ResponseEntity.ok(logs.map(l -> new AuditLogDto(
            l.getId().toString(), l.getEventType(), l.getActorId(),
            l.getActorUsername(), l.getTargetType(), l.getTargetId(),
            l.getDescription(), l.getOldValue(), l.getNewValue(),
            l.getIpAddress(), l.getCreatedAt()
        )));
    }

    @RequiredRoles({"ADMIN"})
    @PostMapping("/quan-tri/khoa-tai-khoan")
    public ResponseEntity<AdminResponse> lockAccount(@RequestBody AdminAccountRequest request, HttpServletRequest httpRequest) {
        if (request == null || request.username() == null || request.username().isBlank()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "username is required");
        }

        try {
            authService.lockAccount(request.username());
            final String userId = userRepository.findByUsernameIgnoreCase(request.username())
                .map(u -> u.getId().toString()).orElse(null);
            safeAudit(() -> auditService.record("ACCOUNT_LOCK", httpRequest, "USER", userId,
                "Khóa tài khoản " + request.username(), null, null));
            return ResponseEntity.ok(authDtoMapper.toAdminResponse("Khóa tài khoản thành công"));
        } catch (IllegalArgumentException ex) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, ex.getMessage(), ex);
        }
    }

    @RequiredRoles({"ADMIN"})
    @PostMapping("/quan-tri/mo-tai-khoan")
    public ResponseEntity<AdminResponse> unlockAccount(@RequestBody AdminAccountRequest request, HttpServletRequest httpRequest) {
        if (request == null || request.username() == null || request.username().isBlank()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "username is required");
        }

        try {
            authService.unlockAccount(request.username());
            final String userId = userRepository.findByUsernameIgnoreCase(request.username())
                .map(u -> u.getId().toString()).orElse(null);
            safeAudit(() -> auditService.record("ACCOUNT_UNLOCK", httpRequest, "USER", userId,
                "Mở khóa tài khoản " + request.username(), null, null));
            return ResponseEntity.ok(authDtoMapper.toAdminResponse("Mở khóa tài khoản thành công"));
        } catch (IllegalArgumentException ex) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, ex.getMessage(), ex);
        }
    }

    // Ghi audit không được phép làm hỏng thao tác chính đã thành công (đăng nhập, đăng ký...).
    // Mọi lỗi khi ghi log chỉ được cảnh báo, không ném ra ngoài.
    private void safeAudit(Runnable action) {
        try {
            action.run();
        } catch (RuntimeException ex) {
            log.warn("Ghi audit log thất bại", ex);
        }
    }

    public record LoginRequest(String username, String password, String otp) {
    }

    public record RegisterRequest(String username, String password, String role) {
    }

    public record RegisterResponse(String userId, String username, String role) {
    }

    public record SyncStatusResponse(String userId, String status, int retryCount, String lastError, String updatedAt) {
    }

    public record LoginResponse(
        String access_token,
        String token_type,
        long expires_in,
        String scope,
        boolean mfa_required,
        String mfa_method,
        String token
    ) {
    }

    public record OAuth2TokenRequest(String grantType, String username, String password, String scope, String otp) {
    }

    public record OAuth2TokenResponse(String access_token, String token_type, long expires_in, String scope) {
    }

    public record TwoFactorCredentialRequest(String username, String password) {
    }

    public record TwoFactorConfirmRequest(String username, String password, String otp) {
    }

    public record TwoFactorInitResponse(String secret, String otpAuthUri) {
    }

    public record ChangePasswordRequest(String username, String oldPassword, String newPassword) {
    }

    public record ChangePasswordResponse(String message) {
    }

    public record VerifyTokenRequest(String token) {
    }

    public record VerifyTokenResponse(boolean valid, Map<String, Object> claims) {
    }

    public record LogoutRequest(String token) {
    }

    public record LogoutResponse(String message) {
    }

    public record AdminAccountRequest(String username) {
    }

    public record UserDto(String id, String username, String role, boolean locked, String createdAt) {
    }

    public record UpdateUserRequest(String role, Boolean locked) {
    }

    public record RoleDto(String name, String description, List<String> permissions, int userCount) {
    }

    public record RoleRequest(String name, String description, List<String> permissions) {
    }

    public record AdminResponse(String message) {
    }

    public record AccountInfoResponse(
        String id,
        String username,
        String role,
        boolean locked,
        boolean twoFactorEnabled,
        Instant createdAt,
        Instant passwordUpdatedAt
    ) {
    }

    public record AuditLogDto(
        String id,
        String eventType,
        String actorId,
        String actorUsername,
        String targetType,
        String targetId,
        String description,
        String oldValue,
        String newValue,
        String ipAddress,
        Instant createdAt
    ) {
    }
}
