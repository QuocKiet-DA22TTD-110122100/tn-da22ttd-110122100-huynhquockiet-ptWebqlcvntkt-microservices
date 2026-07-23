package com.hrservice.task.repository;

import com.hrservice.task.entity.AutomationRuleEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface AutomationRuleRepository extends JpaRepository<AutomationRuleEntity, String> {
}
