package com.hrservice.eureka.validation;

import org.apache.commons.validator.routines.InetAddressValidator;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

import com.hrservice.eureka.Domain.model.InstanceInfo;

import java.net.MalformedURLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Validator for service instance registration data.
 * 
 * This class validates instance information to ensure all required
 * fields are present and properly formatted before registration.
 */
@Component
public class RegistrationValidator {
    
    /**
     * Validates instance information for registration.
     * 
     * @param instance the instance to validate
     * @return validation result containing any errors found
     */
    public ValidationResult validate(InstanceInfo instance) {
        ValidationResult result = new ValidationResult();
        
        if (instance == null) {
            result.addError("Thông tin instance là bắt buộc");
            return result;
        }
        
        // Validate required fields
        validateRequiredFields(instance, result);
        
        // Validate field formats
        validateFieldFormats(instance, result);
        
        // Validate port ranges
        validatePorts(instance, result);
        
        // Validate URLs if provided
        validateUrls(instance, result);
        
        return result;
    }
    
    private void validateRequiredFields(InstanceInfo instance, ValidationResult result) {
        if (!StringUtils.hasText(instance.getAppName())) {
            result.addError("Tên ứng dụng là bắt buộc");
        }
        
        if (!StringUtils.hasText(instance.getInstanceId())) {
            result.addError("Mã instance là bắt buộc");
        }
        
        if (!StringUtils.hasText(instance.getIpAddr())) {
            result.addError("Địa chỉ IP là bắt buộc");
        }
        
        if (instance.getStatus() == null) {
            result.addError("Trạng thái instance là bắt buộc");
        }
        
        if (instance.getLeaseInfo() == null) {
            result.addError("Thông tin lease là bắt buộc");
        }
    }
    
    private void validateFieldFormats(InstanceInfo instance, ValidationResult result) {
        // Validate IP address format
        if (StringUtils.hasText(instance.getIpAddr()) && 
            !isValidIpAddress(instance.getIpAddr())) {
            result.addError("Định dạng địa chỉ IP không hợp lệ: " + instance.getIpAddr());
        }
        
        // Validate application name format (alphanumeric, hyphens, underscores)
        if (StringUtils.hasText(instance.getAppName()) && 
            !instance.getAppName().matches("^[a-zA-Z0-9_-]+$")) {
            result.addError("Tên ứng dụng chỉ được chứa ký tự chữ-số, dấu gạch ngang và gạch dưới");
        }
        
        // Validate instance ID format
        if (StringUtils.hasText(instance.getInstanceId()) && 
            instance.getInstanceId().length() > 255) {
            result.addError("Mã instance không được vượt quá 255 ký tự");
        }
    }
    
    private void validatePorts(InstanceInfo instance, ValidationResult result) {
        // Validate port range
        if (instance.getPort() < 1 || instance.getPort() > 65535) {
            result.addError("Cổng phải từ 1 đến 65535, nhận: " + instance.getPort());
        }
        
        // Validate secure port range if specified
        if (instance.getSecurePort() > 0 && 
            (instance.getSecurePort() < 1 || instance.getSecurePort() > 65535)) {
            result.addError("Cổng bảo mật phải từ 1 đến 65535, nhận: " + instance.getSecurePort());
        }
    }
    
    private void validateUrls(InstanceInfo instance, ValidationResult result) {
        // Validate health check URL if provided
        if (StringUtils.hasText(instance.getHealthCheckUrl()) && 
            !isValidUrl(instance.getHealthCheckUrl())) {
            result.addError("Định dạng URL kiểm tra sức khỏe không hợp lệ: " + instance.getHealthCheckUrl());
        }
        
        // Validate status page URL if provided
        if (StringUtils.hasText(instance.getStatusPageUrl()) && 
            !isValidUrl(instance.getStatusPageUrl())) {
            result.addError("Định dạng URL trang trạng thái không hợp lệ: " + instance.getStatusPageUrl());
        }
        
        // Validate home page URL if provided
        if (StringUtils.hasText(instance.getHomePageUrl()) && 
            !isValidUrl(instance.getHomePageUrl())) {
            result.addError("Định dạng URL trang chủ không hợp lệ: " + instance.getHomePageUrl());
        }
        
        // Validate secure health check URL if provided
        if (StringUtils.hasText(instance.getSecureHealthCheckUrl()) && 
            !isValidUrl(instance.getSecureHealthCheckUrl())) {
            result.addError("Định dạng URL kiểm tra sức khỏe bảo mật không hợp lệ: " + instance.getSecureHealthCheckUrl());
        }
    }
    
    private boolean isValidIpAddress(String ip) {
        return InetAddressValidator.getInstance().isValidInet4Address(ip) ||
               InetAddressValidator.getInstance().isValidInet6Address(ip);
    }
    
    private boolean isValidUrl(String url) {
        try {
            new java.net.URI(url).toURL();
            return true;
        } catch (MalformedURLException | java.net.URISyntaxException | IllegalArgumentException e) {
            return false;
        }
    }
    
    /**
     * Validation result containing any errors found during validation.
     */
    public static class ValidationResult {
        private final List<String> errors = new ArrayList<>();
        
        public void addError(String error) {
            errors.add(error);
        }
        
        public List<String> getErrors() {
            return new ArrayList<>(errors);
        }
        
        public boolean hasErrors() {
            return !errors.isEmpty();
        }
        
        public boolean isValid() {
            return errors.isEmpty();
        }
        
        public String getErrorMessage() {
            if (errors.isEmpty()) {
                return null;
            }
            return String.join("; ", errors);
        }
        
        @Override
        public String toString() {
            return "ValidationResult{" +
                    "valid=" + isValid() +
                    ", errors=" + errors +
                    '}';
        }
    }
}