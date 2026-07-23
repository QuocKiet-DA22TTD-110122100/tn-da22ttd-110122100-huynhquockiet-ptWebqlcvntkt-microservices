package com.hrservice.task.service.adapter;

import com.hrservice.task.config.TaskNotificationProperties;
import com.hrservice.task.event.TaskNotificationEvent;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Service;
import software.amazon.awssdk.services.sns.SnsClient;
import software.amazon.awssdk.services.sns.model.PublishRequest;

@Service
@RequiredArgsConstructor
@Slf4j
@ConditionalOnProperty(prefix = "task.notification", name = "provider", havingValue = "sns")
public class SnsNotificationAdapter implements NotificationAdapter {

    private final SnsClient snsClient;
    private final TaskNotificationProperties properties;

    @Override
    public void send(TaskNotificationEvent event, Long previousAssignee) {
        String topicArn = properties.getSnsTopicArn();
        if (topicArn == null || topicArn.isBlank()) {
            log.warn("[NOTIFICATION][SNS] topicArn is empty, skipping notification for taskId={}", event.getTaskId());
            return;
        }

        String body = "Công việc " + event.getTaskId() + " đã được gán lại từ " + previousAssignee + " cho " + event.getAssigneeId() + ". " + event.getMessage();
        try {
            snsClient.publish(PublishRequest.builder()
                    .topicArn(topicArn)
                    .subject("Gán lại công việc")
                    .message(body)
                    .build());
            log.info("[NOTIFICATION][SNS] Đã công bố gán lại cho taskId={}", event.getTaskId());
        } catch (Exception ex) {
            log.warn("[NOTIFICATION][SNS] Công bố thất bại cho taskId={}", event.getTaskId(), ex);
        }
    }
}
