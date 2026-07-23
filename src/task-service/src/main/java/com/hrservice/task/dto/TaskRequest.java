package com.hrservice.task.dto;

import com.hrservice.task.entity.Task;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public record TaskRequest(
        @NotBlank(message = "tiêu đề là bắt buộc")
        @Size(max = 255, message = "tiêu đề không được vượt quá 255 ký tự")
        String title,

        @Size(max = 2000, message = "mô tả không được vượt quá 2000 ký tự")
        String description,

        Task.TaskStatus status,

        Task.TaskPriority priority,

        @NotNull(message = "assigneeId là bắt buộc")
        Long assigneeId,

        @NotNull(message = "projectId là bắt buộc")
        Long projectId
) {}
