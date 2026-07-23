package com.hrservice.task.service.adapter;

import com.hrservice.task.config.TaskNotificationProperties;
import com.hrservice.task.event.TaskNotificationEvent;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
@Slf4j
@ConditionalOnProperty(prefix = "task.notification", name = "provider", havingValue = "email")
public class EmailNotificationAdapter implements NotificationAdapter {

    private final JavaMailSender mailSender;
    private final AssigneeEmailResolver assigneeEmailResolver;
    private final TaskNotificationProperties properties;

    @Override
    public void send(TaskNotificationEvent event, Long previousAssignee) {
        String to = assigneeEmailResolver.resolve(event.getAssigneeId());
        if (to == null || to.isBlank()) {
            log.warn("[NOTIFICATION][EMAIL] Không thể phân giải email cho assigneeId={}, bỏ qua", event.getAssigneeId());
            return;
        }

        SimpleMailMessage msg = new SimpleMailMessage();
        msg.setFrom(properties.getEmailFrom());
        msg.setTo(to);
        msg.setSubject("Công việc được gán lại: " + event.getTaskId());
        msg.setText("Công việc " + event.getTaskId() + " đã được gán lại từ " + previousAssignee + " cho " + event.getAssigneeId() + ". " + event.getMessage());

        try {
            mailSender.send(msg);
            log.info("[NOTIFICATION][EMAIL] Đã gửi email gán lại cho taskId={} đến={}", event.getTaskId(), to);
        } catch (Exception ex) {
            log.warn("[NOTIFICATION][EMAIL] Gửi email thất bại cho taskId={}", event.getTaskId(), ex);
        }
    }
}
