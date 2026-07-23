package com.hrservice.task.service;

import com.hrservice.task.entity.AutomationRuleEntity;
import com.hrservice.task.repository.AutomationRuleRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Service
@Slf4j
public class AutomationService {

    private final AutomationRuleRepository ruleRepository;

    public AutomationService(AutomationRuleRepository ruleRepository) {
        this.ruleRepository = ruleRepository;
    }

    @Transactional
    public AutomationRuleEntity upsertRule(AutomationRuleUpsertRequest request) {
        AutomationRuleEntity entity = ruleRepository.findById(request.ruleId())
                .orElseGet(AutomationRuleEntity::new);

        entity.setRuleId(request.ruleId());
        entity.setRuleName(request.ruleName());
        entity.setTriggerEvent(request.trigger().event());
        entity.setTriggerCondition(request.trigger().condition());
        entity.setActionType(request.action().type());
        entity.setActionTargetStatus(request.action().targetStatus());
        entity.setActionChannel(request.action().channel());
        entity.setEnabled(request.isEnabled());

        AutomationRuleEntity saved = ruleRepository.save(entity);
        log.info("[AUTOMATION] Rule {} ({}) {}", saved.getRuleId(), saved.getRuleName(),
                saved.isEnabled() ? "enabled" : "disabled");
        return saved;
    }

    @Transactional
    public AutomationRuleEntity toggleRule(String ruleId, boolean isEnabled) {
        AutomationRuleEntity entity = ruleRepository.findById(ruleId)
                .orElseThrow(() -> new IllegalArgumentException("Rule not found: " + ruleId));
        entity.setEnabled(isEnabled);
        AutomationRuleEntity saved = ruleRepository.save(entity);
        log.info("[AUTOMATION] Rule {} toggled to {}", ruleId, isEnabled);
        return saved;
    }

    public record AutomationRuleUpsertRequest(
            String ruleId,
            String ruleName,
            Trigger trigger,
            Action action,
            boolean isEnabled
    ) {
    }

    public record Trigger(String event, String condition) {
    }

    public record Action(String type, String targetStatus, String channel) {
    }

    public record RuleResponse(
            String ruleId,
            String ruleName,
            Map<String, String> trigger,
            Map<String, String> action,
            boolean isEnabled
    ) {
        public static RuleResponse fromEntity(AutomationRuleEntity entity) {
            return new RuleResponse(
                    entity.getRuleId(),
                    entity.getRuleName(),
                    Map.of("event", entity.getTriggerEvent(), "condition", entity.getTriggerCondition()),
                    Map.of("type", entity.getActionType(),
                            "target_status", entity.getActionTargetStatus() == null ? "" : entity.getActionTargetStatus(),
                            "channel", entity.getActionChannel() == null ? "" : entity.getActionChannel()),
                    entity.isEnabled()
            );
        }
    }
}
