package com.hrservice.hr.config;

import com.hrservice.hr.entity.*;
import com.hrservice.hr.repository.*;
import com.hrservice.hr.events.PayrollApprovedEvent;
import com.hrservice.hr.events.PayrollProcessedEvent;
import com.hrservice.hr.service.PayrollWorkflowEventPublisher;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.YearMonth;
import java.util.*;
import java.util.Objects;

@Service
@Transactional
public class PayrollService {

    private static final Logger logger = LoggerFactory.getLogger(PayrollService.class);
    private static final int SCALE = 2;

    private final PayrollResultRepository payrollResultRepository;
    private final PayrollHistoryRepository payrollHistoryRepository;
    private final TaxConfigRepository taxConfigRepository;
    private final DeductionTypeRepository deductionTypeRepository;
    private final DeductionInstanceRepository deductionInstanceRepository;
    private final EmployeeRepository employeeRepository;
    private final PayrollWorkflowEventPublisher payrollWorkflowEventPublisher;

    public PayrollService(PayrollResultRepository payrollResultRepository,
                         PayrollHistoryRepository payrollHistoryRepository,
                         TaxConfigRepository taxConfigRepository,
                         DeductionTypeRepository deductionTypeRepository,
                         DeductionInstanceRepository deductionInstanceRepository,
                         EmployeeRepository employeeRepository,
                         PayrollWorkflowEventPublisher payrollWorkflowEventPublisher) {
        this.payrollResultRepository = payrollResultRepository;
        this.payrollHistoryRepository = payrollHistoryRepository;
        this.taxConfigRepository = taxConfigRepository;
        this.deductionTypeRepository = deductionTypeRepository;
        this.deductionInstanceRepository = deductionInstanceRepository;
        this.employeeRepository = employeeRepository;
        this.payrollWorkflowEventPublisher = payrollWorkflowEventPublisher;
    }

