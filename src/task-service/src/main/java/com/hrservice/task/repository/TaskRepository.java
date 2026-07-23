package com.hrservice.task.repository;

import com.hrservice.task.entity.Task;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TaskRepository extends JpaRepository<Task, Long> {
    List<Task> findByProjectId(Long projectId);
    List<Task> findByAssigneeId(Long assigneeId);
    List<Task> findByStatus(Task.TaskStatus status);
    List<Task> findByStatusNot(Task.TaskStatus status);
    List<Task> findByPriorityIn(List<Task.TaskPriority> priorities);
    List<Task> findByProjectIdAndPriorityIn(Long projectId, List<Task.TaskPriority> priorities);
    long countByAssigneeIdAndStatusNot(Long assigneeId, Task.TaskStatus status);
}
