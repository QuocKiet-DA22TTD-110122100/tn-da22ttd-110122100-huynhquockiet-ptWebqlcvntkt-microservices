package com.hrservice.project.dto;

import com.hrservice.project.entity.ProjectAssignment;
import jakarta.validation.constraints.NotNull;

public record ProjectAssignmentRequest(
        @NotNull(message = "employeeId là bắt buộc")
        Long employeeId,

        ProjectAssignment.ProjectRole role
) {
}
