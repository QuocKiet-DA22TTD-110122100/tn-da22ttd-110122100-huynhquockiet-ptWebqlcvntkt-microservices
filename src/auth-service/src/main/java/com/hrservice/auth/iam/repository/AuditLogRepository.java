package com.hrservice.auth.iam.repository;

import com.hrservice.auth.iam.entity.AuditLog;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.Instant;
import java.util.UUID;

@Repository
public interface AuditLogRepository extends JpaRepository<AuditLog, UUID> {

    Page<AuditLog> findByEventType(String eventType, Pageable pageable);

    Page<AuditLog> findByActorId(String actorId, Pageable pageable);

    Page<AuditLog> findByTargetTypeAndTargetId(String targetType, String targetId, Pageable pageable);

    Page<AuditLog> findByCreatedAtBetween(Instant from, Instant to, Pageable pageable);

    Page<AuditLog> findByEventTypeAndCreatedAtBetween(String eventType, Instant from, Instant to, Pageable pageable);
}
