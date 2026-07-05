package com.hrservice.hr.repository;

import com.hrservice.hr.entity.Employee;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface EmployeeRepository extends JpaRepository<Employee, Long> {

	Optional<Employee> findByAuthUserId(String authUserId);

	Optional<Employee> findByUsernameIgnoreCase(String username);

	Optional<Employee> findByDidIgnoreCase(String did);

	List<Employee> findByDepartmentId(Long departmentId);

	long countByDepartmentId(Long departmentId);

	@Query("""
		SELECT e FROM Employee e LEFT JOIN e.department d
		WHERE (:departmentId IS NULL OR d.id = :departmentId)
		  AND (:departmentName IS NULL OR LOWER(d.name) = :departmentName)
		  AND (:status IS NULL OR UPPER(e.status) = :status)
		  AND (:keyword IS NULL
		       OR LOWER(e.name) LIKE :keyword
		       OR LOWER(e.username) LIKE :keyword
		       OR LOWER(e.position) LIKE :keyword
		       OR LOWER(e.did) LIKE :keyword)
		""")
	Page<Employee> searchEmployees(@Param("departmentId") Long departmentId,
	                               @Param("departmentName") String departmentName,
	                               @Param("status") String status,
	                               @Param("keyword") String keyword,
	                               Pageable pageable);

}
