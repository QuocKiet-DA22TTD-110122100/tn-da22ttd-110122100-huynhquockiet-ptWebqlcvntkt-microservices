package com.hrservice.task.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import java.io.Serializable;

@Entity
@Table(name = "automation_rules")
public class AutomationRuleEntity implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @Column(name = "rule_id", nullable = false, length = 100)
    private String ruleId;

    @Column(name = "rule_name", nullable = false, length = 255)
    private String ruleName;

    @Column(name = "trigger_event", nullable = false, length = 100)
    private String triggerEvent;

    @Column(name = "trigger_condition", nullable = false, length = 100)
    private String triggerCondition;

    @Column(name = "action_type", nullable = false, length = 100)
    private String actionType;

    @Column(name = "action_target_status", length = 50)
    private String actionTargetStatus;

    @Column(name = "action_channel", length = 50)
    private String actionChannel;

    @Column(name = "is_enabled", nullable = false)
    private boolean isEnabled = false;

    public AutomationRuleEntity() {
    }

    public String getRuleId() {
        return ruleId;
    }

    public void setRuleId(String ruleId) {
        this.ruleId = ruleId;
    }

    public String getRuleName() {
        return ruleName;
    }

    public void setRuleName(String ruleName) {
        this.ruleName = ruleName;
    }

    public String getTriggerEvent() {
        return triggerEvent;
    }

    public void setTriggerEvent(String triggerEvent) {
        this.triggerEvent = triggerEvent;
    }

    public String getTriggerCondition() {
        return triggerCondition;
    }

    public void setTriggerCondition(String triggerCondition) {
        this.triggerCondition = triggerCondition;
    }

    public String getActionType() {
        return actionType;
    }

    public void setActionType(String actionType) {
        this.actionType = actionType;
    }

    public String getActionTargetStatus() {
        return actionTargetStatus;
    }

    public void setActionTargetStatus(String actionTargetStatus) {
        this.actionTargetStatus = actionTargetStatus;
    }

    public String getActionChannel() {
        return actionChannel;
    }

    public void setActionChannel(String actionChannel) {
        this.actionChannel = actionChannel;
    }

    public boolean isEnabled() {
        return isEnabled;
    }

    public void setEnabled(boolean enabled) {
        isEnabled = enabled;
    }
}
