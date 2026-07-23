package com.hrservice.task.service;

import com.hrservice.task.entity.Task;
import com.hrservice.task.repository.TaskRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@Slf4j
public class AiService {

    private static final List<Task.TaskPriority> HIGH_PRIORITIES = List.of(Task.TaskPriority.HIGH, Task.TaskPriority.URGENT);
    private static final int MAX_SUGGESTIONS = 5;
    private static final int MAX_RISK_RADAR = 5;

    private final TaskRepository taskRepository;

    public AiService(TaskRepository taskRepository) {
        this.taskRepository = taskRepository;
    }

    public List<Suggestion> getSuggestions() {
        List<Task> incompleteTasks = taskRepository.findByStatusNot(Task.TaskStatus.COMPLETED);

        Map<Long, List<Task>> tasksByAssignee = incompleteTasks.stream()
                .filter(t -> t.getAssigneeId() != null)
                .collect(Collectors.groupingBy(Task::getAssigneeId));

        return tasksByAssignee.entrySet().stream()
                .map(entry -> {
                    Long assigneeId = entry.getKey();
                    int count = entry.getValue().size();
                    return new Suggestion(
                            "suggestion-" + assigneeId,
                            String.valueOf(assigneeId),
                            "Assignee #" + assigneeId,
                            count + " task chưa hoàn thành. Nên giảm task mới hoặc tách việc ưu tiên cao.",
                            count,
                            Math.min(96, 62 + count * 7)
                    );
                })
                .sorted(Comparator.<Suggestion, Integer>comparing(s -> s.workload).reversed())
                .limit(MAX_SUGGESTIONS)
                .toList();
    }

    public List<RiskRadarItem> getRiskRadar() {
        List<Task> highPriorityTasks = taskRepository.findByPriorityIn(HIGH_PRIORITIES);

        Map<Long, List<Task>> tasksByProject = highPriorityTasks.stream()
                .filter(t -> t.getProjectId() != null)
                .collect(Collectors.groupingBy(Task::getProjectId));

        return tasksByProject.entrySet().stream()
                .map(entry -> {
                    Long projectId = entry.getKey();
                    List<Task> tasks = entry.getValue();
                    int highCount = tasks.size();
                    long completedCount = tasks.stream()
                            .filter(t -> t.getStatus() == Task.TaskStatus.COMPLETED)
                            .count();
                    int progress = tasks.isEmpty() ? 0 : (int) (completedCount * 100 / tasks.size());
                    return new RiskRadarItem(
                            "risk-project-" + projectId,
                            projectId,
                            "Project #" + projectId,
                            highCount > 2 ? "danger" : "warning",
                            highCount + " task ưu tiên cao, " + progress + "% done.",
                            highCount,
                            progress
                    );
                })
                .sorted(Comparator.<RiskRadarItem, Integer>comparing(r -> r.highPriorityTaskCount).reversed())
                .limit(MAX_RISK_RADAR)
                .toList();
    }

    public record Suggestion(String id, String assigneeId, String title, String reason, int workload, int confidence) {
    }

    public record RiskRadarItem(String id, Long projectId, String projectName, String severity, String summary, int highPriorityTaskCount, int progress) {
    }
}
