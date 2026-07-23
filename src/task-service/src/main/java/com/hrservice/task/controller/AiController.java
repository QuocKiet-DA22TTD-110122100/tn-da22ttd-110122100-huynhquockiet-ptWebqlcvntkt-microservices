package com.hrservice.task.controller;

import com.hrservice.task.security.RequireRoles;
import com.hrservice.task.service.AiService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/v1/ai")
@RequiredArgsConstructor
@Slf4j
public class AiController {

    private final AiService aiService;

    @GetMapping("/suggestions")
    @RequireRoles({"ADMIN", "HR_MANAGER", "DEPARTMENT_HEAD", "MANAGER", "EMPLOYEE"})
    public ResponseEntity<List<AiService.Suggestion>> getSuggestions() {
        log.info("[AI] GET /v1/ai/suggestions");
        return ResponseEntity.ok(aiService.getSuggestions());
    }

    @GetMapping("/risk-radar")
    @RequireRoles({"ADMIN", "HR_MANAGER", "DEPARTMENT_HEAD", "MANAGER", "EMPLOYEE"})
    public ResponseEntity<List<AiService.RiskRadarItem>> getRiskRadar() {
        log.info("[AI] GET /v1/ai/risk-radar");
        return ResponseEntity.ok(aiService.getRiskRadar());
    }
}
