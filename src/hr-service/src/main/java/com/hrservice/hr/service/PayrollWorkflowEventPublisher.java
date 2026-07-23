package com.hrservice.hr.service;

import com.hrservice.hr.events.PayrollApprovedEvent;
import com.hrservice.hr.events.PayrollProcessedEvent;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.ObjectProvider;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service
public class PayrollWorkflowEventPublisher {
    private static final Logger logger = LoggerFactory.getLogger(PayrollWorkflowEventPublisher.class);
    private final RabbitTemplate rabbitTemplate;

    @Autowired
    public PayrollWorkflowEventPublisher(ObjectProvider<RabbitTemplate> rabbitTemplateProvider) {
        this(rabbitTemplateProvider.getIfAvailable());
    }

    public PayrollWorkflowEventPublisher(RabbitTemplate rabbitTemplate) {
        this.rabbitTemplate = rabbitTemplate;
    }

    public void publishApproved(PayrollApprovedEvent event) {
        try {
            if (rabbitTemplate == null) {
                logger.debug("RabbitTemplate không khả dụng; bỏ qua việc công bố sự kiện payroll.approved");
                return;
            }

            rabbitTemplate.convertAndSend("payroll.workflow", "payroll.approved", event);
        } catch (Exception ex) {
            logger.warn("Không thể công bố sự kiện payroll.approved", ex);
        }
    }

    public void publishProcessed(PayrollProcessedEvent event) {
        try {
            if (rabbitTemplate == null) {
                logger.debug("RabbitTemplate không khả dụng; bỏ qua việc công bố sự kiện payroll.processed");
                return;
            }

            rabbitTemplate.convertAndSend("payroll.workflow", "payroll.processed", event);
        } catch (Exception ex) {
            logger.warn("Không thể công bố sự kiện payroll.processed", ex);
        }
    }
}