    /**
     * Calculate payroll for a given employee and month
     */
    public PayrollResult calculatePayroll(Long employeeId, YearMonth yearMonth) throws Exception {
        Employee employee = employeeRepository.findById(employeeId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy nhân viên: " + employeeId));

        if (employee.getBaseSalary() == null) {
            throw new IllegalArgumentException("Nhân viên chưa được cấu hình lương cơ bản");
        }

        LocalDate periodStart = yearMonth.atDay(1);
        LocalDate periodEnd = yearMonth.atEndOfMonth();

        // Calculate gross pay
        BigDecimal grossPay = calculateGrossPay(employee, yearMonth);

        // Calculate tax deduction
        BigDecimal taxDeduction = calculateTaxDeduction(grossPay, employee.getCurrency() != null ? employee.getCurrency() : "USD");

        // Calculate other deductions (insurance, retirement, etc)
        Map<String, BigDecimal> deductions = calculateDeductions(employeeId, grossPay, yearMonth);

        BigDecimal insuranceDeduction = deductions.getOrDefault("insurance", BigDecimal.ZERO);
        BigDecimal otherDeduction = deductions.getOrDefault("other", BigDecimal.ZERO);

        BigDecimal totalDeduction = taxDeduction.add(insuranceDeduction).add(otherDeduction);
        BigDecimal netPay = grossPay.subtract(totalDeduction);

        // Create payroll result
        PayrollResult result = new PayrollResult();
        result.setEmployee(employee);
        result.setPeriodStartDate(periodStart);
        result.setPeriodEndDate(periodEnd);
        result.setGrossPay(grossPay);
        result.setTaxDeduction(taxDeduction);
        result.setInsuranceDeduction(insuranceDeduction);
        result.setOtherDeduction(otherDeduction);
        result.setTotalDeduction(totalDeduction);
        result.setNetPay(netPay);
        result.setStatus("DRAFT");

        // Save result
        PayrollResult saved = payrollResultRepository.save(result);
        logger.info("Payroll calculated for employee {} for period {}", employeeId, yearMonth);

        return saved;
    }

    /**
     * Calculate gross pay (base salary / 12 for monthly)
     */
    private BigDecimal calculateGrossPay(Employee employee, YearMonth yearMonth) {
        if (employee.getBaseSalary() == null) {
            return BigDecimal.ZERO;
        }
        return employee.getBaseSalary()
                .divide(new BigDecimal(12), SCALE, RoundingMode.HALF_UP);
    }

    /**
     * Calculate tax based on gross pay and tax brackets
     */
    private BigDecimal calculateTaxDeduction(BigDecimal grossPay, String country) {
        LocalDate now = LocalDate.now();
        List<TaxConfig> taxBrackets = taxConfigRepository
                .findByYearAndCountryAndIsActiveTrue(now.getYear(), country);

        if (taxBrackets.isEmpty()) {
            logger.warn("No active tax config for {} {}", now.getYear(), country);
            return BigDecimal.ZERO;
        }

        taxBrackets.sort(Comparator.comparing(TaxConfig::getMinBracket));

        BigDecimal totalTax = BigDecimal.ZERO;
        BigDecimal remainingIncome = grossPay;

        for (TaxConfig bracket : taxBrackets) {
            if (remainingIncome.compareTo(BigDecimal.ZERO) <= 0) {
                break;
            }

            BigDecimal bracketMin = bracket.getMinBracket();
            BigDecimal bracketMax = bracket.getMaxBracket();

            BigDecimal taxableInThisBracket;
            if (bracketMax == null) {
                taxableInThisBracket = remainingIncome;
            } else {
                taxableInThisBracket = remainingIncome.min(bracketMax.subtract(bracketMin));
            }

            BigDecimal taxOnBracket = taxableInThisBracket
                    .multiply(bracket.getTaxRate())
                    .divide(new BigDecimal(100), SCALE, RoundingMode.HALF_UP);

            totalTax = totalTax.add(taxOnBracket);
            remainingIncome = remainingIncome.subtract(taxableInThisBracket);
        }

        return totalTax;
    }

    /**
     * Calculate all deductions (insurance, retirement, etc)
     */
    private Map<String, BigDecimal> calculateDeductions(Long employeeId, BigDecimal grossPay, YearMonth yearMonth) {
        LocalDate periodStart = yearMonth.atDay(1);
        LocalDate periodEnd = yearMonth.atEndOfMonth();

        List<DeductionInstance> deductions = deductionInstanceRepository
                .findByEmployeeIdAndIsActiveTrueAndStartDateLessThanEqualAndEndDateGreaterThanEqualOrderByDeductionTypeNameAsc(
                        employeeId, periodStart, periodEnd);

        Map<String, BigDecimal> result = new HashMap<>();
        BigDecimal insurance = BigDecimal.ZERO;
        BigDecimal other = BigDecimal.ZERO;

        for (DeductionInstance deduction : deductions) {
            if (deduction == null || deduction.getDeductionType() == null || deduction.getRate() == null) {
                continue;
            }
            BigDecimal amount;
            Boolean isPercentage = deduction.getDeductionType().getIsPercentage();
            if (Boolean.TRUE.equals(isPercentage)) {
                amount = grossPay.multiply(deduction.getRate())
                        .divide(new BigDecimal(100), SCALE, RoundingMode.HALF_UP);
            } else {
                amount = deduction.getRate();
            }

            String category = deduction.getDeductionType().getCategory();
            if ("INSURANCE".equalsIgnoreCase(String.valueOf(category))) {
                insurance = insurance.add(amount);
            } else {
                other = other.add(amount);
            }
        }

        result.put("insurance", insurance);
        result.put("other", other);
        return result;
    }

    /**
     * Approve payroll (mark as APPROVED)
     */
        public PayrollResult approvePayroll(Long payrollId, String approvedBy) throws Exception {
        PayrollResult payroll = payrollResultRepository.findById(payrollId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy bảng lương: " + payrollId));

        ensurePayrollStatus(payroll, "DRAFT", "Bảng lương không ở trạng thái DRAFT");

        validatePayrollCompliance(payroll);

        payroll.setStatus("APPROVED");
        payroll.setApprovedBy(normalizeActor(approvedBy));
        payroll.setApprovedAt(LocalDateTime.now());
        PayrollResult updated = payrollResultRepository.save(payroll);

        recordPayrollHistory(updated, "APPROVED", approvedBy, "Bảng lương đã được phê duyệt để xử lý");
        payrollWorkflowEventPublisher.publishApproved(new PayrollApprovedEvent(
            updated.getId(),
            normalizeActor(approvedBy),
            updated.getApprovedAt()
        ));

        logger.info("Payroll {} approved by {}", payrollId, approvedBy);
        return updated;
    }

        /**
         * Reject payroll back to DRAFT.
         */
        public PayrollResult rejectPayroll(Long payrollId, String reason, String rejectorEmail) {
        PayrollResult payroll = payrollResultRepository.findById(payrollId)
            .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy bảng lương: " + payrollId));

        ensurePayrollStatus(payroll, "APPROVED", "Bảng lương không ở trạng thái APPROVED");

        String normalizedReason = normalizeReason(reason);
        payroll.setStatus("DRAFT");
        payroll.setApprovedBy(null);
        payroll.setApprovedAt(null);
        payroll.setProcessedBy(null);
        payroll.setProcessedAt(null);
        payroll.setRemarks(normalizedReason);

        PayrollResult updated = payrollResultRepository.save(payroll);
        recordPayrollHistory(updated, "REJECTED", rejectorEmail, normalizedReason);

        logger.info("Payroll {} rejected by {}", payrollId, rejectorEmail);
        return updated;
        }

        /**
         * Process payroll (mark as PROCESSED and publish event)
         */
        public PayrollResult processPayroll(Long payrollId, String processorEmail) {
        PayrollResult payroll = payrollResultRepository.findById(payrollId)
            .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy bảng lương: " + payrollId));

        ensurePayrollStatus(payroll, "APPROVED", "Bảng lương không ở trạng thái APPROVED");

        payroll.setStatus("PROCESSED");
        payroll.setProcessedBy(normalizeActor(processorEmail));
        payroll.setProcessedAt(LocalDateTime.now());

        PayrollResult updated = payrollResultRepository.save(payroll);
        recordPayrollHistory(updated, "PROCESSED", processorEmail, "Bảng lương đã hoàn tất và khóa");
        payrollWorkflowEventPublisher.publishProcessed(new PayrollProcessedEvent(
            updated.getId(),
            updated.getEmployee().getId(),
            updated.getGrossPay(),
            updated.getNetPay(),
            normalizeActor(processorEmail),
            updated.getProcessedAt()
        ));

        logger.info("Payroll {} processed by {}", payrollId, processorEmail);
        return updated;
        }

    /**
     * Validate payroll compliance
     */
    public void validatePayrollCompliance(PayrollResult payroll) throws Exception {
        Objects.requireNonNull(payroll, "bảng lương là bắt buộc");
        BigDecimal netPay = payroll.getNetPay();
        BigDecimal grossPay = payroll.getGrossPay();

        if (netPay == null || grossPay == null) {
            throw new IllegalArgumentException("Lương gross và net phải có để kiểm tra tuân thủ");
        }

        if (netPay.compareTo(grossPay) > 0) {
            throw new IllegalArgumentException("Lương net không được vượt quá lương gross");
        }

        BigDecimal minNetPay = grossPay.multiply(new BigDecimal("0.50"));
        if (netPay.compareTo(minNetPay) < 0) {
            logger.warn("Cảnh báo: Lương net < 50% lương gross. Mã bảng lương: {}", payroll.getId());
        }

        BigDecimal taxDeduction = payroll.getTaxDeduction() == null ? BigDecimal.ZERO : payroll.getTaxDeduction();
        if (taxDeduction.compareTo(BigDecimal.ZERO) < 0) {
            throw new IllegalArgumentException("Khấu trừ thuế không được âm");
        }

        BigDecimal maxTax = grossPay.multiply(new BigDecimal("0.40"));
        if (taxDeduction.compareTo(maxTax) > 0) {
            logger.warn("Cảnh báo: Thuế > 40% lương gross. Mã bảng lương: {}", payroll.getId());
        }

        logger.info("Payroll {} passed compliance validation", payroll.getId());
    }

    /**
     * Record payroll history event
     */
    private void recordPayrollHistory(PayrollResult payroll, String eventType, String actionBy, String details) {
        PayrollHistory history = new PayrollHistory();
        history.setPayrollResult(payroll);
        history.setEmployee(payroll.getEmployee());
        history.setEventType(eventType);
        history.setActionBy(actionBy);
        history.setChangeDetails(details);
        history.setPreviousGross(payroll.getGrossPay());
        history.setPreviousNet(payroll.getNetPay());

        payrollHistoryRepository.save(history);
        logger.info("Recorded history: {} for payroll {}", eventType, payroll.getId());
    }

    private void ensurePayrollStatus(PayrollResult payroll, String expectedStatus, String errorMessage) {
        if (!expectedStatus.equals(payroll.getStatus())) {
            throw new IllegalStateException(errorMessage + ": trạng thái hiện tại là " + payroll.getStatus());
        }
    }

    private String normalizeActor(String value) {
        if (value == null || value.isBlank()) {
            return "SYSTEM";
        }
        return value.trim();
    }

    private String normalizeReason(String reason) {
        if (reason == null || reason.isBlank()) {
            throw new IllegalArgumentException("lý do là bắt buộc");
        }
        String normalized = reason.trim();
        if (normalized.length() > 500) {
            throw new IllegalArgumentException("lý do phải từ 500 ký tự trở xuống");
        }
        return normalized;
    }

    /**
     * Get payroll history for employee
     */
    public List<PayrollResult> getEmployeePayrollHistory(Long employeeId) {
        return payrollResultRepository.findByEmployeeIdAndStatusOrderByPeriodStartDateDesc(
                employeeId, "PROCESSED");
    }

    /**
     * Get latest payroll for employee
     */
    public Optional<PayrollResult> getLatestPayroll(Long employeeId) {
        return payrollResultRepository.findLatestByEmployeeId(employeeId);
    }
}
