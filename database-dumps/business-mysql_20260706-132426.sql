-- MySQL dump 10.13  Distrib 8.0.45, for Linux (x86_64)
--
-- Host: localhost    Database: project_db
-- ------------------------------------------------------
-- Server version	8.0.45

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `project_db`
--

/*!40000 DROP DATABASE IF EXISTS `project_db`*/;

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `project_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `project_db`;

--
-- Table structure for table `project_assignments`
--

DROP TABLE IF EXISTS `project_assignments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `project_assignments` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `active` bit(1) NOT NULL,
  `assigned_at` datetime(6) NOT NULL,
  `employee_id` bigint NOT NULL,
  `role` enum('DEVELOPER','MANAGER','MEMBER','QA') NOT NULL,
  `project_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_project_employee` (`project_id`,`employee_id`),
  CONSTRAINT `FKbwds7sls0j9asmsm2do8cn8co` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=65 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_assignments`
--

LOCK TABLES `project_assignments` WRITE;
/*!40000 ALTER TABLE `project_assignments` DISABLE KEYS */;
INSERT INTO `project_assignments` (`id`, `active`, `assigned_at`, `employee_id`, `role`, `project_id`) VALUES (1,_binary '','2025-10-01 08:00:00.000000',1,'MANAGER',1);
INSERT INTO `project_assignments` (`id`, `active`, `assigned_at`, `employee_id`, `role`, `project_id`) VALUES (2,_binary '','2025-10-05 08:00:00.000000',4,'DEVELOPER',1);
INSERT INTO `project_assignments` (`id`, `active`, `assigned_at`, `employee_id`, `role`, `project_id`) VALUES (3,_binary '','2025-10-05 08:00:00.000000',5,'DEVELOPER',1);
INSERT INTO `project_assignments` (`id`, `active`, `assigned_at`, `employee_id`, `role`, `project_id`) VALUES (4,_binary '','2025-10-10 08:00:00.000000',7,'DEVELOPER',1);
INSERT INTO `project_assignments` (`id`, `active`, `assigned_at`, `employee_id`, `role`, `project_id`) VALUES (5,_binary '','2025-12-01 08:00:00.000000',9,'DEVELOPER',2);
INSERT INTO `project_assignments` (`id`, `active`, `assigned_at`, `employee_id`, `role`, `project_id`) VALUES (6,_binary '','2025-10-10 08:00:00.000000',5,'QA',2);
INSERT INTO `project_assignments` (`id`, `active`, `assigned_at`, `employee_id`, `role`, `project_id`) VALUES (7,_binary '','2026-01-15 08:00:00.000000',8,'QA',2);
INSERT INTO `project_assignments` (`id`, `active`, `assigned_at`, `employee_id`, `role`, `project_id`) VALUES (8,_binary '','2025-12-01 08:00:00.000000',3,'MANAGER',3);
INSERT INTO `project_assignments` (`id`, `active`, `assigned_at`, `employee_id`, `role`, `project_id`) VALUES (9,_binary '','2025-12-05 08:00:00.000000',6,'DEVELOPER',3);
INSERT INTO `project_assignments` (`id`, `active`, `assigned_at`, `employee_id`, `role`, `project_id`) VALUES (10,_binary '','2025-12-10 08:00:00.000000',10,'MEMBER',3);
INSERT INTO `project_assignments` (`id`, `active`, `assigned_at`, `employee_id`, `role`, `project_id`) VALUES (11,_binary '','2026-01-15 08:00:00.000000',9,'MANAGER',4);
INSERT INTO `project_assignments` (`id`, `active`, `assigned_at`, `employee_id`, `role`, `project_id`) VALUES (12,_binary '','2025-11-20 08:00:00.000000',11,'MEMBER',4);
INSERT INTO `project_assignments` (`id`, `active`, `assigned_at`, `employee_id`, `role`, `project_id`) VALUES (13,_binary '','2025-12-01 08:00:00.000000',7,'QA',2);
INSERT INTO `project_assignments` (`id`, `active`, `assigned_at`, `employee_id`, `role`, `project_id`) VALUES (14,_binary '','2025-12-01 08:00:00.000000',22,'MEMBER',2);
INSERT INTO `project_assignments` (`id`, `active`, `assigned_at`, `employee_id`, `role`, `project_id`) VALUES (17,_binary '','2025-12-05 08:00:00.000000',15,'DEVELOPER',3);
INSERT INTO `project_assignments` (`id`, `active`, `assigned_at`, `employee_id`, `role`, `project_id`) VALUES (20,_binary '','2026-01-20 08:00:00.000000',15,'DEVELOPER',4);
INSERT INTO `project_assignments` (`id`, `active`, `assigned_at`, `employee_id`, `role`, `project_id`) VALUES (21,_binary '','2026-01-20 08:00:00.000000',21,'DEVELOPER',4);
INSERT INTO `project_assignments` (`id`, `active`, `assigned_at`, `employee_id`, `role`, `project_id`) VALUES (22,_binary '','2026-02-01 08:00:00.000000',23,'DEVELOPER',4);
INSERT INTO `project_assignments` (`id`, `active`, `assigned_at`, `employee_id`, `role`, `project_id`) VALUES (23,_binary '','2026-01-25 08:00:00.000000',16,'QA',4);
INSERT INTO `project_assignments` (`id`, `active`, `assigned_at`, `employee_id`, `role`, `project_id`) VALUES (24,_binary '','2026-01-20 08:00:00.000000',8,'MEMBER',4);
INSERT INTO `project_assignments` (`id`, `active`, `assigned_at`, `employee_id`, `role`, `project_id`) VALUES (25,_binary '\0','2025-08-01 08:00:00.000000',19,'MANAGER',5);
INSERT INTO `project_assignments` (`id`, `active`, `assigned_at`, `employee_id`, `role`, `project_id`) VALUES (26,_binary '\0','2025-08-05 08:00:00.000000',14,'DEVELOPER',5);
INSERT INTO `project_assignments` (`id`, `active`, `assigned_at`, `employee_id`, `role`, `project_id`) VALUES (27,_binary '\0','2025-08-05 08:00:00.000000',6,'DEVELOPER',5);
INSERT INTO `project_assignments` (`id`, `active`, `assigned_at`, `employee_id`, `role`, `project_id`) VALUES (28,_binary '\0','2025-08-10 08:00:00.000000',7,'QA',5);
INSERT INTO `project_assignments` (`id`, `active`, `assigned_at`, `employee_id`, `role`, `project_id`) VALUES (29,_binary '\0','2025-06-01 08:00:00.000000',26,'MANAGER',6);
INSERT INTO `project_assignments` (`id`, `active`, `assigned_at`, `employee_id`, `role`, `project_id`) VALUES (30,_binary '\0','2025-06-05 08:00:00.000000',11,'DEVELOPER',6);
INSERT INTO `project_assignments` (`id`, `active`, `assigned_at`, `employee_id`, `role`, `project_id`) VALUES (31,_binary '\0','2025-06-05 08:00:00.000000',17,'DEVELOPER',6);
INSERT INTO `project_assignments` (`id`, `active`, `assigned_at`, `employee_id`, `role`, `project_id`) VALUES (32,_binary '\0','2025-06-10 08:00:00.000000',5,'MEMBER',6);
INSERT INTO `project_assignments` (`id`, `active`, `assigned_at`, `employee_id`, `role`, `project_id`) VALUES (33,_binary '','2026-03-01 08:00:00.000000',25,'MANAGER',7);
INSERT INTO `project_assignments` (`id`, `active`, `assigned_at`, `employee_id`, `role`, `project_id`) VALUES (34,_binary '','2026-03-05 08:00:00.000000',14,'DEVELOPER',7);
INSERT INTO `project_assignments` (`id`, `active`, `assigned_at`, `employee_id`, `role`, `project_id`) VALUES (35,_binary '','2026-03-05 08:00:00.000000',11,'DEVELOPER',7);
INSERT INTO `project_assignments` (`id`, `active`, `assigned_at`, `employee_id`, `role`, `project_id`) VALUES (36,_binary '','2026-03-10 08:00:00.000000',22,'MEMBER',7);
INSERT INTO `project_assignments` (`id`, `active`, `assigned_at`, `employee_id`, `role`, `project_id`) VALUES (37,_binary '','2026-06-01 08:00:00.000000',27,'MANAGER',9);
INSERT INTO `project_assignments` (`id`, `active`, `assigned_at`, `employee_id`, `role`, `project_id`) VALUES (38,_binary '','2026-06-02 08:00:00.000000',2,'DEVELOPER',9);
INSERT INTO `project_assignments` (`id`, `active`, `assigned_at`, `employee_id`, `role`, `project_id`) VALUES (39,_binary '','2026-06-02 08:00:00.000000',10,'MEMBER',9);
INSERT INTO `project_assignments` (`id`, `active`, `assigned_at`, `employee_id`, `role`, `project_id`) VALUES (40,_binary '','2026-06-03 08:00:00.000000',12,'MEMBER',9);
INSERT INTO `project_assignments` (`id`, `active`, `assigned_at`, `employee_id`, `role`, `project_id`) VALUES (41,_binary '','2026-06-03 08:00:00.000000',18,'MEMBER',9);
INSERT INTO `project_assignments` (`id`, `active`, `assigned_at`, `employee_id`, `role`, `project_id`) VALUES (42,_binary '','2026-06-03 08:00:00.000000',20,'MEMBER',9);
INSERT INTO `project_assignments` (`id`, `active`, `assigned_at`, `employee_id`, `role`, `project_id`) VALUES (43,_binary '','2026-06-03 08:00:00.000000',24,'MANAGER',10);
INSERT INTO `project_assignments` (`id`, `active`, `assigned_at`, `employee_id`, `role`, `project_id`) VALUES (44,_binary '','2026-06-04 08:00:00.000000',6,'DEVELOPER',10);
INSERT INTO `project_assignments` (`id`, `active`, `assigned_at`, `employee_id`, `role`, `project_id`) VALUES (45,_binary '','2026-06-04 08:00:00.000000',7,'QA',10);
INSERT INTO `project_assignments` (`id`, `active`, `assigned_at`, `employee_id`, `role`, `project_id`) VALUES (46,_binary '','2026-06-05 08:00:00.000000',15,'DEVELOPER',10);
INSERT INTO `project_assignments` (`id`, `active`, `assigned_at`, `employee_id`, `role`, `project_id`) VALUES (47,_binary '','2026-06-05 08:00:00.000000',21,'DEVELOPER',10);
INSERT INTO `project_assignments` (`id`, `active`, `assigned_at`, `employee_id`, `role`, `project_id`) VALUES (48,_binary '','2026-06-06 08:00:00.000000',23,'DEVELOPER',10);
INSERT INTO `project_assignments` (`id`, `active`, `assigned_at`, `employee_id`, `role`, `project_id`) VALUES (49,_binary '','2026-06-06 08:00:00.000000',28,'MEMBER',10);
INSERT INTO `project_assignments` (`id`, `active`, `assigned_at`, `employee_id`, `role`, `project_id`) VALUES (50,_binary '','2026-06-05 08:00:00.000000',16,'MANAGER',11);
INSERT INTO `project_assignments` (`id`, `active`, `assigned_at`, `employee_id`, `role`, `project_id`) VALUES (51,_binary '','2026-06-06 08:00:00.000000',11,'DEVELOPER',11);
INSERT INTO `project_assignments` (`id`, `active`, `assigned_at`, `employee_id`, `role`, `project_id`) VALUES (52,_binary '','2026-06-06 08:00:00.000000',17,'DEVELOPER',11);
INSERT INTO `project_assignments` (`id`, `active`, `assigned_at`, `employee_id`, `role`, `project_id`) VALUES (53,_binary '','2026-06-07 08:00:00.000000',22,'MEMBER',11);
INSERT INTO `project_assignments` (`id`, `active`, `assigned_at`, `employee_id`, `role`, `project_id`) VALUES (54,_binary '','2026-06-07 08:00:00.000000',25,'MEMBER',11);
INSERT INTO `project_assignments` (`id`, `active`, `assigned_at`, `employee_id`, `role`, `project_id`) VALUES (55,_binary '','2026-06-07 08:00:00.000000',26,'MEMBER',11);
INSERT INTO `project_assignments` (`id`, `active`, `assigned_at`, `employee_id`, `role`, `project_id`) VALUES (56,_binary '','2026-06-07 08:00:00.000000',25,'MANAGER',12);
INSERT INTO `project_assignments` (`id`, `active`, `assigned_at`, `employee_id`, `role`, `project_id`) VALUES (57,_binary '','2026-06-08 08:00:00.000000',14,'DEVELOPER',12);
INSERT INTO `project_assignments` (`id`, `active`, `assigned_at`, `employee_id`, `role`, `project_id`) VALUES (58,_binary '','2026-06-08 08:00:00.000000',19,'MEMBER',12);
INSERT INTO `project_assignments` (`id`, `active`, `assigned_at`, `employee_id`, `role`, `project_id`) VALUES (59,_binary '','2026-06-08 08:00:00.000000',1,'MEMBER',12);
INSERT INTO `project_assignments` (`id`, `active`, `assigned_at`, `employee_id`, `role`, `project_id`) VALUES (60,_binary '','2026-06-09 08:00:00.000000',3,'MEMBER',12);
INSERT INTO `project_assignments` (`id`, `active`, `assigned_at`, `employee_id`, `role`, `project_id`) VALUES (61,_binary '','2026-06-09 08:00:00.000000',4,'MEMBER',12);
INSERT INTO `project_assignments` (`id`, `active`, `assigned_at`, `employee_id`, `role`, `project_id`) VALUES (62,_binary '','2026-06-09 08:00:00.000000',5,'MEMBER',12);
INSERT INTO `project_assignments` (`id`, `active`, `assigned_at`, `employee_id`, `role`, `project_id`) VALUES (63,_binary '','2026-06-10 08:00:00.000000',8,'MEMBER',12);
INSERT INTO `project_assignments` (`id`, `active`, `assigned_at`, `employee_id`, `role`, `project_id`) VALUES (64,_binary '','2026-06-10 08:00:00.000000',9,'MEMBER',12);
/*!40000 ALTER TABLE `project_assignments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `projects`
--

