package com.hrservice.hr.util;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ResponseStatusException;

@Component
public class SecurityValidator {

    @Value("${app.internal-secret}")
    private String internalSecret;

    public void enforceGatewayAccess(HttpServletRequest request) {
        String incomingSecret = request.getHeader("X-Internal-Secret");
        if (incomingSecret == null || !incomingSecret.equals(internalSecret)) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Thông tin xác thực không hợp lệ hoặc thiếu header X-Internal-Secret");
        }
    }

    public void enforceAdminRole(HttpServletRequest request) {
        String role = normalize(request.getHeader("X-Auth-Role"));
        String roles = request.getHeader("X-Auth-Roles");
        boolean isAdmin = "ADMIN".equals(role)
            || "ROLE_ADMIN".equals(role)
            || containsRole(roles, "ADMIN")
            || containsRole(roles, "ROLE_ADMIN");

        if (!isAdmin) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Yêu cầu vai trò quản trị viên");
        }
    }

    public void enforcePayrollAccess(HttpServletRequest request) {
        String role = normalize(request.getHeader("X-Auth-Role"));
        String roles = request.getHeader("X-Auth-Roles");
        boolean allowed = "HR_ADMIN".equals(role)
            || "ROLE_HR_ADMIN".equals(role)
            || "HR_MANAGER".equals(role)
            || "ROLE_HR_MANAGER".equals(role)
            || "PAYROLL_OFFICER".equals(role)
            || "ROLE_PAYROLL_OFFICER".equals(role)
            || "ADMIN".equals(role)
            || "ROLE_ADMIN".equals(role)
            || containsRole(roles, "HR_ADMIN")
            || containsRole(roles, "ROLE_HR_ADMIN")
            || containsRole(roles, "HR_MANAGER")
            || containsRole(roles, "ROLE_HR_MANAGER")
            || containsRole(roles, "PAYROLL_OFFICER")
            || containsRole(roles, "ROLE_PAYROLL_OFFICER")
            || containsRole(roles, "ADMIN")
            || containsRole(roles, "ROLE_ADMIN");

        if (!allowed) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Yêu cầu vai trò HR admin, HR manager, payroll officer hoặc admin");
        }
    }

    public void enforcePayrollOfficerOrAdmin(HttpServletRequest request) {
        String role = normalize(request.getHeader("X-Auth-Role"));
        String roles = request.getHeader("X-Auth-Roles");
        boolean allowed = "PAYROLL_OFFICER".equals(role)
            || "ROLE_PAYROLL_OFFICER".equals(role)
            || "ADMIN".equals(role)
            || "ROLE_ADMIN".equals(role)
            || containsRole(roles, "PAYROLL_OFFICER")
            || containsRole(roles, "ROLE_PAYROLL_OFFICER")
            || containsRole(roles, "ADMIN")
            || containsRole(roles, "ROLE_ADMIN");

        if (!allowed) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Yêu cầu vai trò payroll officer hoặc admin");
        }
    }

    public void enforceComplianceOfficerOrAdmin(HttpServletRequest request) {
        String role = normalize(request.getHeader("X-Auth-Role"));
        String roles = request.getHeader("X-Auth-Roles");
        boolean allowed = "COMPLIANCE_OFFICER".equals(role)
            || "ROLE_COMPLIANCE_OFFICER".equals(role)
            || "ADMIN".equals(role)
            || "ROLE_ADMIN".equals(role)
            || containsRole(roles, "COMPLIANCE_OFFICER")
            || containsRole(roles, "ROLE_COMPLIANCE_OFFICER")
            || containsRole(roles, "ADMIN")
            || containsRole(roles, "ROLE_ADMIN");

        if (!allowed) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Yêu cầu vai trò compliance officer hoặc admin");
        }
    }

    private String normalize(String value) {
        return value == null ? "" : value.trim().toUpperCase();
    }

    private boolean containsRole(String roles, String targetRole) {
        if (roles == null || roles.isBlank()) {
            return false;
        }
        String[] rolesArray = roles.split("[,;\\s]+");
        String normalized = targetRole.trim().toUpperCase();
        for (String role : rolesArray) {
            if (compare(role.trim(), normalized)) {
                return true;
            }
        }
        return false;
    }

    private boolean compare(String a, String b) {
        return a.equalsIgnoreCase(b);
    }
}
