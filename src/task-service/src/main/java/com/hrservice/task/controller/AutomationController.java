package com.hrservice.task.controller;

import com.hrservice.task.security.RequireRoles;
import com.hrservice.task.service.AutomationService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@RequestMapping("/v1/automation/rules")
@RequiredArgsConstructor
@Slf4j
public class AutomationController {

    private final AutomationService automationService;

    @PostMapping
    @RequireRoles({"ADMIN", "HR_MANAGER", "MANAGER"})
    public ResponseEntity<AutomationService.RuleResponse> createRule(
            @RequestBody AutomationService.AutomationRuleUpsertRequest request) {
        log.info("[AUTOMATION] POST /v1/automation/rules - ruleId: {}", request.ruleId());
        var saved = automationService.upsertRule(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(AutomationService.RuleResponse.fromEntity(saved));
    }

    @PatchMapping("/{ruleId}")
    @RequireRoles({"ADMIN", "HR_MANAGER", "MANAGER"})
    public ResponseEntity<AutomationService.RuleResponse> updateRuleState(
            @PathVariable String ruleId,
            @RequestBody Map<String, Boolean> body) {
        boolean isEnabled = body.getOrDefault("is_enabled", false);
        log.info("[AUTOMATION] PATCH /v1/automation/rules/{} - enabled: {}", ruleId, isEnabled);
        var saved = automationService.toggleRule(ruleId, isEnabled);
        return ResponseEntity.ok(AutomationService.RuleResponse.fromEntity(saved));
    }
}