DROP TABLE IF EXISTS `projects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `projects` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) NOT NULL,
  `description` text,
  `lead_id` bigint NOT NULL,
  `name` varchar(255) NOT NULL,
  `status` enum('ACTIVE','ARCHIVED','COMPLETED','PAUSED') NOT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `projects`
--

LOCK TABLES `projects` WRITE;
/*!40000 ALTER TABLE `projects` DISABLE KEYS */;
INSERT INTO `projects` (`id`, `created_at`, `description`, `lead_id`, `name`, `status`, `updated_at`) VALUES (1,'2026-06-05 17:09:04.901198','Nâng cấp toàn diện nền tảng quản lý nhân sự: employee lifecycle, phân quyền RBAC, API chuẩn hoá. Là dự án nền tảng cho toàn hệ thống ECC.',3,'ECC HR Platform v2.0','ACTIVE','2026-07-06 06:09:52.253123');
INSERT INTO `projects` (`id`, `created_at`, `description`, `lead_id`, `name`, `status`, `updated_at`) VALUES (2,'2026-06-06 04:26:12.440478','Tự động hoá quy trình tính lương, quản lý khấu trừ BHXH/BHYT/BHTN, thuế TNCN luỹ tiến, phê duyệt bảng lương đa cấp và xuất báo cáo quyết toán.',9,'Payroll Automation System','ACTIVE','2026-07-06 06:09:52.253123');
INSERT INTO `projects` (`id`, `created_at`, `description`, `lead_id`, `name`, `status`, `updated_at`) VALUES (3,'2026-06-06 04:26:12.440478','Cổng tự phục vụ dành cho nhân viên: xem hợp đồng, phiếu lương, yêu cầu nghỉ phép, cập nhật thông tin cá nhân và theo dõi KPI.',3,'Employee Self-Service Portal','PAUSED','2026-07-06 06:09:52.253123');
INSERT INTO `projects` (`id`, `created_at`, `description`, `lead_id`, `name`, `status`, `updated_at`) VALUES (4,'2026-06-06 04:26:12.440478','Ứng dụng di động (iOS/Android) cho quản lý dự án và task theo thời gian thực, thông báo push, check-in địa điểm và báo cáo nhanh.',9,'ECC Mobile App','ACTIVE','2026-07-06 06:09:52.253123');
INSERT INTO `projects` (`id`, `created_at`, `description`, `lead_id`, `name`, `status`, `updated_at`) VALUES (5,'2025-08-01 08:00:00.000000','Tích hợp hệ thống CRM nội bộ với Salesforce: đồng bộ khách hàng, cơ hội kinh doanh, lịch sử tương tác và báo cáo doanh số tự động.',19,'CRM Integration','COMPLETED','2026-07-06 06:09:52.253123');
INSERT INTO `projects` (`id`, `created_at`, `description`, `lead_id`, `name`, `status`, `updated_at`) VALUES (6,'2025-06-01 08:00:00.000000','Di chuyển toàn bộ hạ tầng on-premise sang AWS (EKS + RDS + S3 + CloudFront). Bao gồm CI/CD pipeline, blue-green deployment và disaster recovery.',26,'Cloud Infrastructure Migration','COMPLETED','2026-07-06 06:09:52.253123');
INSERT INTO `projects` (`id`, `created_at`, `description`, `lead_id`, `name`, `status`, `updated_at`) VALUES (7,'2026-03-01 08:00:00.000000','Xây dựng hệ thống phân tích dữ liệu nhân sự và kinh doanh với Grafana, Metabase và pipeline ETL từ MySQL/PostgreSQL sang Data Warehouse.',25,'Data Analytics Dashboard','ACTIVE','2026-07-06 06:09:52.253123');
INSERT INTO `projects` (`id`, `created_at`, `description`, `lead_id`, `name`, `status`, `updated_at`) VALUES (9,'2026-06-01 08:00:00.000000','Hop nhat quy trinh noi bo: onboarding, yeu cau noi bo, asset tracking va bao cao van hanh.',27,'Internal Operations Hub','ACTIVE','2026-07-05 08:18:04.203519');
INSERT INTO `projects` (`id`, `created_at`, `description`, `lead_id`, `name`, `status`, `updated_at`) VALUES (10,'2026-06-03 08:00:00.000000','Mo rong nang luc ho tro khach hang: knowledge base, SLA, ticket routing va bao cao chat luong.',24,'Customer Support Scale-up','ACTIVE','2026-07-05 08:18:04.203519');
INSERT INTO `projects` (`id`, `created_at`, `description`, `lead_id`, `name`, `status`, `updated_at`) VALUES (11,'2026-06-05 08:00:00.000000','Tang cuong an toan he thong: secrets rotation, audit log, dependency scan va incident playbook.',16,'Security and Compliance Hardening','ACTIVE','2026-07-05 08:18:04.203519');
INSERT INTO `projects` (`id`, `created_at`, `description`, `lead_id`, `name`, `status`, `updated_at`) VALUES (12,'2026-06-07 08:00:00.000000','Tong hop so lieu nhan su, project va task vao bo bao cao quan tri cho ban lanh dao.',25,'Data and Reporting Hub','ACTIVE','2026-07-05 08:18:04.203519');
/*!40000 ALTER TABLE `projects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'project_db'
--

