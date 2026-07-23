package com.hrservice.project.dto;

import com.hrservice.project.entity.Project;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public record ProjectRequest(
        @NotBlank(message = "tên là bắt buộc")
        @Size(max = 255, message = "tên không được vượt quá 255 ký tự")
        String name,

        @Size(max = 2000, message = "mô tả không được vượt quá 2000 ký tự")
        String description,

        Project.ProjectStatus status,

        @NotNull(message = "leadId là bắt buộc")
        Long leadId
) {}
