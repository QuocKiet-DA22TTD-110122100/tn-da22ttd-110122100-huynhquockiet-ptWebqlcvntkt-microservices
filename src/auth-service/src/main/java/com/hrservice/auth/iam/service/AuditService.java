package com.hrservice.auth.iam.service;

import com.hrservice.auth.iam.entity.AuditLog;
import com.hrservice.auth.iam.repository.AuditLogRepository;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;

@Service
public class AuditService {

    private final AuditLogRepository auditLogRepository;

    public AuditService(AuditLogRepository auditLogRepository) {
        this.auditLogRepository = auditLogRepository;
    }

    @Transactional
    public void record(String eventType, String actorId, String actorUsername,
                       String targetType, String targetId, String description,
                       String oldValue, String newValue) {
        recordFull(eventType, actorId, actorUsername, targetType, targetId, description, oldValue, newValue, null);
    }

    @Transactional
    public void recordFull(String eventType, String actorId, String actorUsername,
                       String targetType, String targetId, String description,
                       String oldValue, String newValue, String ipAddress) {
        AuditLog log = new AuditLog();
        log.setEventType(eventType);
        log.setActorId(actorId);
        log.setActorUsername(actorUsername);
        log.setTargetType(targetType);
        log.setTargetId(targetId);
        log.setDescription(description);
        log.setOldValue(oldValue);
        log.setNewValue(newValue);
        log.setIpAddress(ipAddress);
        auditLogRepository.save(log);
    }

    public void record(String eventType, HttpServletRequest request,
                       String targetType, String targetId, String description,
                       String oldValue, String newValue) {
        String ip = extractIp(request);
        String actorId = extractClaim(request, "userId");
        String actorUsername = extractClaim(request, "username");
        recordFull(eventType, actorId, actorUsername, targetType, targetId, description, oldValue, newValue, ip);
    }

    @Transactional(readOnly = true)
    public Page<AuditLog> getLogs(String eventType, Instant from, Instant to, Pageable pageable) {
        if (eventType != null && !eventType.isBlank() && from != null && to != null) {
            return auditLogRepository.findByEventTypeAndCreatedAtBetween(eventType, from, to, pageable);
        }
        if (eventType != null && !eventType.isBlank()) {
            return auditLogRepository.findByEventType(eventType, pageable);
        }
        if (from != null && to != null) {
            return auditLogRepository.findByCreatedAtBetween(from, to, pageable);
        }
        return auditLogRepository.findAll(pageable);
    }

    private static String extractIp(HttpServletRequest request) {
        String xf = request.getHeader("X-Forwarded-For");
        if (xf != null && !xf.isBlank()) {
            return xf.split(",")[0].trim();
        }
        return request.getRemoteAddr();
    }

    @SuppressWarnings("unchecked")
    private static String extractClaim(HttpServletRequest request, String claim) {
        java.util.Map<String, Object> claims =
            (java.util.Map<String, Object>) request.getAttribute("currentUserClaims");
        if (claims == null) return null;
        Object val = claims.get(claim);
        return val == null ? null : String.valueOf(val);
    }
}