--
-- Current Database: `task_db`
--

/*!40000 DROP DATABASE IF EXISTS `task_db`*/;

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `task_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `task_db`;

--
-- Table structure for table `automation_rules`
--

DROP TABLE IF EXISTS `automation_rules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `automation_rules` (
  `rule_id` varchar(100) NOT NULL,
  `action_channel` varchar(50) DEFAULT NULL,
  `action_target_status` varchar(50) DEFAULT NULL,
  `action_type` varchar(100) NOT NULL,
  `is_enabled` bit(1) NOT NULL,
  `rule_name` varchar(255) NOT NULL,
  `trigger_condition` varchar(100) NOT NULL,
  `trigger_event` varchar(100) NOT NULL,
  PRIMARY KEY (`rule_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `automation_rules`
--

LOCK TABLES `automation_rules` WRITE;
/*!40000 ALTER TABLE `automation_rules` DISABLE KEYS */;
/*!40000 ALTER TABLE `automation_rules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `task_history`
--

DROP TABLE IF EXISTS `task_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `task_history` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `changed_at` datetime(6) NOT NULL,
  `changed_by` bigint DEFAULT NULL,
  `new_status` varchar(255) DEFAULT NULL,
  `previous_status` varchar(255) DEFAULT NULL,
  `project_id` bigint DEFAULT NULL,
  `reason` text,
  `task_id` bigint NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task_history`
--

LOCK TABLES `task_history` WRITE;
/*!40000 ALTER TABLE `task_history` DISABLE KEYS */;
INSERT INTO `task_history` (`id`, `changed_at`, `changed_by`, `new_status`, `previous_status`, `project_id`, `reason`, `task_id`) VALUES (1,'2025-10-06 08:30:00.000000',14,'IN_PROGRESS','OPEN',1,'Bắt đầu thiết kế API spec trên Swagger Editor',1);
INSERT INTO `task_history` (`id`, `changed_at`, `changed_by`, `new_status`, `previous_status`, `project_id`, `reason`, `task_id`) VALUES (2,'2025-11-20 16:00:00.000000',3,'COMPLETED','IN_PROGRESS',1,'API spec đã review và được PM approve, merge vào main',1);
INSERT INTO `task_history` (`id`, `changed_at`, `changed_by`, `new_status`, `previous_status`, `project_id`, `reason`, `task_id`) VALUES (3,'2025-10-12 08:00:00.000000',4,'IN_PROGRESS','OPEN',1,'Bắt đầu code DepartmentController và service layer',2);
INSERT INTO `task_history` (`id`, `changed_at`, `changed_by`, `new_status`, `previous_status`, `project_id`, `reason`, `task_id`) VALUES (4,'2025-12-10 15:00:00.000000',4,'COMPLETED','IN_PROGRESS',1,'Đã pass hết unit test và integration test, deploy staging',2);
INSERT INTO `task_history` (`id`, `changed_at`, `changed_by`, `new_status`, `previous_status`, `project_id`, `reason`, `task_id`) VALUES (5,'2025-11-05 09:00:00.000000',5,'IN_PROGRESS','OPEN',1,'Bắt đầu implement JWT claims middleware tại api-gateway',3);
INSERT INTO `task_history` (`id`, `changed_at`, `changed_by`, `new_status`, `previous_status`, `project_id`, `reason`, `task_id`) VALUES (6,'2025-11-18 08:00:00.000000',9,'IN_PROGRESS','OPEN',2,'Bắt đầu vẽ flowchart và định nghĩa state machine lương',9);
INSERT INTO `task_history` (`id`, `changed_at`, `changed_by`, `new_status`, `previous_status`, `project_id`, `reason`, `task_id`) VALUES (7,'2025-12-20 14:00:00.000000',27,'COMPLETED','IN_PROGRESS',2,'Tài liệu quy trình được HR Director duyệt và ký',9);
INSERT INTO `task_history` (`id`, `changed_at`, `changed_by`, `new_status`, `previous_status`, `project_id`, `reason`, `task_id`) VALUES (8,'2025-11-22 08:00:00.000000',13,'IN_PROGRESS','OPEN',2,'Bắt đầu implement thuế luỹ tiến từ TaxConfig table',10);
INSERT INTO `task_history` (`id`, `changed_at`, `changed_by`, `new_status`, `previous_status`, `project_id`, `reason`, `task_id`) VALUES (9,'2026-01-15 16:00:00.000000',13,'COMPLETED','IN_PROGRESS',2,'Đã test 150 test case, coverage 98%. Deploy production',10);
INSERT INTO `task_history` (`id`, `changed_at`, `changed_by`, `new_status`, `previous_status`, `project_id`, `reason`, `task_id`) VALUES (10,'2025-12-03 09:00:00.000000',8,'IN_PROGRESS','OPEN',3,'Bắt đầu thiết kế wireframe Figma, họp kick-off với HR',17);
INSERT INTO `task_history` (`id`, `changed_at`, `changed_by`, `new_status`, `previous_status`, `project_id`, `reason`, `task_id`) VALUES (11,'2026-01-10 16:00:00.000000',8,'COMPLETED','IN_PROGRESS',3,'Figma prototype được approve, link shared với dev team',17);
INSERT INTO `task_history` (`id`, `changed_at`, `changed_by`, `new_status`, `previous_status`, `project_id`, `reason`, `task_id`) VALUES (12,'2026-01-17 09:00:00.000000',9,'IN_PROGRESS','OPEN',4,'Họp kiến trúc, bắt đầu POC React Native + Expo',23);
INSERT INTO `task_history` (`id`, `changed_at`, `changed_by`, `new_status`, `previous_status`, `project_id`, `reason`, `task_id`) VALUES (13,'2026-02-10 16:00:00.000000',9,'COMPLETED','IN_PROGRESS',4,'POC xong, team đồng thuận tech stack, tạo repo',23);
INSERT INTO `task_history` (`id`, `changed_at`, `changed_by`, `new_status`, `previous_status`, `project_id`, `reason`, `task_id`) VALUES (14,'2026-01-22 09:00:00.000000',15,'IN_PROGRESS','OPEN',4,'Implement OAuth2 flow và TOTP 2FA trên React Native',24);
INSERT INTO `task_history` (`id`, `changed_at`, `changed_by`, `new_status`, `previous_status`, `project_id`, `reason`, `task_id`) VALUES (15,'2026-03-15 15:00:00.000000',16,'COMPLETED','IN_PROGRESS',4,'Login flow test OK trên iOS và Android, biometric hoạt động',24);
INSERT INTO `task_history` (`id`, `changed_at`, `changed_by`, `new_status`, `previous_status`, `project_id`, `reason`, `task_id`) VALUES (16,'2025-08-05 09:00:00.000000',19,'IN_PROGRESS','OPEN',5,'Bắt đầu workshop và thu thập yêu cầu từ sales team',31);
INSERT INTO `task_history` (`id`, `changed_at`, `changed_by`, `new_status`, `previous_status`, `project_id`, `reason`, `task_id`) VALUES (17,'2025-08-31 16:00:00.000000',19,'COMPLETED','IN_PROGRESS',5,'Hoàn thành tài liệu BRD và mapping schema CRM ↔ ECC',31);
INSERT INTO `task_history` (`id`, `changed_at`, `changed_by`, `new_status`, `previous_status`, `project_id`, `reason`, `task_id`) VALUES (18,'2025-06-05 08:00:00.000000',26,'IN_PROGRESS','OPEN',6,'Bắt đầu phân tích workload và thiết kế VPC architecture',37);
INSERT INTO `task_history` (`id`, `changed_at`, `changed_by`, `new_status`, `previous_status`, `project_id`, `reason`, `task_id`) VALUES (19,'2025-07-31 16:00:00.000000',1,'COMPLETED','IN_PROGRESS',6,'AWS Well-Architected Review pass, approved by CTO',37);
INSERT INTO `task_history` (`id`, `changed_at`, `changed_by`, `new_status`, `previous_status`, `project_id`, `reason`, `task_id`) VALUES (20,'2026-03-05 09:00:00.000000',25,'IN_PROGRESS','OPEN',7,'Bắt đầu thiết kế star schema, họp với stakeholders',43);
INSERT INTO `task_history` (`id`, `changed_at`, `changed_by`, `new_status`, `previous_status`, `project_id`, `reason`, `task_id`) VALUES (21,'2026-04-15 15:00:00.000000',25,'COMPLETED','IN_PROGRESS',7,'Schema đã review và approve, dbt models tạo xong',43);
INSERT INTO `task_history` (`id`, `changed_at`, `changed_by`, `new_status`, `previous_status`, `project_id`, `reason`, `task_id`) VALUES (22,'2026-03-18 09:00:00.000000',14,'IN_PROGRESS','OPEN',7,'Setup Airflow DAG, bắt đầu viết dbt models cho HR data',44);
INSERT INTO `task_history` (`id`, `changed_at`, `changed_by`, `new_status`, `previous_status`, `project_id`, `reason`, `task_id`) VALUES (23,'2026-06-02 10:00:00.000000',27,'IN_PROGRESS','OPEN',9,'Kick-off quy trinh noi bo',50);
INSERT INTO `task_history` (`id`, `changed_at`, `changed_by`, `new_status`, `previous_status`, `project_id`, `reason`, `task_id`) VALUES (24,'2026-06-04 16:00:00.000000',12,'COMPLETED','IN_PROGRESS',9,'Lich hop da duoc cap nhat va chot lich',54);
INSERT INTO `task_history` (`id`, `changed_at`, `changed_by`, `new_status`, `previous_status`, `project_id`, `reason`, `task_id`) VALUES (25,'2026-06-04 10:00:00.000000',24,'IN_PROGRESS','OPEN',10,'Bat dau xay dung knowledge base',55);
INSERT INTO `task_history` (`id`, `changed_at`, `changed_by`, `new_status`, `previous_status`, `project_id`, `reason`, `task_id`) VALUES (26,'2026-06-04 11:00:00.000000',6,'IN_PROGRESS','OPEN',10,'Da co mockup dashboard support',56);
INSERT INTO `task_history` (`id`, `changed_at`, `changed_by`, `new_status`, `previous_status`, `project_id`, `reason`, `task_id`) VALUES (27,'2026-06-05 10:00:00.000000',11,'IN_PROGRESS','OPEN',11,'Bat dau xay dung luong xoay secrets',62);
INSERT INTO `task_history` (`id`, `changed_at`, `changed_by`, `new_status`, `previous_status`, `project_id`, `reason`, `task_id`) VALUES (28,'2026-06-07 15:00:00.000000',26,'COMPLETED','OPEN',11,'Policy scan da duoc phe duyet',67);
INSERT INTO `task_history` (`id`, `changed_at`, `changed_by`, `new_status`, `previous_status`, `project_id`, `reason`, `task_id`) VALUES (29,'2026-06-08 09:30:00.000000',25,'IN_PROGRESS','OPEN',12,'Dashboard KPI da duoc khoi dong',68);
INSERT INTO `task_history` (`id`, `changed_at`, `changed_by`, `new_status`, `previous_status`, `project_id`, `reason`, `task_id`) VALUES (30,'2026-06-09 10:00:00.000000',3,'IN_PROGRESS','OPEN',12,'Bat dau tinh toan allocation report',72);
INSERT INTO `task_history` (`id`, `changed_at`, `changed_by`, `new_status`, `previous_status`, `project_id`, `reason`, `task_id`) VALUES (31,'2026-06-10 09:30:00.000000',9,'IN_PROGRESS','OPEN',12,'Ban lanh dao yeu cau ban tom tat thang',76);
INSERT INTO `task_history` (`id`, `changed_at`, `changed_by`, `new_status`, `previous_status`, `project_id`, `reason`, `task_id`) VALUES (32,'2026-06-08 12:00:00.000000',1,'IN_PROGRESS','OPEN',12,'Lam sach KPI data truoc khi import',71);
/*!40000 ALTER TABLE `task_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tasks`
--

DROP TABLE IF EXISTS `tasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tasks` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `assignee_id` bigint NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `description` text,
  `project_id` bigint NOT NULL,
  `status` enum('CANCELLED','COMPLETED','IN_PROGRESS','OPEN') NOT NULL,
  `priority` enum('HIGH','LOW','MEDIUM','URGENT') NOT NULL,
  `title` varchar(255) NOT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=77 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tasks`
--

LOCK TABLES `tasks` WRITE;
/*!40000 ALTER TABLE `tasks` DISABLE KEYS */;
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (1,14,'2026-06-05 17:09:07.018321','Định nghĩa OpenAPI 3.0 cho toàn bộ endpoint nhân viên: tạo, cập nhật, xem danh sách, vô hiệu hoá. Bao gồm phân trang và filter.',1,'COMPLETED','HIGH','Thiết kế API employee CRUD','2026-07-06 06:09:50.008770');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (2,4,'2026-06-06 04:26:43.328918','REST endpoint cho phòng ban: tạo, chỉnh sửa, xem cây tổ chức theo organization_unit. Validate unique department code.',1,'COMPLETED','HIGH','Xây dựng Department API & phân cấp','2026-07-06 06:09:50.008770');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (3,5,'2026-06-06 04:26:43.328918','Thêm JWT claims check và middleware kiểm tra quyền RBAC (READ_EMPLOYEE, WRITE_EMPLOYEE...) tại api-gateway trước khi chuyển tiếp request.',1,'IN_PROGRESS','URGENT','Tích hợp RBAC vào API Gateway','2026-07-06 06:09:50.008770');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (4,21,'2026-06-06 04:26:43.328918','Trang danh sách nhân viên với bộ lọc (phòng ban, chức vụ, trạng thái), phân trang, export Excel. Dùng DataListPage component.',1,'IN_PROGRESS','HIGH','Xây dựng Employee List UI','2026-07-06 06:09:50.008770');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (5,7,'2026-06-06 04:26:43.328918','Test Playwright cho toàn bộ luồng thêm nhân viên mới: tạo user Auth → tạo Employee HR → gán phòng ban → kiểm tra hiển thị dashboard.',1,'OPEN','HIGH','Viết test E2E cho luồng onboarding','2026-07-06 06:09:50.008770');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (6,14,'2026-06-06 04:26:43.328918','Phân tích slow query log: thêm index (department_id, status, hire_date), chuyển N+1 sang JOIN, cache Redis cho danh sách phòng ban.',1,'OPEN','MEDIUM','Tối ưu truy vấn Employee + Department','2026-07-06 06:09:50.008770');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (7,8,'2026-06-06 04:26:43.328918','Bổ sung mô tả tiếng Việt, ví dụ request/response, mã lỗi cho tất cả endpoint HR. Deploy Swagger UI lên /api-docs.',1,'OPEN','LOW','Cập nhật tài liệu API (Swagger)','2026-07-06 06:09:50.008770');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (8,16,'2026-06-06 04:26:43.328918','Kiểm tra SQL injection, XSS header, rate limit, validate input tất cả endpoint /nhan-vien và /phong-ban. Báo cáo penetration test.',1,'OPEN','URGENT','Review bảo mật endpoint nhân sự','2026-07-06 06:09:50.008770');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (9,9,'2026-06-06 04:26:43.328918','Sơ đồ luồng: DRAFT → APPROVED (Payroll Officer) → PROCESSED (HR Manager) → PAID. Định nghĩa rule & permission từng bước.',2,'COMPLETED','HIGH','Thiết kế quy trình duyệt lương đa cấp','2026-07-06 06:09:50.008770');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (10,13,'2026-06-06 04:26:43.328918','Tính thuế luỹ tiến VN 2024 từ TaxConfig. Trừ giảm trừ bản thân (11tr), gia cảnh (4.4tr/người), BHXH trước khi tính thuế.',2,'COMPLETED','URGENT','Implement engine tính thuế TNCN','2026-07-06 06:09:50.008770');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (11,4,'2026-06-06 04:26:43.328918','Trang xem bảng lương theo kỳ: lọc theo trạng thái, tải PDF phiếu lương cá nhân, tổng kết theo phòng ban.',2,'IN_PROGRESS','HIGH','Giao diện bảng lương (Payroll UI)','2026-07-06 06:09:50.008770');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (12,28,'2026-06-06 04:26:43.328918','Tạo file Excel/PDF báo cáo quyết toán thuế hàng tháng & năm theo mẫu quy định, bao gồm tổng hợp BHXH doanh nghiệp.',2,'IN_PROGRESS','HIGH','Xuất báo cáo quyết toán thuế','2026-07-06 06:09:50.008770');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (13,7,'2026-06-06 04:26:43.328918','Tạo 100+ test case tính lương: lương cơ bản, thưởng, phụ cấp, làm thêm giờ, nghỉ phép, nghỉ không lương, ốm đau...',2,'OPEN','URGENT','Kiểm thử tính lương tự động (100+ TH)','2026-07-06 06:09:50.008770');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (14,22,'2026-06-06 04:26:43.328918','Gửi email tự động khi bảng lương chuyển trạng thái (APPROVED, PROCESSED). Dùng RabbitMQ message queue, template HTML.',2,'OPEN','MEDIUM','Tích hợp thông báo duyệt lương qua email','2026-07-06 06:09:50.008770');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (15,13,'2026-06-12 02:27:28.015943','Endpoint /api/payroll/{id}/export-pdf tạo phiếu lương cá nhân định dạng A4, ký số điện tử, tải xuống hoặc gửi email.',2,'OPEN','MEDIUM','API export phiếu lương PDF','2026-07-06 06:09:50.008770');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (16,28,'2026-03-15 08:00:00.000000','Ghi PayrollHistory mỗi khi bảng lương thay đổi trạng thái. Hiển thị timeline audit trên UI. Export CSV cho kiểm toán.',2,'OPEN','LOW','Lưu lịch sử thay đổi lương (audit)','2026-07-06 06:09:50.008770');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (17,8,'2025-12-01 08:00:00.000000','Figma wireframe cho tất cả màn hình portal: trang chủ, xem lương, yêu cầu nghỉ phép, cập nhật thông tin, tra cứu nội quy.',3,'COMPLETED','HIGH','Thiết kế wireframe cổng tự phục vụ','2026-07-06 06:09:50.008770');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (18,6,'2025-12-15 08:00:00.000000','Nhân viên xem phiếu lương, lịch sử 12 tháng gần nhất, so sánh tháng trước. Yêu cầu JWT employee scope.',3,'IN_PROGRESS','HIGH','Xây dựng trang xem phiếu lương cá nhân','2026-07-06 06:09:50.008770');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (19,15,'2026-01-05 08:00:00.000000','Form yêu cầu nghỉ phép: ngày nghỉ, loại nghỉ (phép, ốm, không lương), lý do, người thay thế. Thông báo quản lý phê duyệt.',3,'OPEN','MEDIUM','Chức năng đặt lịch nghỉ phép online','2026-07-06 06:09:50.008770');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (20,15,'2026-01-10 08:00:00.000000','Nhân viên tự cập nhật số điện thoại, địa chỉ, CCCD, người liên hệ khẩn cấp. HR phê duyệt thay đổi thông tin quan trọng.',3,'OPEN','LOW','Trang hồ sơ cá nhân (tự cập nhật)','2026-07-06 06:09:50.008770');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (21,3,'2026-01-20 08:00:00.000000','Kết nối portal với auth-service qua OAuth 2.0 Authorization Code Flow. Hỗ trợ Google Workspace SSO cho nội bộ ECC.',3,'OPEN','HIGH','Tích hợp Single Sign-On (SSO)','2026-07-06 06:09:50.008770');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (22,6,'2026-01-25 08:00:00.000000','Đảm bảo toàn bộ portal hiển thị tốt trên mobile (320px-768px). Test trên iOS Safari, Android Chrome. Lighthouse ≥90.',3,'OPEN','MEDIUM','Responsive mobile layout cho portal','2026-07-06 06:09:50.008770');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (23,9,'2026-01-15 08:00:00.000000','Chọn tech stack: React Native + Expo. Thiết kế navigation, state management (Zustand), API client, push notification.',4,'COMPLETED','HIGH','Thiết kế kiến trúc Mobile App (React Native)','2026-07-06 06:09:50.008770');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (24,15,'2026-01-20 08:00:00.000000','Login screen → nhập OTP → lưu JWT token bảo mật (Keychain iOS / Keystore Android). Hỗ trợ biometric (Face ID, fingerprint).',4,'COMPLETED','URGENT','Màn hình đăng nhập & xác thực 2FA','2026-07-06 06:09:50.008770');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (25,21,'2026-02-01 08:00:00.000000','Home screen hiển thị task được giao, deadline sắp đến, tiến độ dự án, hoạt động gần đây. Pull-to-refresh, skeleton loading.',4,'IN_PROGRESS','HIGH','Dashboard tổng quan dự án & task','2026-07-06 06:09:50.008770');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (26,23,'2026-02-15 08:00:00.000000','Form tạo/sửa task: title, description, priority, assignee, deadline, project. Validate form, gọi API task-service.',4,'IN_PROGRESS','HIGH','Màn hình quản lý task (create/update)','2026-07-06 06:09:50.008770');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (27,21,'2026-03-01 08:00:00.000000','Tích hợp Firebase FCM: push khi được giao task, task deadline hôm nay, task được duyệt. Quản lý subscription theo user.',4,'OPEN','HIGH','Push notification khi task thay đổi','2026-07-06 06:09:50.008770');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (28,23,'2026-03-15 08:00:00.000000','Cache task và project data offline (SQLite). Sync tự động khi có mạng, conflict resolution cho thay đổi offline.',4,'OPEN','MEDIUM','Offline mode & data sync','2026-07-06 06:09:50.008770');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (29,16,'2026-04-01 08:00:00.000000','Test Detox E2E trên iPhone 14 và Samsung Galaxy S23. Coverage: đăng nhập, xem task, cập nhật trạng thái, push notification.',4,'OPEN','HIGH','Testing E2E trên thiết bị thật','2026-07-06 06:09:50.008770');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (30,9,'2026-05-01 08:00:00.000000','Chuẩn bị metadata, screenshot, privacy policy. Submit iOS/Android build cho review. Giải quyết feedback từ Apple/Google.',4,'OPEN','MEDIUM','App Store & Play Store submission','2026-07-06 06:09:50.008770');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (31,19,'2025-08-01 08:00:00.000000','Workshop với team kinh doanh: xác định data fields cần đồng bộ, tần suất sync, xử lý conflict, mapping schema ECC ↔ Salesforce.',5,'COMPLETED','HIGH','Phân tích yêu cầu tích hợp CRM','2026-07-06 06:09:50.008770');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (32,14,'2025-09-01 08:00:00.000000','Apache Kafka pipeline: ECC HR → Salesforce Contact sync. Xử lý dedup, error retry, dead-letter queue.',5,'COMPLETED','URGENT','Xây dựng ETL pipeline Salesforce ↔ MySQL','2026-07-06 06:09:50.008770');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (33,6,'2025-09-15 08:00:00.000000','Endpoint nhận Salesforce outbound message khi deal thắng/thua. Cập nhật HR assignments tự động.',5,'COMPLETED','HIGH','API webhook nhận update từ Salesforce','2026-07-06 06:09:50.008770');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (34,22,'2025-10-01 08:00:00.000000','Trang admin xem trạng thái đồng bộ: records synced, errors, lag time, queue depth. Alert khi sync bị lỗi >5 phút.',5,'COMPLETED','MEDIUM','Dashboard đồng bộ CRM','2026-07-06 06:09:50.008770');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (35,7,'2025-11-01 08:00:00.000000','Test toàn bộ luồng: tạo lead Salesforce → sync HR → assign employee → notify. UAT với team kinh doanh.',5,'COMPLETED','HIGH','Kiểm thử tích hợp end-to-end','2026-07-06 06:09:50.008770');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (36,19,'2026-01-15 08:00:00.000000','Deploy production, monitoring 2 tuần, viết SOP vận hành cho IT Ops, training team kinh doanh sử dụng dashboard.',5,'COMPLETED','MEDIUM','Go-live & handover tài liệu','2026-07-06 06:09:50.008770');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (37,26,'2025-06-01 08:00:00.000000','Phân tích workload, chọn AWS region ap-southeast-1, thiết kế VPC, subnet, security group, IAM roles theo Well-Architected.',6,'COMPLETED','HIGH','Lập kế hoạch di chuyển cloud (Cloud Strategy)','2026-07-06 06:09:50.008770');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (38,11,'2025-07-01 08:00:00.000000','Provision EKS 1.29 với node group auto-scaling (t3.medium). Config kubectl, Helm, ArgoCD GitOps, Horizontal Pod Autoscaler.',6,'COMPLETED','URGENT','Setup Kubernetes cluster (EKS)','2026-07-06 06:09:50.008770');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (39,17,'2025-08-01 08:00:00.000000','Migrate MySQL → Aurora MySQL 8.0, PostgreSQL → Aurora PostgreSQL 15. Zero-downtime migration dùng AWS DMS với CDC.',6,'COMPLETED','URGENT','Di chuyển database lên RDS Aurora','2026-07-06 06:09:50.008770');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (40,5,'2025-09-01 08:00:00.000000','Pipeline build Docker image → push ECR → deploy ArgoCD. Blue-green deployment, canary release, rollback tự động khi lỗi.',6,'COMPLETED','HIGH','Setup CI/CD pipeline (GitHub Actions → ECR → EKS)','2026-07-06 06:09:50.008770');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (41,11,'2025-10-01 08:00:00.000000','Prometheus + Grafana trên cluster. Alert PagerDuty khi CPU>80%, memory>90%, error rate>1%, latency p99>500ms.',6,'COMPLETED','HIGH','Cấu hình monitoring & alerting','2026-07-06 06:09:50.008770');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (42,17,'2025-11-01 08:00:00.000000','Load test 10,000 req/s bằng k6. DR drill: tắt az-1, verify traffic failover sang az-2. RTO<15 phút, RPO<5 phút.',6,'COMPLETED','URGENT','Kiểm thử tải & disaster recovery','2026-07-06 06:09:50.008770');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (43,25,'2026-03-01 08:00:00.000000','Star schema cho HR analytics: dim_employee, dim_department, fact_payroll, fact_attendance, fact_project_hours. Dùng dbt.',7,'COMPLETED','HIGH','Thiết kế Data Warehouse schema','2026-07-06 06:09:50.008770');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (44,14,'2026-03-15 08:00:00.000000','Apache Airflow DAG chạy mỗi đêm 2h: extract từ MySQL/PostgreSQL, transform dbt, load Redshift. Retry 3 lần, alert Slack.',7,'IN_PROGRESS','HIGH','Xây dựng ETL pipeline từ OLTP sang DWH','2026-07-06 06:09:50.008770');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (45,25,'2026-04-01 08:00:00.000000','Board: tổng nhân viên, tỷ lệ nghỉ việc, phân bổ theo phòng ban, biểu đồ tuyển dụng theo tháng. Drill-down theo chi nhánh.',7,'IN_PROGRESS','HIGH','Dashboard nhân sự tổng quan (Grafana)','2026-07-06 06:09:50.008770');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (46,11,'2026-04-15 08:00:00.000000','Metabase report: tổng quỹ lương, chi phí BHXH/BHYT, phân tích lương theo level/department, so sánh YoY.',7,'OPEN','MEDIUM','Dashboard lương & chi phí nhân sự','2026-07-06 06:09:50.008770');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (47,22,'2026-05-01 08:00:00.000000','Sync project_db và task_db vào DWH: fact_task (trạng thái, thời gian hoàn thành), fact_project_progress theo sprint.',7,'OPEN','MEDIUM','Tích hợp dữ liệu project & task vào DWH','2026-07-06 06:09:50.008770');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (48,25,'2026-05-15 08:00:00.000000','Row-level security trong Grafana/Metabase: HR_MANAGER xem tất cả, DEPARTMENT_HEAD xem phòng mình, EMPLOYEE xem bản thân.',7,'OPEN','LOW','Phân quyền truy cập báo cáo theo role','2026-07-06 06:09:50.008770');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (49,27,'2026-06-01 09:00:00.000000','Tao checklist chuan cho nhan su moi: tai khoan, thiet bi, quyen truy cap va phan cong nhom.',9,'OPEN','HIGH','Soan quy trinh onboarding noi bo','2026-07-05 08:18:04.282464');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (50,2,'2026-06-02 09:00:00.000000','Thiet ke form tap trung cho yeu cau HR, IT va hanh chinh; bo sung trang thai xu ly.',9,'IN_PROGRESS','HIGH','Chuan hoa luong yeu cau noi bo','2026-07-05 08:18:04.282464');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (51,10,'2026-06-02 09:00:00.000000','Doi chieu laptop, the, may in va tai san van phong theo chi nhanh.',9,'OPEN','MEDIUM','Kiem ke tai san cap nhat','2026-07-05 08:18:04.282464');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (52,18,'2026-06-03 09:00:00.000000','Kiem tra thong tin phuc loi va khoan ho tro de san sang cho ky payroll tiep theo.',9,'OPEN','HIGH','Dong bo du lieu chuyen khoan phuc loi','2026-07-05 08:18:04.282464');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (53,20,'2026-06-03 09:00:00.000000','Tao dashboard don gian cho so luong request moi, dang xu ly va da dong.',9,'OPEN','MEDIUM','Dashboard theo doi request noi bo','2026-07-05 08:18:04.282464');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (54,12,'2026-06-03 09:00:00.000000','Dinh nghia luong hop hang tuan va thong bao nhac viec cho truong nhom.',9,'COMPLETED','LOW','Lich hop nhom va nhac viec','2026-07-05 08:18:04.282464');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (55,24,'2026-06-03 09:00:00.000000','Bo sung bai viet FAQ, quy trinh tiep nhan ticket va mau tra loi nhanh.',10,'IN_PROGRESS','HIGH','Xay dung knowledge base cho support','2026-07-05 08:18:04.282464');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (56,6,'2026-06-04 09:00:00.000000','Hien thi ticket dang mo, SLA vi pham va phan bo theo agent.',10,'IN_PROGRESS','HIGH','Thiet ke giao dien support dashboard','2026-07-05 08:18:04.282464');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (57,7,'2026-06-04 09:00:00.000000','Kiem thu ky luong tat ca workflow ticket: tao, cap nhat, dong va reopen.',10,'OPEN','HIGH','Test regression support flow','2026-07-05 08:18:04.282464');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (58,15,'2026-06-05 09:00:00.000000','Bao dong va chuyen cap khi ticket qua han xu ly.',10,'OPEN','HIGH','Automation SLA escalation','2026-07-05 08:18:04.282464');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (59,21,'2026-06-05 09:00:00.000000','Xay dung API lay danh sach case va cap nhat trang thai xu ly.',10,'IN_PROGRESS','HIGH','Backend API cho case support','2026-07-05 08:18:04.282464');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (60,23,'2026-06-06 09:00:00.000000','Huong dan quy trinh support, cach phan loai ticket va quy tac ung xu.',10,'OPEN','MEDIUM','Onboarding va shadowing cho member moi','2026-07-05 08:18:04.282464');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (61,28,'2026-06-06 09:00:00.000000','Tong hop diem hai long khach hang va xep hang agent.',10,'OPEN','LOW','Bao cao CSAT theo thang','2026-07-05 08:18:04.282464');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (62,11,'2026-06-05 09:00:00.000000','Doi secrets dinh ky va ghi log cac su kien thay doi.',11,'IN_PROGRESS','URGENT','Tu dong hoa xoay secrets','2026-07-05 08:18:04.282464');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (63,16,'2026-06-06 09:00:00.000000','Kiem tra secret expose, scan image va quyen truy cap runner.',11,'OPEN','HIGH','Review bao mat CI pipeline','2026-07-05 08:18:04.282464');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (64,17,'2026-06-06 09:00:00.000000','Them audit trace cho thao tac quan trong va trich xuat forensics.',11,'OPEN','HIGH','Audit log cho he thong cloud','2026-07-05 08:18:04.282464');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (65,22,'2026-06-07 09:00:00.000000','Doi chieu role, quyen va nhom de phat hien quyen thua.',11,'OPEN','MEDIUM','Ma tran quyen truy cap','2026-07-05 08:18:04.282464');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (66,25,'2026-06-07 09:00:00.000000','Chuan hoa cac buoc xu ly su co va danh sach lien lac khi khan cap.',11,'OPEN','HIGH','Incident response playbook','2026-07-05 08:18:04.282464');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (67,26,'2026-06-07 09:00:00.000000','Bat quet dependency va bao cao loi bao mat hang ngay.',11,'COMPLETED','MEDIUM','Dependency and SAST scan policy','2026-07-05 08:18:04.282464');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (68,25,'2026-06-07 09:00:00.000000','Dashboard tong hop so lieu nhan su, chi phi va tien do du an.',12,'IN_PROGRESS','HIGH','Executive KPI dashboard','2026-07-05 08:18:04.282464');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (69,14,'2026-06-08 09:00:00.000000','Phan tich ty le nghi viec va xuat so sanh giua cac phong ban.',12,'OPEN','HIGH','Turnover analytics theo phong ban','2026-07-05 08:18:04.282464');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (70,19,'2026-06-08 09:00:00.000000','Tong hop du lieu pipeline kinh doanh va mapping sang nhan su phu trach.',12,'OPEN','MEDIUM','Revenue pipeline overview','2026-07-05 08:18:04.282464');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (71,1,'2026-06-08 09:00:00.000000','Lam sach du lieu KPI de dong bo voi DWH.',12,'OPEN','MEDIUM','Normalize department KPI data','2026-07-05 08:18:04.282464');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (72,3,'2026-06-09 09:00:00.000000','Tong hop so nguoi tren moi du an va canh bao team qua tai.',12,'IN_PROGRESS','HIGH','Project allocation report','2026-07-05 08:18:04.282464');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (73,4,'2026-06-09 09:00:00.000000','Loc cac task qua han va de xuat xu ly nhanh.',12,'OPEN','HIGH','Task aging cleanup','2026-07-05 08:18:04.282464');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (74,5,'2026-06-09 09:00:00.000000','Xuat bao cao sprint de gui ban lanh dao vao cuoi tuan.',12,'OPEN','LOW','Sprint status export','2026-07-05 08:18:04.282464');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (75,8,'2026-06-10 09:00:00.000000','Dong bo cay to chuc va phong ban sang dashboard quan tri.',12,'OPEN','MEDIUM','Org chart sync job','2026-07-05 08:18:04.282464');
INSERT INTO `tasks` (`id`, `assignee_id`, `created_at`, `description`, `project_id`, `status`, `priority`, `title`, `updated_at`) VALUES (76,9,'2026-06-10 09:00:00.000000','Tao ban tom tat thang cho ban lanh dao, gom nhan su, du an va chi phi.',12,'OPEN','HIGH','Monthly leadership summary','2026-07-05 08:18:04.282464');
/*!40000 ALTER TABLE `tasks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'task_db'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-07-06  6:24:33
