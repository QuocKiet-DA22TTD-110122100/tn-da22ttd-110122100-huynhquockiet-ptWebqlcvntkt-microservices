-- MySQL dump 10.13  Distrib 8.0.45, for Linux (x86_64)
--
-- Host: localhost    Database: hr_service
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
-- Current Database: `hr_service`
--

/*!40000 DROP DATABASE IF EXISTS `hr_service`*/;

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `hr_service` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `hr_service`;

--
-- Table structure for table `deduction_instance`
--

DROP TABLE IF EXISTS `deduction_instance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `deduction_instance` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `end_date` date DEFAULT NULL,
  `is_active` bit(1) DEFAULT NULL,
  `rate` decimal(5,2) NOT NULL,
  `start_date` date DEFAULT NULL,
  `deduction_type_id` bigint NOT NULL,
  `employee_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK3ts8eyhjymjiwgi5rx19rtd8n` (`deduction_type_id`),
  KEY `FKog7rnrdpw3al3msy9yn33h5x3` (`employee_id`),
  CONSTRAINT `FK3ts8eyhjymjiwgi5rx19rtd8n` FOREIGN KEY (`deduction_type_id`) REFERENCES `deduction_type` (`id`),
  CONSTRAINT `FKog7rnrdpw3al3msy9yn33h5x3` FOREIGN KEY (`employee_id`) REFERENCES `employee` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `deduction_instance`
--

LOCK TABLES `deduction_instance` WRITE;
/*!40000 ALTER TABLE `deduction_instance` DISABLE KEYS */;
INSERT INTO `deduction_instance` (`id`, `end_date`, `is_active`, `rate`, `start_date`, `deduction_type_id`, `employee_id`) VALUES (1,NULL,_binary '',8.00,'2022-01-10',1,1);
INSERT INTO `deduction_instance` (`id`, `end_date`, `is_active`, `rate`, `start_date`, `deduction_type_id`, `employee_id`) VALUES (2,NULL,_binary '',1.50,'2022-01-10',2,1);
INSERT INTO `deduction_instance` (`id`, `end_date`, `is_active`, `rate`, `start_date`, `deduction_type_id`, `employee_id`) VALUES (3,NULL,_binary '',1.00,'2022-01-10',3,1);
INSERT INTO `deduction_instance` (`id`, `end_date`, `is_active`, `rate`, `start_date`, `deduction_type_id`, `employee_id`) VALUES (4,NULL,_binary '',8.00,'2022-04-01',1,2);
INSERT INTO `deduction_instance` (`id`, `end_date`, `is_active`, `rate`, `start_date`, `deduction_type_id`, `employee_id`) VALUES (5,NULL,_binary '',1.50,'2022-04-01',2,2);
INSERT INTO `deduction_instance` (`id`, `end_date`, `is_active`, `rate`, `start_date`, `deduction_type_id`, `employee_id`) VALUES (6,NULL,_binary '',1.00,'2022-04-01',3,2);
INSERT INTO `deduction_instance` (`id`, `end_date`, `is_active`, `rate`, `start_date`, `deduction_type_id`, `employee_id`) VALUES (7,NULL,_binary '',8.00,'2022-05-15',1,3);
INSERT INTO `deduction_instance` (`id`, `end_date`, `is_active`, `rate`, `start_date`, `deduction_type_id`, `employee_id`) VALUES (8,NULL,_binary '',1.50,'2022-05-15',2,3);
INSERT INTO `deduction_instance` (`id`, `end_date`, `is_active`, `rate`, `start_date`, `deduction_type_id`, `employee_id`) VALUES (9,NULL,_binary '',1.00,'2022-05-15',3,3);
INSERT INTO `deduction_instance` (`id`, `end_date`, `is_active`, `rate`, `start_date`, `deduction_type_id`, `employee_id`) VALUES (10,NULL,_binary '',8.00,'2023-06-01',1,4);
INSERT INTO `deduction_instance` (`id`, `end_date`, `is_active`, `rate`, `start_date`, `deduction_type_id`, `employee_id`) VALUES (11,NULL,_binary '',1.50,'2023-06-01',2,4);
INSERT INTO `deduction_instance` (`id`, `end_date`, `is_active`, `rate`, `start_date`, `deduction_type_id`, `employee_id`) VALUES (12,NULL,_binary '',1.00,'2023-06-01',3,4);
INSERT INTO `deduction_instance` (`id`, `end_date`, `is_active`, `rate`, `start_date`, `deduction_type_id`, `employee_id`) VALUES (13,NULL,_binary '',8.00,'2023-07-10',1,5);
INSERT INTO `deduction_instance` (`id`, `end_date`, `is_active`, `rate`, `start_date`, `deduction_type_id`, `employee_id`) VALUES (14,NULL,_binary '',1.50,'2023-07-10',2,5);
INSERT INTO `deduction_instance` (`id`, `end_date`, `is_active`, `rate`, `start_date`, `deduction_type_id`, `employee_id`) VALUES (15,NULL,_binary '',1.00,'2023-07-10',3,5);
INSERT INTO `deduction_instance` (`id`, `end_date`, `is_active`, `rate`, `start_date`, `deduction_type_id`, `employee_id`) VALUES (16,NULL,_binary '',8.00,'2023-08-21',1,6);
INSERT INTO `deduction_instance` (`id`, `end_date`, `is_active`, `rate`, `start_date`, `deduction_type_id`, `employee_id`) VALUES (17,NULL,_binary '',1.50,'2023-08-21',2,6);
INSERT INTO `deduction_instance` (`id`, `end_date`, `is_active`, `rate`, `start_date`, `deduction_type_id`, `employee_id`) VALUES (18,NULL,_binary '',1.00,'2023-08-21',3,6);
INSERT INTO `deduction_instance` (`id`, `end_date`, `is_active`, `rate`, `start_date`, `deduction_type_id`, `employee_id`) VALUES (19,NULL,_binary '',8.00,'2023-09-05',1,7);
INSERT INTO `deduction_instance` (`id`, `end_date`, `is_active`, `rate`, `start_date`, `deduction_type_id`, `employee_id`) VALUES (20,NULL,_binary '',1.50,'2023-09-05',2,7);
INSERT INTO `deduction_instance` (`id`, `end_date`, `is_active`, `rate`, `start_date`, `deduction_type_id`, `employee_id`) VALUES (21,NULL,_binary '',1.00,'2023-09-05',3,7);
INSERT INTO `deduction_instance` (`id`, `end_date`, `is_active`, `rate`, `start_date`, `deduction_type_id`, `employee_id`) VALUES (22,NULL,_binary '',8.00,'2023-05-02',1,8);
INSERT INTO `deduction_instance` (`id`, `end_date`, `is_active`, `rate`, `start_date`, `deduction_type_id`, `employee_id`) VALUES (23,NULL,_binary '',1.50,'2023-05-02',2,8);
INSERT INTO `deduction_instance` (`id`, `end_date`, `is_active`, `rate`, `start_date`, `deduction_type_id`, `employee_id`) VALUES (24,NULL,_binary '',1.00,'2023-05-02',3,8);
INSERT INTO `deduction_instance` (`id`, `end_date`, `is_active`, `rate`, `start_date`, `deduction_type_id`, `employee_id`) VALUES (25,NULL,_binary '',8.00,'2023-03-11',1,9);
INSERT INTO `deduction_instance` (`id`, `end_date`, `is_active`, `rate`, `start_date`, `deduction_type_id`, `employee_id`) VALUES (26,NULL,_binary '',1.50,'2023-03-11',2,9);
INSERT INTO `deduction_instance` (`id`, `end_date`, `is_active`, `rate`, `start_date`, `deduction_type_id`, `employee_id`) VALUES (27,NULL,_binary '',1.00,'2023-03-11',3,9);
INSERT INTO `deduction_instance` (`id`, `end_date`, `is_active`, `rate`, `start_date`, `deduction_type_id`, `employee_id`) VALUES (28,NULL,_binary '',8.00,'2024-01-08',1,10);
INSERT INTO `deduction_instance` (`id`, `end_date`, `is_active`, `rate`, `start_date`, `deduction_type_id`, `employee_id`) VALUES (29,NULL,_binary '',1.50,'2024-01-08',2,10);
INSERT INTO `deduction_instance` (`id`, `end_date`, `is_active`, `rate`, `start_date`, `deduction_type_id`, `employee_id`) VALUES (30,NULL,_binary '',1.00,'2024-01-08',3,10);
INSERT INTO `deduction_instance` (`id`, `end_date`, `is_active`, `rate`, `start_date`, `deduction_type_id`, `employee_id`) VALUES (31,NULL,_binary '',8.00,'2023-11-14',1,11);
INSERT INTO `deduction_instance` (`id`, `end_date`, `is_active`, `rate`, `start_date`, `deduction_type_id`, `employee_id`) VALUES (32,NULL,_binary '',1.50,'2023-11-14',2,11);
INSERT INTO `deduction_instance` (`id`, `end_date`, `is_active`, `rate`, `start_date`, `deduction_type_id`, `employee_id`) VALUES (33,NULL,_binary '',1.00,'2023-11-14',3,11);
INSERT INTO `deduction_instance` (`id`, `end_date`, `is_active`, `rate`, `start_date`, `deduction_type_id`, `employee_id`) VALUES (34,NULL,_binary '',8.00,'2023-05-15',1,13);
INSERT INTO `deduction_instance` (`id`, `end_date`, `is_active`, `rate`, `start_date`, `deduction_type_id`, `employee_id`) VALUES (35,NULL,_binary '',1.50,'2023-05-15',2,13);
INSERT INTO `deduction_instance` (`id`, `end_date`, `is_active`, `rate`, `start_date`, `deduction_type_id`, `employee_id`) VALUES (36,NULL,_binary '',1.00,'2023-05-15',3,13);
INSERT INTO `deduction_instance` (`id`, `end_date`, `is_active`, `rate`, `start_date`, `deduction_type_id`, `employee_id`) VALUES (37,NULL,_binary '',8.00,'2023-10-15',1,14);
INSERT INTO `deduction_instance` (`id`, `end_date`, `is_active`, `rate`, `start_date`, `deduction_type_id`, `employee_id`) VALUES (38,NULL,_binary '',1.50,'2023-10-15',2,14);
INSERT INTO `deduction_instance` (`id`, `end_date`, `is_active`, `rate`, `start_date`, `deduction_type_id`, `employee_id`) VALUES (39,NULL,_binary '',1.00,'2023-10-15',3,14);
INSERT INTO `deduction_instance` (`id`, `end_date`, `is_active`, `rate`, `start_date`, `deduction_type_id`, `employee_id`) VALUES (40,NULL,_binary '',8.00,'2023-03-20',1,15);
INSERT INTO `deduction_instance` (`id`, `end_date`, `is_active`, `rate`, `start_date`, `deduction_type_id`, `employee_id`) VALUES (41,NULL,_binary '',1.50,'2023-03-20',2,15);
INSERT INTO `deduction_instance` (`id`, `end_date`, `is_active`, `rate`, `start_date`, `deduction_type_id`, `employee_id`) VALUES (42,NULL,_binary '',1.00,'2023-03-20',3,15);
INSERT INTO `deduction_instance` (`id`, `end_date`, `is_active`, `rate`, `start_date`, `deduction_type_id`, `employee_id`) VALUES (43,NULL,_binary '',8.00,'2023-02-28',1,16);
INSERT INTO `deduction_instance` (`id`, `end_date`, `is_active`, `rate`, `start_date`, `deduction_type_id`, `employee_id`) VALUES (44,NULL,_binary '',1.50,'2023-02-28',2,16);
INSERT INTO `deduction_instance` (`id`, `end_date`, `is_active`, `rate`, `start_date`, `deduction_type_id`, `employee_id`) VALUES (45,NULL,_binary '',1.00,'2023-02-28',3,16);
/*!40000 ALTER TABLE `deduction_instance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `deduction_type`
--

DROP TABLE IF EXISTS `deduction_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `deduction_type` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `category` varchar(50) NOT NULL,
  `default_rate` decimal(5,2) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `employer_contribution_rate` decimal(5,2) DEFAULT NULL,
  `is_active` bit(1) DEFAULT NULL,
  `is_mandatory` bit(1) DEFAULT NULL,
  `is_percentage` bit(1) DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK3a3p5id3r4csmfg62rbcdt4la` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `deduction_type`
--

LOCK TABLES `deduction_type` WRITE;
/*!40000 ALTER TABLE `deduction_type` DISABLE KEYS */;
INSERT INTO `deduction_type` (`id`, `category`, `default_rate`, `description`, `employer_contribution_rate`, `is_active`, `is_mandatory`, `is_percentage`, `name`) VALUES (1,'INSURANCE',8.00,'BHXH người lao động đóng hàng tháng',0.00,_binary '',_binary '',_binary '','Bảo hiểm xã hội (NLĐ)');
INSERT INTO `deduction_type` (`id`, `category`, `default_rate`, `description`, `employer_contribution_rate`, `is_active`, `is_mandatory`, `is_percentage`, `name`) VALUES (2,'INSURANCE',1.50,'BHYT người lao động đóng hàng tháng',0.00,_binary '',_binary '',_binary '','Bảo hiểm y tế (NLĐ)');
INSERT INTO `deduction_type` (`id`, `category`, `default_rate`, `description`, `employer_contribution_rate`, `is_active`, `is_mandatory`, `is_percentage`, `name`) VALUES (3,'INSURANCE',1.00,'BHTN người lao động đóng hàng tháng',0.00,_binary '',_binary '',_binary '','Bảo hiểm thất nghiệp (NLĐ)');
INSERT INTO `deduction_type` (`id`, `category`, `default_rate`, `description`, `employer_contribution_rate`, `is_active`, `is_mandatory`, `is_percentage`, `name`) VALUES (4,'INSURANCE',0.00,'BHXH doanh nghiệp đóng cho nhân viên',17.50,_binary '',_binary '',_binary '','BHXH Người sử dụng lao động');
INSERT INTO `deduction_type` (`id`, `category`, `default_rate`, `description`, `employer_contribution_rate`, `is_active`, `is_mandatory`, `is_percentage`, `name`) VALUES (5,'INSURANCE',0.00,'BHYT doanh nghiệp đóng cho nhân viên',3.00,_binary '',_binary '',_binary '','BHYT Người sử dụng lao động');
INSERT INTO `deduction_type` (`id`, `category`, `default_rate`, `description`, `employer_contribution_rate`, `is_active`, `is_mandatory`, `is_percentage`, `name`) VALUES (6,'INSURANCE',0.00,'BHTN doanh nghiệp đóng cho nhân viên',1.00,_binary '',_binary '',_binary '','BHTN Người sử dụng lao động');
INSERT INTO `deduction_type` (`id`, `category`, `default_rate`, `description`, `employer_contribution_rate`, `is_active`, `is_mandatory`, `is_percentage`, `name`) VALUES (7,'TAX',0.00,'Thuế TNCN luỹ tiến theo biểu thuế VN 2024',0.00,_binary '',_binary '',_binary '','Thuế thu nhập cá nhân');
INSERT INTO `deduction_type` (`id`, `category`, `default_rate`, `description`, `employer_contribution_rate`, `is_active`, `is_mandatory`, `is_percentage`, `name`) VALUES (8,'VOLUNTARY',1.00,'Đóng góp quỹ công đoàn tự nguyện',0.00,_binary '',_binary '\0',_binary '','Phí công đoàn');
/*!40000 ALTER TABLE `deduction_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `departments`
--

DROP TABLE IF EXISTS `departments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `departments` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `code` varchar(255) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `organization_unit_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UKl7tivi5261wxdnvo6cct9gg6t` (`code`),
  KEY `FKkw6uc03sgpkj64yemwtywdfj5` (`organization_unit_id`),
  CONSTRAINT `FKkw6uc03sgpkj64yemwtywdfj5` FOREIGN KEY (`organization_unit_id`) REFERENCES `organization_units` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `departments`
--

LOCK TABLES `departments` WRITE;
/*!40000 ALTER TABLE `departments` DISABLE KEYS */;
INSERT INTO `departments` (`id`, `code`, `name`, `organization_unit_id`) VALUES (1,'HR','Nhân sự & Hành chính',3);
INSERT INTO `departments` (`id`, `code`, `name`, `organization_unit_id`) VALUES (2,'ENG','Kỹ thuật phần mềm',3);
INSERT INTO `departments` (`id`, `code`, `name`, `organization_unit_id`) VALUES (3,'PMO','Quản lý dự án (PMO)',3);
INSERT INTO `departments` (`id`, `code`, `name`, `organization_unit_id`) VALUES (4,'QA','Đảm bảo chất lượng (QA/Test)',3);
INSERT INTO `departments` (`id`, `code`, `name`, `organization_unit_id`) VALUES (5,'DEVOPS','Vận hành & Hạ tầng (DevOps)',3);
INSERT INTO `departments` (`id`, `code`, `name`, `organization_unit_id`) VALUES (6,'FIN','Tài chính & Kế toán',3);
INSERT INTO `departments` (`id`, `code`, `name`, `organization_unit_id`) VALUES (7,'SALES','Kinh doanh & Marketing',3);
INSERT INTO `departments` (`id`, `code`, `name`, `organization_unit_id`) VALUES (8,'OPS-DN','Vận hành (Đà Nẵng)',4);
INSERT INTO `departments` (`id`, `code`, `name`, `organization_unit_id`) VALUES (9,'RD-DN','Nghiên cứu & Phát triển',4);
INSERT INTO `departments` (`id`, `code`, `name`, `organization_unit_id`) VALUES (10,'SUP-DN','Hỗ trợ khách hàng',4);
INSERT INTO `departments` (`id`, `code`, `name`, `organization_unit_id`) VALUES (11,'ENG-HN','Kỹ thuật phần mềm (Hà Nội)',5);
INSERT INTO `departments` (`id`, `code`, `name`, `organization_unit_id`) VALUES (12,'BD-HN','Phát triển kinh doanh (Hà Nội)',5);
/*!40000 ALTER TABLE `departments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `documents`
--

DROP TABLE IF EXISTS `documents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `documents` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) NOT NULL,
  `department_id` bigint DEFAULT NULL,
  `file_data` longblob NOT NULL,
  `file_name` varchar(500) NOT NULL,
  `file_size` bigint DEFAULT NULL,
  `file_type` varchar(200) DEFAULT NULL,
  `uploaded_by` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `documents`
--

LOCK TABLES `documents` WRITE;
/*!40000 ALTER TABLE `documents` DISABLE KEYS */;
/*!40000 ALTER TABLE `documents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employee`
--

DROP TABLE IF EXISTS `employee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `auth_user_id` varchar(36) DEFAULT NULL,
  `base_salary` decimal(38,2) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `currency` varchar(255) DEFAULT NULL,
  `did` varchar(255) DEFAULT NULL,
  `hire_date` date DEFAULT NULL,
  `job_level` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `position` varchar(255) DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `username` varchar(100) DEFAULT NULL,
  `department_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UKea8bo4n1ef6fpa0waxnjbauvc` (`auth_user_id`),
  UNIQUE KEY `UK47regylgst05o9y32nrphpsxk` (`did`),
  UNIQUE KEY `UKim8flsuftl52etbhgnr62d6wh` (`username`),
  KEY `FKo1uiovdf54iyqrovb6soq8yl6` (`department_id`),
  CONSTRAINT `FKo1uiovdf54iyqrovb6soq8yl6` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee`
--

LOCK TABLES `employee` WRITE;
/*!40000 ALTER TABLE `employee` DISABLE KEYS */;
INSERT INTO `employee` (`id`, `auth_user_id`, `base_salary`, `created_at`, `currency`, `did`, `hire_date`, `job_level`, `name`, `position`, `status`, `updated_at`, `username`, `department_id`) VALUES (1,'28759924-7b71-4220-bf8d-06d64ce7cae6',85000000.00,'2026-06-05 16:08:43.782793','VND','did:ecc:employee:001','2022-01-10','L6','Nguyễn Hữu Hùng','Giám đốc Công nghệ (CTO)','ACTIVE','2026-07-06 06:23:25.572742','admin',2);
INSERT INTO `employee` (`id`, `auth_user_id`, `base_salary`, `created_at`, `currency`, `did`, `hire_date`, `job_level`, `name`, `position`, `status`, `updated_at`, `username`, `department_id`) VALUES (2,'3c07be88-39df-4e33-8e20-71ba6ad4af5a',45000000.00,'2026-06-06 04:23:36.565875','VND','did:ecc:employee:002','2022-04-01','L4','Nguyễn Hà Linh','Quản lý Nhân sự','ACTIVE','2026-07-06 06:23:25.572742','hr.manager',1);
INSERT INTO `employee` (`id`, `auth_user_id`, `base_salary`, `created_at`, `currency`, `did`, `hire_date`, `job_level`, `name`, `position`, `status`, `updated_at`, `username`, `department_id`) VALUES (3,'49ca806e-2725-4af8-a049-2625ea5bc8ac',55000000.00,'2026-06-06 04:23:36.565875','VND','did:ecc:employee:003','2022-05-15','L4','Trần Minh Quân','Quản lý Kỹ thuật','ACTIVE','2026-07-06 06:23:25.572742','manager',3);
INSERT INTO `employee` (`id`, `auth_user_id`, `base_salary`, `created_at`, `currency`, `did`, `hire_date`, `job_level`, `name`, `position`, `status`, `updated_at`, `username`, `department_id`) VALUES (4,'f9831e0f-9b28-43d9-b3ab-94df70f2e33e',22000000.00,'2026-06-06 04:23:36.565875','VND','did:ecc:employee:004','2023-06-01','L2','Lê Thu An','Kỹ sư Phần mềm Backend','ACTIVE','2026-07-06 06:23:25.572742','employee',2);
INSERT INTO `employee` (`id`, `auth_user_id`, `base_salary`, `created_at`, `currency`, `did`, `hire_date`, `job_level`, `name`, `position`, `status`, `updated_at`, `username`, `department_id`) VALUES (5,'a1000019-0000-0000-0000-000000000019',24000000.00,'2026-06-06 04:23:36.565875','VND','did:ecc:employee:005','2023-07-10','L2','Phạm Hoàng Nam','Kỹ sư Backend','ACTIVE','2026-07-06 06:23:25.572742','pham.hoang.nam',2);
INSERT INTO `employee` (`id`, `auth_user_id`, `base_salary`, `created_at`, `currency`, `did`, `hire_date`, `job_level`, `name`, `position`, `status`, `updated_at`, `username`, `department_id`) VALUES (6,'a1000020-0000-0000-0000-000000000020',23000000.00,'2026-06-06 04:23:36.565875','VND','did:ecc:employee:006','2023-08-21','L2','Võ Thành Đạt','Kỹ sư Frontend','ACTIVE','2026-07-06 06:23:25.572742','vo.thanh.dat',2);
INSERT INTO `employee` (`id`, `auth_user_id`, `base_salary`, `created_at`, `currency`, `did`, `hire_date`, `job_level`, `name`, `position`, `status`, `updated_at`, `username`, `department_id`) VALUES (7,'a1000021-0000-0000-0000-000000000021',19000000.00,'2026-06-06 04:23:36.565875','VND','did:ecc:employee:007','2023-09-05','L2','Nguyễn Mỹ Duyên','Kỹ sư Kiểm thử (QA)','ACTIVE','2026-07-06 06:23:25.572742','nguyen.my.duyen',4);
INSERT INTO `employee` (`id`, `auth_user_id`, `base_salary`, `created_at`, `currency`, `did`, `hire_date`, `job_level`, `name`, `position`, `status`, `updated_at`, `username`, `department_id`) VALUES (8,'a1000018-0000-0000-0000-000000000018',21000000.00,'2026-06-06 04:23:36.565875','VND','did:ecc:employee:008','2023-05-02','L2','Hoàng Kim Ngân','Chuyên viên Phân tích (BA)','ACTIVE','2026-07-06 06:23:25.572742','hoang.kim.ngan',3);
INSERT INTO `employee` (`id`, `auth_user_id`, `base_salary`, `created_at`, `currency`, `did`, `hire_date`, `job_level`, `name`, `position`, `status`, `updated_at`, `username`, `department_id`) VALUES (9,'a1000017-0000-0000-0000-000000000017',42000000.00,'2026-06-06 04:23:36.565875','VND','did:ecc:employee:009','2023-03-11','L3','Đặng Quốc Bảo','Quản lý Dự án (PM)','ACTIVE','2026-07-06 06:23:25.572742','dang.quoc.bao',3);
INSERT INTO `employee` (`id`, `auth_user_id`, `base_salary`, `created_at`, `currency`, `did`, `hire_date`, `job_level`, `name`, `position`, `status`, `updated_at`, `username`, `department_id`) VALUES (10,'a1000016-0000-0000-0000-000000000016',15000000.00,'2026-06-06 04:23:36.565875','VND','did:ecc:employee:010','2024-01-08','L1','Trần Hải Yến','Chuyên viên Tuyển dụng','ACTIVE','2026-07-06 06:23:25.572742','tran.hai.yen',1);
INSERT INTO `employee` (`id`, `auth_user_id`, `base_salary`, `created_at`, `currency`, `did`, `hire_date`, `job_level`, `name`, `position`, `status`, `updated_at`, `username`, `department_id`) VALUES (11,'a1000022-0000-0000-0000-000000000022',35000000.00,'2026-06-06 04:23:36.565875','VND','did:ecc:employee:011','2023-11-14','L3','Bùi Mạnh Khoa','Kỹ sư DevOps','ACTIVE','2026-07-06 06:23:25.572742','bui.manh.khoa',5);
INSERT INTO `employee` (`id`, `auth_user_id`, `base_salary`, `created_at`, `currency`, `did`, `hire_date`, `job_level`, `name`, `position`, `status`, `updated_at`, `username`, `department_id`) VALUES (12,'a1000023-0000-0000-0000-000000000023',14000000.00,'2026-06-06 04:23:36.565875','VND','did:ecc:employee:012','2024-03-18','L1','Lê Minh Châu','Nhân viên Vận hành','ACTIVE','2026-07-06 06:23:25.572742','le.minh.chau',8);
INSERT INTO `employee` (`id`, `auth_user_id`, `base_salary`, `created_at`, `currency`, `did`, `hire_date`, `job_level`, `name`, `position`, `status`, `updated_at`, `username`, `department_id`) VALUES (13,'f6f8b8a7-7df7-42f4-a3e1-c34daed22755',32000000.00,'2026-06-07 17:24:17.038052','VND','did:ecc:employee:013','2023-05-15','L3','Đỗ Bảo Trâm','Chuyên viên Tính lương','ACTIVE','2026-07-06 06:23:25.572742','payroll.officer',1);
INSERT INTO `employee` (`id`, `auth_user_id`, `base_salary`, `created_at`, `currency`, `did`, `hire_date`, `job_level`, `name`, `position`, `status`, `updated_at`, `username`, `department_id`) VALUES (14,'a1000001-0000-0000-0000-000000000001',38000000.00,'2026-06-12 02:26:38.227139','VND','did:ecc:employee:014','2023-10-15','L3','Nguyễn Văn An','Kỹ sư Backend Senior','ACTIVE','2026-07-06 06:23:25.572742','nguyen.van.an',2);
INSERT INTO `employee` (`id`, `auth_user_id`, `base_salary`, `created_at`, `currency`, `did`, `hire_date`, `job_level`, `name`, `position`, `status`, `updated_at`, `username`, `department_id`) VALUES (15,'a1000002-0000-0000-0000-000000000002',48000000.00,'2026-07-05 06:43:42.000000','VND','did:ecc:employee:015','2023-03-20','L4','Phạm Thị Bích Ngọc','Trưởng nhóm Frontend','ACTIVE','2026-07-06 06:23:25.572742','pham.bich.ngoc',2);
INSERT INTO `employee` (`id`, `auth_user_id`, `base_salary`, `created_at`, `currency`, `did`, `hire_date`, `job_level`, `name`, `position`, `status`, `updated_at`, `username`, `department_id`) VALUES (16,'a1000003-0000-0000-0000-000000000003',42000000.00,'2026-06-12 08:43:33.271018','VND','did:ecc:employee:016','2023-02-28','L4','Trần Đức Thành','Trưởng nhóm QA','ACTIVE','2026-07-06 06:23:25.572742','tran.duc.thanh',4);
INSERT INTO `employee` (`id`, `auth_user_id`, `base_salary`, `created_at`, `currency`, `did`, `hire_date`, `job_level`, `name`, `position`, `status`, `updated_at`, `username`, `department_id`) VALUES (17,'a1000004-0000-0000-0000-000000000004',33000000.00,'2026-06-13 15:01:06.091114','VND','did:ecc:employee:017','2024-05-05','L3','Lê Hoàng Minh','Kỹ sư Hạ tầng Cloud','ACTIVE','2026-07-06 06:23:25.572742','le.hoang.minh',5);
INSERT INTO `employee` (`id`, `auth_user_id`, `base_salary`, `created_at`, `currency`, `did`, `hire_date`, `job_level`, `name`, `position`, `status`, `updated_at`, `username`, `department_id`) VALUES (18,'a1000005-0000-0000-0000-000000000005',18000000.00,'2026-07-05 06:43:42.000000','VND','did:ecc:employee:018','2024-06-15','L2','Võ Thị Kim Chi','Chuyên viên Nhân sự','ACTIVE','2026-07-06 06:23:25.572742','vo.kim.chi',1);
INSERT INTO `employee` (`id`, `auth_user_id`, `base_salary`, `created_at`, `currency`, `did`, `hire_date`, `job_level`, `name`, `position`, `status`, `updated_at`, `username`, `department_id`) VALUES (19,'a1000006-0000-0000-0000-000000000006',50000000.00,'2026-07-05 07:22:38.825610','VND','did:ecc:employee:019','2024-07-01','L4','Nguyễn Thanh Long','Trưởng phòng Kinh doanh','ACTIVE','2026-07-06 06:23:25.572742','nguyen.thanh.long',7);
INSERT INTO `employee` (`id`, `auth_user_id`, `base_salary`, `created_at`, `currency`, `did`, `hire_date`, `job_level`, `name`, `position`, `status`, `updated_at`, `username`, `department_id`) VALUES (20,'a1000007-0000-0000-0000-000000000007',20000000.00,'2026-07-05 06:43:42.000000','VND','did:ecc:employee:020','2024-07-15','L2','Trương Thị Lan','Kế toán viên','ACTIVE','2026-07-06 06:23:25.572742','truong.thi.lan',6);
INSERT INTO `employee` (`id`, `auth_user_id`, `base_salary`, `created_at`, `currency`, `did`, `hire_date`, `job_level`, `name`, `position`, `status`, `updated_at`, `username`, `department_id`) VALUES (21,'a1000008-0000-0000-0000-000000000008',25000000.00,'2026-07-05 08:18:04.326423','VND','did:ecc:employee:021','2024-08-01','L2','Hoàng Đức Nam','Kỹ sư Backend','ACTIVE','2026-07-06 06:23:25.572742','hoang.duc.nam',2);
INSERT INTO `employee` (`id`, `auth_user_id`, `base_salary`, `created_at`, `currency`, `did`, `hire_date`, `job_level`, `name`, `position`, `status`, `updated_at`, `username`, `department_id`) VALUES (22,'a1000009-0000-0000-0000-000000000009',22000000.00,'2026-07-05 07:22:38.825610','VND','did:ecc:employee:022','2024-08-15','L2','Đặng Thị Hương','Phân tích Nghiệp vụ (BA)','ACTIVE','2026-07-06 06:23:25.572742','dang.thi.huong',3);
INSERT INTO `employee` (`id`, `auth_user_id`, `base_salary`, `created_at`, `currency`, `did`, `hire_date`, `job_level`, `name`, `position`, `status`, `updated_at`, `username`, `department_id`) VALUES (23,'a1000010-0000-0000-0000-000000000010',12000000.00,'2026-07-05 07:22:38.825610','VND','did:ecc:employee:023','2025-01-06','L1','Bùi Quang Vinh','Kỹ sư Phần mềm Junior','ACTIVE','2026-07-06 06:23:25.572742','bui.quang.vinh',2);
INSERT INTO `employee` (`id`, `auth_user_id`, `base_salary`, `created_at`, `currency`, `did`, `hire_date`, `job_level`, `name`, `position`, `status`, `updated_at`, `username`, `department_id`) VALUES (24,'a1000011-0000-0000-0000-000000000011',13000000.00,'2026-07-05 07:22:38.825610','VND','did:ecc:employee:024','2024-09-15','L1','Đỗ Thị Thuỳ','Nhân viên CSKH','ACTIVE','2026-07-06 06:23:25.572742','do.thi.thuy',10);
INSERT INTO `employee` (`id`, `auth_user_id`, `base_salary`, `created_at`, `currency`, `did`, `hire_date`, `job_level`, `name`, `position`, `status`, `updated_at`, `username`, `department_id`) VALUES (25,'a1000012-0000-0000-0000-000000000012',36000000.00,'2026-07-05 07:22:38.825610','VND','did:ecc:employee:025','2024-10-01','L3','Lý Văn Hoa','Kỹ sư Nghiên cứu & Phát triển','ACTIVE','2026-07-06 06:23:25.572742','ly.van.hoa',9);
INSERT INTO `employee` (`id`, `auth_user_id`, `base_salary`, `created_at`, `currency`, `did`, `hire_date`, `job_level`, `name`, `position`, `status`, `updated_at`, `username`, `department_id`) VALUES (26,'a1000013-0000-0000-0000-000000000013',72000000.00,'2026-07-05 07:22:38.825610','VND','did:ecc:employee:026','2022-03-01','L5','Trần Đức Hùng','Trưởng phòng Kỹ thuật','ACTIVE','2026-07-06 06:23:25.572742','tran.duc.hung',2);
INSERT INTO `employee` (`id`, `auth_user_id`, `base_salary`, `created_at`, `currency`, `did`, `hire_date`, `job_level`, `name`, `position`, `status`, `updated_at`, `username`, `department_id`) VALUES (27,'a1000014-0000-0000-0000-000000000014',75000000.00,'2026-07-05 07:22:38.825610','VND','did:ecc:employee:027','2022-02-15','L5','Nguyễn Minh Tuấn','Giám đốc Nhân sự (HRD)','ACTIVE','2026-07-06 06:23:25.572742','nguyen.minh.tuan',1);
INSERT INTO `employee` (`id`, `auth_user_id`, `base_salary`, `created_at`, `currency`, `did`, `hire_date`, `job_level`, `name`, `position`, `status`, `updated_at`, `username`, `department_id`) VALUES (28,'a1000015-0000-0000-0000-000000000015',30000000.00,'2026-07-05 07:22:38.825610','VND','did:ecc:employee:028','2024-01-15','L3','Phạm Thu Hoà','Chuyên viên Lương & Phúc lợi','ACTIVE','2026-07-06 06:23:25.572742','pham.thu.hoa',1);
INSERT INTO `employee` (`id`, `auth_user_id`, `base_salary`, `created_at`, `currency`, `did`, `hire_date`, `job_level`, `name`, `position`, `status`, `updated_at`, `username`, `department_id`) VALUES (29,'3c7b46e9-3843-424f-9bc5-acab1e7ec4b7',NULL,'2026-07-05 08:30:32.608314',NULL,NULL,NULL,NULL,'user10','USER','ACTIVE',NULL,'user10',NULL);
/*!40000 ALTER TABLE `employee` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `organization_units`
--

DROP TABLE IF EXISTS `organization_units`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `organization_units` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `code` varchar(255) DEFAULT NULL,
  `level` enum('CORPORATION','DEPARTMENT','MEMBER_COMPANY','TOTAL_COMPANY') NOT NULL,
  `name` varchar(255) NOT NULL,
  `parent_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK9o63hv8py3njflp95npdkhyav` (`code`),
  KEY `FKm963fw5e7ry8fvajawcypoge9` (`parent_id`),
  CONSTRAINT `FKm963fw5e7ry8fvajawcypoge9` FOREIGN KEY (`parent_id`) REFERENCES `organization_units` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `organization_units`
--

LOCK TABLES `organization_units` WRITE;
/*!40000 ALTER TABLE `organization_units` DISABLE KEYS */;
INSERT INTO `organization_units` (`id`, `code`, `level`, `name`, `parent_id`) VALUES (1,'ECC','CORPORATION','ECC Group',NULL);
INSERT INTO `organization_units` (`id`, `code`, `level`, `name`, `parent_id`) VALUES (2,'ECC-VN','TOTAL_COMPANY','ECC Việt Nam',1);
INSERT INTO `organization_units` (`id`, `code`, `level`, `name`, `parent_id`) VALUES (3,'ECC-HCM','MEMBER_COMPANY','ECC Hồ Chí Minh',2);
INSERT INTO `organization_units` (`id`, `code`, `level`, `name`, `parent_id`) VALUES (4,'ECC-DN','MEMBER_COMPANY','ECC Đà Nẵng',2);
INSERT INTO `organization_units` (`id`, `code`, `level`, `name`, `parent_id`) VALUES (5,'ECC-HN','MEMBER_COMPANY','ECC Hà Nội',2);
/*!40000 ALTER TABLE `organization_units` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payroll_history`
--

DROP TABLE IF EXISTS `payroll_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payroll_history` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `action_by` varchar(100) DEFAULT NULL,
  `change_details` varchar(1000) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `event_type` varchar(50) NOT NULL,
  `previous_gross` decimal(12,2) DEFAULT NULL,
  `previous_net` decimal(12,2) DEFAULT NULL,
  `employee_id` bigint NOT NULL,
  `payroll_result_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_ph_payroll_result_created` (`payroll_result_id`,`created_at`),
  KEY `FKdr2xn6v8y3s9y6fxa1t2392m8` (`employee_id`),
  CONSTRAINT `FKdr2xn6v8y3s9y6fxa1t2392m8` FOREIGN KEY (`employee_id`) REFERENCES `employee` (`id`),
  CONSTRAINT `FKmbby7vtfrdftmfidoy5r5tto8` FOREIGN KEY (`payroll_result_id`) REFERENCES `payroll_result` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payroll_history`
--

LOCK TABLES `payroll_history` WRITE;
/*!40000 ALTER TABLE `payroll_history` DISABLE KEYS */;
INSERT INTO `payroll_history` (`id`, `action_by`, `change_details`, `created_at`, `event_type`, `previous_gross`, `previous_net`, `employee_id`, `payroll_result_id`) VALUES (1,'full-seed','Tạo bảng lương T3/2026 cho Nguyễn Hữu Hùng','2026-06-07 17:24:17.479142','CREATED',85000000.00,62402000.00,4,1);
INSERT INTO `payroll_history` (`id`, `action_by`, `change_details`, `created_at`, `event_type`, `previous_gross`, `previous_net`, `employee_id`, `payroll_result_id`) VALUES (2,'payroll.officer','Đã thanh toán lương T3/2026','2026-06-07 17:24:17.479142','PROCESSED',85000000.00,62402000.00,4,1);
INSERT INTO `payroll_history` (`id`, `action_by`, `change_details`, `created_at`, `event_type`, `previous_gross`, `previous_net`, `employee_id`, `payroll_result_id`) VALUES (3,'full-seed','Tạo bảng lương T3/2026 cho Nguyễn Hà Linh','2026-06-07 17:24:17.479142','CREATED',45000000.00,36070000.00,4,1);
INSERT INTO `payroll_history` (`id`, `action_by`, `change_details`, `created_at`, `event_type`, `previous_gross`, `previous_net`, `employee_id`, `payroll_result_id`) VALUES (4,'payroll.officer','Đã thanh toán lương T3/2026','2026-06-07 17:24:17.479142','PROCESSED',45000000.00,36070000.00,5,2);
INSERT INTO `payroll_history` (`id`, `action_by`, `change_details`, `created_at`, `event_type`, `previous_gross`, `previous_net`, `employee_id`, `payroll_result_id`) VALUES (5,'full-seed','Tạo bảng lương T3/2026 cho Trần Minh Quân','2026-06-07 17:24:17.479142','CREATED',55000000.00,42919000.00,6,3);
INSERT INTO `payroll_history` (`id`, `action_by`, `change_details`, `created_at`, `event_type`, `previous_gross`, `previous_net`, `employee_id`, `payroll_result_id`) VALUES (6,'payroll.officer','Đã thanh toán lương T3/2026','2026-04-07 10:00:00.000000','PROCESSED',55000000.00,42919000.00,3,7);
INSERT INTO `payroll_history` (`id`, `action_by`, `change_details`, `created_at`, `event_type`, `previous_gross`, `previous_net`, `employee_id`, `payroll_result_id`) VALUES (7,'full-seed','Tạo bảng lương T3/2026 cho Lê Thu An','2026-04-01 09:00:00.000000','CREATED',22000000.00,19071000.00,4,8);
INSERT INTO `payroll_history` (`id`, `action_by`, `change_details`, `created_at`, `event_type`, `previous_gross`, `previous_net`, `employee_id`, `payroll_result_id`) VALUES (8,'payroll.officer','Đã thanh toán lương T3/2026','2026-04-07 10:00:00.000000','PROCESSED',22000000.00,19071000.00,4,8);
INSERT INTO `payroll_history` (`id`, `action_by`, `change_details`, `created_at`, `event_type`, `previous_gross`, `previous_net`, `employee_id`, `payroll_result_id`) VALUES (9,'full-seed','Tạo bảng lương T3/2026 cho Phạm Hoàng Nam','2026-04-01 09:00:00.000000','CREATED',24000000.00,20658000.00,5,9);
INSERT INTO `payroll_history` (`id`, `action_by`, `change_details`, `created_at`, `event_type`, `previous_gross`, `previous_net`, `employee_id`, `payroll_result_id`) VALUES (10,'payroll.officer','Đã thanh toán lương T3/2026','2026-04-07 10:00:00.000000','PROCESSED',24000000.00,20658000.00,5,9);
INSERT INTO `payroll_history` (`id`, `action_by`, `change_details`, `created_at`, `event_type`, `previous_gross`, `previous_net`, `employee_id`, `payroll_result_id`) VALUES (11,'full-seed','Tạo bảng lương T3/2026 cho Võ Thành Đạt','2026-04-01 09:00:00.000000','CREATED',23000000.00,19876000.00,6,10);
INSERT INTO `payroll_history` (`id`, `action_by`, `change_details`, `created_at`, `event_type`, `previous_gross`, `previous_net`, `employee_id`, `payroll_result_id`) VALUES (12,'payroll.officer','Đã thanh toán lương T3/2026','2026-04-07 10:00:00.000000','PROCESSED',23000000.00,19876000.00,6,10);
INSERT INTO `payroll_history` (`id`, `action_by`, `change_details`, `created_at`, `event_type`, `previous_gross`, `previous_net`, `employee_id`, `payroll_result_id`) VALUES (13,'full-seed','Tạo bảng lương T3/2026 cho Bùi Mạnh Khoa','2026-04-01 09:00:00.000000','CREATED',35000000.00,28910000.00,11,15);
INSERT INTO `payroll_history` (`id`, `action_by`, `change_details`, `created_at`, `event_type`, `previous_gross`, `previous_net`, `employee_id`, `payroll_result_id`) VALUES (14,'payroll.officer','Đã thanh toán lương T3/2026','2026-04-07 10:00:00.000000','PROCESSED',35000000.00,28910000.00,11,15);
INSERT INTO `payroll_history` (`id`, `action_by`, `change_details`, `created_at`, `event_type`, `previous_gross`, `previous_net`, `employee_id`, `payroll_result_id`) VALUES (15,'full-seed','Tạo bảng lương T3/2026 cho Đỗ Bảo Trâm','2026-04-01 09:00:00.000000','CREATED',32000000.00,26744000.00,13,17);
INSERT INTO `payroll_history` (`id`, `action_by`, `change_details`, `created_at`, `event_type`, `previous_gross`, `previous_net`, `employee_id`, `payroll_result_id`) VALUES (16,'payroll.officer','Đã thanh toán lương T3/2026','2026-04-07 10:00:00.000000','PROCESSED',32000000.00,26744000.00,13,17);
INSERT INTO `payroll_history` (`id`, `action_by`, `change_details`, `created_at`, `event_type`, `previous_gross`, `previous_net`, `employee_id`, `payroll_result_id`) VALUES (17,'full-seed','Tạo bảng lương T4/2026 cho Nguyễn Hữu Hùng','2026-05-02 09:00:00.000000','CREATED',85000000.00,62402000.00,1,18);
INSERT INTO `payroll_history` (`id`, `action_by`, `change_details`, `created_at`, `event_type`, `previous_gross`, `previous_net`, `employee_id`, `payroll_result_id`) VALUES (18,'hr.manager','Giám đốc nhân sự phê duyệt bảng lương T4/2026','2026-05-06 14:00:00.000000','APPROVED',85000000.00,62402000.00,1,18);
INSERT INTO `payroll_history` (`id`, `action_by`, `change_details`, `created_at`, `event_type`, `previous_gross`, `previous_net`, `employee_id`, `payroll_result_id`) VALUES (19,'payroll.officer','Đã thanh toán lương T4/2026','2026-05-08 10:00:00.000000','PROCESSED',85000000.00,62402000.00,1,18);
INSERT INTO `payroll_history` (`id`, `action_by`, `change_details`, `created_at`, `event_type`, `previous_gross`, `previous_net`, `employee_id`, `payroll_result_id`) VALUES (20,'full-seed','Tạo bảng lương T4/2026 cho Lê Thu An','2026-05-02 09:00:00.000000','CREATED',22000000.00,19071000.00,4,21);
INSERT INTO `payroll_history` (`id`, `action_by`, `change_details`, `created_at`, `event_type`, `previous_gross`, `previous_net`, `employee_id`, `payroll_result_id`) VALUES (21,'hr.manager','Phê duyệt bảng lương T4/2026','2026-05-06 14:00:00.000000','APPROVED',22000000.00,19071000.00,4,21);
INSERT INTO `payroll_history` (`id`, `action_by`, `change_details`, `created_at`, `event_type`, `previous_gross`, `previous_net`, `employee_id`, `payroll_result_id`) VALUES (22,'payroll.officer','Đã thanh toán lương T4/2026','2026-05-08 10:00:00.000000','PROCESSED',22000000.00,19071000.00,4,21);
INSERT INTO `payroll_history` (`id`, `action_by`, `change_details`, `created_at`, `event_type`, `previous_gross`, `previous_net`, `employee_id`, `payroll_result_id`) VALUES (23,'full-seed','Tạo bảng lương T4/2026 cho Đặng Quốc Bảo','2026-05-02 09:00:00.000000','CREATED',42000000.00,33922000.00,9,26);
INSERT INTO `payroll_history` (`id`, `action_by`, `change_details`, `created_at`, `event_type`, `previous_gross`, `previous_net`, `employee_id`, `payroll_result_id`) VALUES (24,'hr.manager','Phê duyệt bảng lương T4/2026','2026-05-06 14:00:00.000000','APPROVED',42000000.00,33922000.00,9,26);
INSERT INTO `payroll_history` (`id`, `action_by`, `change_details`, `created_at`, `event_type`, `previous_gross`, `previous_net`, `employee_id`, `payroll_result_id`) VALUES (25,'payroll.officer','Đã thanh toán lương T4/2026','2026-05-08 10:00:00.000000','PROCESSED',42000000.00,33922000.00,9,26);
INSERT INTO `payroll_history` (`id`, `action_by`, `change_details`, `created_at`, `event_type`, `previous_gross`, `previous_net`, `employee_id`, `payroll_result_id`) VALUES (26,'full-seed','Tạo bảng lương T5/2026 cho Lê Thu An','2026-06-02 09:00:00.000000','CREATED',22000000.00,19071000.00,4,1);
INSERT INTO `payroll_history` (`id`, `action_by`, `change_details`, `created_at`, `event_type`, `previous_gross`, `previous_net`, `employee_id`, `payroll_result_id`) VALUES (27,'hr.manager','Phê duyệt bảng lương T5/2026','2026-06-06 10:00:00.000000','APPROVED',22000000.00,19071000.00,4,1);
INSERT INTO `payroll_history` (`id`, `action_by`, `change_details`, `created_at`, `event_type`, `previous_gross`, `previous_net`, `employee_id`, `payroll_result_id`) VALUES (28,'payroll.officer','Đã thanh toán lương T5/2026','2026-06-07 10:00:00.000000','PROCESSED',22000000.00,19071000.00,4,1);
INSERT INTO `payroll_history` (`id`, `action_by`, `change_details`, `created_at`, `event_type`, `previous_gross`, `previous_net`, `employee_id`, `payroll_result_id`) VALUES (29,'full-seed','Tạo bảng lương T5/2026 cho Nguyễn Hữu Hùng','2026-06-02 09:00:00.000000','CREATED',85000000.00,62402000.00,1,31);
INSERT INTO `payroll_history` (`id`, `action_by`, `change_details`, `created_at`, `event_type`, `previous_gross`, `previous_net`, `employee_id`, `payroll_result_id`) VALUES (30,'payroll.officer','Phê duyệt bảng lương T5/2026','2026-06-06 10:00:00.000000','APPROVED',85000000.00,62402000.00,1,31);
INSERT INTO `payroll_history` (`id`, `action_by`, `change_details`, `created_at`, `event_type`, `previous_gross`, `previous_net`, `employee_id`, `payroll_result_id`) VALUES (31,'full-seed','Tạo bảng lương T5/2026 cho Trần Minh Quân','2026-06-02 09:00:00.000000','CREATED',55000000.00,42919000.00,3,33);
INSERT INTO `payroll_history` (`id`, `action_by`, `change_details`, `created_at`, `event_type`, `previous_gross`, `previous_net`, `employee_id`, `payroll_result_id`) VALUES (32,'payroll.officer','Phê duyệt bảng lương T5/2026','2026-06-06 10:00:00.000000','APPROVED',55000000.00,42919000.00,3,33);
INSERT INTO `payroll_history` (`id`, `action_by`, `change_details`, `created_at`, `event_type`, `previous_gross`, `previous_net`, `employee_id`, `payroll_result_id`) VALUES (33,'full-seed','Khởi tạo bảng lương T6/2026 cho Nguyễn Hữu Hùng','2026-06-20 09:00:00.000000','CREATED',85000000.00,62402000.00,1,42);
INSERT INTO `payroll_history` (`id`, `action_by`, `change_details`, `created_at`, `event_type`, `previous_gross`, `previous_net`, `employee_id`, `payroll_result_id`) VALUES (34,'full-seed','Khởi tạo bảng lương T6/2026 cho Nguyễn Hà Linh','2026-06-20 09:00:00.000000','CREATED',45000000.00,36070000.00,2,43);
INSERT INTO `payroll_history` (`id`, `action_by`, `change_details`, `created_at`, `event_type`, `previous_gross`, `previous_net`, `employee_id`, `payroll_result_id`) VALUES (35,'full-seed','Khởi tạo bảng lương T6/2026 cho Trần Minh Quân','2026-06-20 09:00:00.000000','CREATED',55000000.00,42919000.00,3,44);
INSERT INTO `payroll_history` (`id`, `action_by`, `change_details`, `created_at`, `event_type`, `previous_gross`, `previous_net`, `employee_id`, `payroll_result_id`) VALUES (36,'full-seed','Khởi tạo bảng lương T6/2026 cho Lê Thu An','2026-06-20 09:00:00.000000','CREATED',22000000.00,19071000.00,4,45);
INSERT INTO `payroll_history` (`id`, `action_by`, `change_details`, `created_at`, `event_type`, `previous_gross`, `previous_net`, `employee_id`, `payroll_result_id`) VALUES (37,'full-seed','Khởi tạo bảng lương T6/2026 cho Phạm Hoàng Nam','2026-06-20 09:00:00.000000','CREATED',24000000.00,20658000.00,5,2);
INSERT INTO `payroll_history` (`id`, `action_by`, `change_details`, `created_at`, `event_type`, `previous_gross`, `previous_net`, `employee_id`, `payroll_result_id`) VALUES (38,'full-seed','Khởi tạo bảng lương T6/2026 cho Võ Thành Đạt','2026-06-20 09:00:00.000000','CREATED',23000000.00,19876000.00,6,3);
INSERT INTO `payroll_history` (`id`, `action_by`, `change_details`, `created_at`, `event_type`, `previous_gross`, `previous_net`, `employee_id`, `payroll_result_id`) VALUES (39,'full-seed','Khởi tạo bảng lương T6/2026 cho Đỗ Bảo Trâm','2026-06-20 09:00:00.000000','CREATED',32000000.00,26744000.00,13,4);
/*!40000 ALTER TABLE `payroll_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payroll_result`
--

DROP TABLE IF EXISTS `payroll_result`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payroll_result` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `approved_at` datetime(6) DEFAULT NULL,
  `approved_by` varchar(100) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `gross_pay` decimal(12,2) NOT NULL,
  `insurance_deduction` decimal(12,2) DEFAULT NULL,
  `net_pay` decimal(12,2) NOT NULL,
  `other_deduction` decimal(12,2) DEFAULT NULL,
  `period_end_date` date NOT NULL,
  `period_start_date` date NOT NULL,
  `processed_at` datetime(6) DEFAULT NULL,
  `processed_by` varchar(100) DEFAULT NULL,
  `remarks` varchar(500) DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  `tax_deduction` decimal(12,2) DEFAULT NULL,
  `total_deduction` decimal(12,2) NOT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `version` bigint DEFAULT NULL,
  `employee_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_pr_employee_period` (`employee_id`,`period_start_date`),
  CONSTRAINT `FKmvi7m0c86ar4xkvehxkhf522p` FOREIGN KEY (`employee_id`) REFERENCES `employee` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payroll_result`
--

LOCK TABLES `payroll_result` WRITE;
/*!40000 ALTER TABLE `payroll_result` DISABLE KEYS */;
INSERT INTO `payroll_result` (`id`, `approved_at`, `approved_by`, `created_at`, `gross_pay`, `insurance_deduction`, `net_pay`, `other_deduction`, `period_end_date`, `period_start_date`, `processed_at`, `processed_by`, `remarks`, `status`, `tax_deduction`, `total_deduction`, `updated_at`, `version`, `employee_id`) VALUES (1,'2026-06-06 10:00:00.000000','payroll.officer','2026-06-07 17:24:17.463048',22000000.00,2310000.00,19071000.00,0.00,'2026-05-31','2026-05-01','2026-06-07 10:00:00.000000','payroll.officer','Lương T5/2026','PROCESSED',619000.00,2929000.00,'2026-07-06 06:23:25.644778',0,4);
INSERT INTO `payroll_result` (`id`, `approved_at`, `approved_by`, `created_at`, `gross_pay`, `insurance_deduction`, `net_pay`, `other_deduction`, `period_end_date`, `period_start_date`, `processed_at`, `processed_by`, `remarks`, `status`, `tax_deduction`, `total_deduction`, `updated_at`, `version`, `employee_id`) VALUES (2,NULL,NULL,'2026-06-07 17:24:17.463048',24000000.00,2520000.00,20658000.00,0.00,'2026-06-30','2026-06-01',NULL,NULL,'Lương T6/2026 — đang xử lý','DRAFT',822000.00,3342000.00,'2026-07-06 06:23:25.644778',0,5);
INSERT INTO `payroll_result` (`id`, `approved_at`, `approved_by`, `created_at`, `gross_pay`, `insurance_deduction`, `net_pay`, `other_deduction`, `period_end_date`, `period_start_date`, `processed_at`, `processed_by`, `remarks`, `status`, `tax_deduction`, `total_deduction`, `updated_at`, `version`, `employee_id`) VALUES (3,NULL,NULL,'2026-06-07 17:24:17.463048',23000000.00,2415000.00,19876000.00,0.00,'2026-06-30','2026-06-01',NULL,NULL,'Lương T6/2026 — đang xử lý','DRAFT',709000.00,3124000.00,'2026-07-06 06:23:25.644778',0,6);
INSERT INTO `payroll_result` (`id`, `approved_at`, `approved_by`, `created_at`, `gross_pay`, `insurance_deduction`, `net_pay`, `other_deduction`, `period_end_date`, `period_start_date`, `processed_at`, `processed_by`, `remarks`, `status`, `tax_deduction`, `total_deduction`, `updated_at`, `version`, `employee_id`) VALUES (4,NULL,NULL,'2026-06-07 17:24:17.463048',32000000.00,3360000.00,26744000.00,0.00,'2026-06-30','2026-06-01',NULL,NULL,'Lương T6/2026 — đang xử lý','DRAFT',1896000.00,5256000.00,'2026-07-06 06:23:25.644778',0,13);
INSERT INTO `payroll_result` (`id`, `approved_at`, `approved_by`, `created_at`, `gross_pay`, `insurance_deduction`, `net_pay`, `other_deduction`, `period_end_date`, `period_start_date`, `processed_at`, `processed_by`, `remarks`, `status`, `tax_deduction`, `total_deduction`, `updated_at`, `version`, `employee_id`) VALUES (5,'2026-04-06 10:00:00.000000','payroll.officer','2026-06-08 10:08:03.178209',85000000.00,8925000.00,62402000.00,0.00,'2026-06-30','2026-06-01','2026-04-07 10:00:00.000000','payroll.officer','Lương T3/2026','PROCESSED',13673000.00,22598000.00,'2026-07-06 06:23:25.644778',0,1);
INSERT INTO `payroll_result` (`id`, `approved_at`, `approved_by`, `created_at`, `gross_pay`, `insurance_deduction`, `net_pay`, `other_deduction`, `period_end_date`, `period_start_date`, `processed_at`, `processed_by`, `remarks`, `status`, `tax_deduction`, `total_deduction`, `updated_at`, `version`, `employee_id`) VALUES (6,'2026-04-06 10:00:00.000000','payroll.officer','2026-06-12 08:18:25.937171',45000000.00,4725000.00,36070000.00,0.00,'2026-06-30','2026-06-01','2026-04-07 10:00:00.000000','payroll.officer','Lương T3/2026','PROCESSED',4205000.00,8930000.00,'2026-07-06 06:23:25.644778',0,1);
INSERT INTO `payroll_result` (`id`, `approved_at`, `approved_by`, `created_at`, `gross_pay`, `insurance_deduction`, `net_pay`, `other_deduction`, `period_end_date`, `period_start_date`, `processed_at`, `processed_by`, `remarks`, `status`, `tax_deduction`, `total_deduction`, `updated_at`, `version`, `employee_id`) VALUES (7,'2026-04-06 10:00:00.000000','payroll.officer','2026-07-05 00:24:11.190471',55000000.00,5775000.00,42919000.00,0.00,'2026-07-31','2026-07-01','2026-04-07 10:00:00.000000','payroll.officer','Lương T3/2026','PROCESSED',6306000.00,12081000.00,'2026-07-06 06:23:25.644778',0,2);
INSERT INTO `payroll_result` (`id`, `approved_at`, `approved_by`, `created_at`, `gross_pay`, `insurance_deduction`, `net_pay`, `other_deduction`, `period_end_date`, `period_start_date`, `processed_at`, `processed_by`, `remarks`, `status`, `tax_deduction`, `total_deduction`, `updated_at`, `version`, `employee_id`) VALUES (8,'2026-04-06 10:00:00.000000','payroll.officer','2026-04-01 09:00:00.000000',22000000.00,2310000.00,19071000.00,0.00,'2026-03-31','2026-03-01','2026-04-07 10:00:00.000000','payroll.officer','Lương T3/2026','PROCESSED',619000.00,2929000.00,'2026-07-06 06:23:25.644778',0,4);
INSERT INTO `payroll_result` (`id`, `approved_at`, `approved_by`, `created_at`, `gross_pay`, `insurance_deduction`, `net_pay`, `other_deduction`, `period_end_date`, `period_start_date`, `processed_at`, `processed_by`, `remarks`, `status`, `tax_deduction`, `total_deduction`, `updated_at`, `version`, `employee_id`) VALUES (9,'2026-04-06 10:00:00.000000','payroll.officer','2026-04-01 09:00:00.000000',24000000.00,2520000.00,20658000.00,0.00,'2026-03-31','2026-03-01','2026-04-07 10:00:00.000000','payroll.officer','Lương T3/2026','PROCESSED',822000.00,3342000.00,'2026-07-06 06:23:25.644778',0,5);
INSERT INTO `payroll_result` (`id`, `approved_at`, `approved_by`, `created_at`, `gross_pay`, `insurance_deduction`, `net_pay`, `other_deduction`, `period_end_date`, `period_start_date`, `processed_at`, `processed_by`, `remarks`, `status`, `tax_deduction`, `total_deduction`, `updated_at`, `version`, `employee_id`) VALUES (10,'2026-04-06 10:00:00.000000','payroll.officer','2026-04-01 09:00:00.000000',23000000.00,2415000.00,19876000.00,0.00,'2026-03-31','2026-03-01','2026-04-07 10:00:00.000000','payroll.officer','Lương T3/2026','PROCESSED',709000.00,3124000.00,'2026-07-06 06:23:25.644778',0,6);
INSERT INTO `payroll_result` (`id`, `approved_at`, `approved_by`, `created_at`, `gross_pay`, `insurance_deduction`, `net_pay`, `other_deduction`, `period_end_date`, `period_start_date`, `processed_at`, `processed_by`, `remarks`, `status`, `tax_deduction`, `total_deduction`, `updated_at`, `version`, `employee_id`) VALUES (11,'2026-04-06 10:00:00.000000','payroll.officer','2026-04-01 09:00:00.000000',19000000.00,1995000.00,16654000.00,0.00,'2026-03-31','2026-03-01','2026-04-07 10:00:00.000000','payroll.officer','Lương T3/2026','PROCESSED',351000.00,2346000.00,'2026-07-06 06:23:25.644778',0,7);
INSERT INTO `payroll_result` (`id`, `approved_at`, `approved_by`, `created_at`, `gross_pay`, `insurance_deduction`, `net_pay`, `other_deduction`, `period_end_date`, `period_start_date`, `processed_at`, `processed_by`, `remarks`, `status`, `tax_deduction`, `total_deduction`, `updated_at`, `version`, `employee_id`) VALUES (12,'2026-04-06 10:00:00.000000','payroll.officer','2026-04-01 09:00:00.000000',21000000.00,2205000.00,18265000.00,0.00,'2026-03-31','2026-03-01','2026-04-07 10:00:00.000000','payroll.officer','Lương T3/2026','PROCESSED',530000.00,2735000.00,'2026-07-06 06:23:25.644778',0,8);
INSERT INTO `payroll_result` (`id`, `approved_at`, `approved_by`, `created_at`, `gross_pay`, `insurance_deduction`, `net_pay`, `other_deduction`, `period_end_date`, `period_start_date`, `processed_at`, `processed_by`, `remarks`, `status`, `tax_deduction`, `total_deduction`, `updated_at`, `version`, `employee_id`) VALUES (13,'2026-04-06 10:00:00.000000','payroll.officer','2026-04-01 09:00:00.000000',42000000.00,4410000.00,33922000.00,0.00,'2026-03-31','2026-03-01','2026-04-07 10:00:00.000000','payroll.officer','Lương T3/2026','PROCESSED',3668000.00,8078000.00,'2026-07-06 06:23:25.644778',0,9);
INSERT INTO `payroll_result` (`id`, `approved_at`, `approved_by`, `created_at`, `gross_pay`, `insurance_deduction`, `net_pay`, `other_deduction`, `period_end_date`, `period_start_date`, `processed_at`, `processed_by`, `remarks`, `status`, `tax_deduction`, `total_deduction`, `updated_at`, `version`, `employee_id`) VALUES (14,'2026-04-06 10:00:00.000000','payroll.officer','2026-04-01 09:00:00.000000',15000000.00,1575000.00,13304000.00,0.00,'2026-03-31','2026-03-01','2026-04-07 10:00:00.000000','payroll.officer','Lương T3/2026','PROCESSED',121000.00,1696000.00,'2026-07-06 06:23:25.644778',0,10);
INSERT INTO `payroll_result` (`id`, `approved_at`, `approved_by`, `created_at`, `gross_pay`, `insurance_deduction`, `net_pay`, `other_deduction`, `period_end_date`, `period_start_date`, `processed_at`, `processed_by`, `remarks`, `status`, `tax_deduction`, `total_deduction`, `updated_at`, `version`, `employee_id`) VALUES (15,'2026-04-06 10:00:00.000000','payroll.officer','2026-04-01 09:00:00.000000',35000000.00,3675000.00,28910000.00,0.00,'2026-03-31','2026-03-01','2026-04-07 10:00:00.000000','payroll.officer','Lương T3/2026','PROCESSED',2415000.00,6090000.00,'2026-07-06 06:23:25.644778',0,11);
INSERT INTO `payroll_result` (`id`, `approved_at`, `approved_by`, `created_at`, `gross_pay`, `insurance_deduction`, `net_pay`, `other_deduction`, `period_end_date`, `period_start_date`, `processed_at`, `processed_by`, `remarks`, `status`, `tax_deduction`, `total_deduction`, `updated_at`, `version`, `employee_id`) VALUES (16,'2026-04-06 10:00:00.000000','payroll.officer','2026-04-01 09:00:00.000000',14000000.00,1470000.00,12453000.00,0.00,'2026-03-31','2026-03-01','2026-04-07 10:00:00.000000','payroll.officer','Lương T3/2026','PROCESSED',77000.00,1547000.00,'2026-07-06 06:23:25.644778',0,12);
INSERT INTO `payroll_result` (`id`, `approved_at`, `approved_by`, `created_at`, `gross_pay`, `insurance_deduction`, `net_pay`, `other_deduction`, `period_end_date`, `period_start_date`, `processed_at`, `processed_by`, `remarks`, `status`, `tax_deduction`, `total_deduction`, `updated_at`, `version`, `employee_id`) VALUES (17,'2026-04-06 10:00:00.000000','payroll.officer','2026-04-01 09:00:00.000000',32000000.00,3360000.00,26744000.00,0.00,'2026-03-31','2026-03-01','2026-04-07 10:00:00.000000','payroll.officer','Lương T3/2026','PROCESSED',1896000.00,5256000.00,'2026-07-06 06:23:25.644778',0,13);
INSERT INTO `payroll_result` (`id`, `approved_at`, `approved_by`, `created_at`, `gross_pay`, `insurance_deduction`, `net_pay`, `other_deduction`, `period_end_date`, `period_start_date`, `processed_at`, `processed_by`, `remarks`, `status`, `tax_deduction`, `total_deduction`, `updated_at`, `version`, `employee_id`) VALUES (18,'2026-05-07 10:00:00.000000','payroll.officer','2026-05-02 09:00:00.000000',85000000.00,8925000.00,62402000.00,0.00,'2026-04-30','2026-04-01','2026-05-08 10:00:00.000000','payroll.officer','Lương T4/2026','PROCESSED',13673000.00,22598000.00,'2026-07-06 06:23:25.644778',0,1);
INSERT INTO `payroll_result` (`id`, `approved_at`, `approved_by`, `created_at`, `gross_pay`, `insurance_deduction`, `net_pay`, `other_deduction`, `period_end_date`, `period_start_date`, `processed_at`, `processed_by`, `remarks`, `status`, `tax_deduction`, `total_deduction`, `updated_at`, `version`, `employee_id`) VALUES (19,'2026-05-07 10:00:00.000000','payroll.officer','2026-05-02 09:00:00.000000',45000000.00,4725000.00,36070000.00,0.00,'2026-04-30','2026-04-01','2026-05-08 10:00:00.000000','payroll.officer','Lương T4/2026','PROCESSED',4205000.00,8930000.00,'2026-07-06 06:23:25.644778',0,2);
INSERT INTO `payroll_result` (`id`, `approved_at`, `approved_by`, `created_at`, `gross_pay`, `insurance_deduction`, `net_pay`, `other_deduction`, `period_end_date`, `period_start_date`, `processed_at`, `processed_by`, `remarks`, `status`, `tax_deduction`, `total_deduction`, `updated_at`, `version`, `employee_id`) VALUES (20,'2026-05-07 10:00:00.000000','payroll.officer','2026-05-02 09:00:00.000000',55000000.00,5775000.00,42919000.00,0.00,'2026-04-30','2026-04-01','2026-05-08 10:00:00.000000','payroll.officer','Lương T4/2026','PROCESSED',6306000.00,12081000.00,'2026-07-06 06:23:25.644778',0,3);
INSERT INTO `payroll_result` (`id`, `approved_at`, `approved_by`, `created_at`, `gross_pay`, `insurance_deduction`, `net_pay`, `other_deduction`, `period_end_date`, `period_start_date`, `processed_at`, `processed_by`, `remarks`, `status`, `tax_deduction`, `total_deduction`, `updated_at`, `version`, `employee_id`) VALUES (21,'2026-05-07 10:00:00.000000','payroll.officer','2026-05-02 09:00:00.000000',22000000.00,2310000.00,19071000.00,0.00,'2026-04-30','2026-04-01','2026-05-08 10:00:00.000000','payroll.officer','Lương T4/2026','PROCESSED',619000.00,2929000.00,'2026-07-06 06:23:25.644778',0,4);
INSERT INTO `payroll_result` (`id`, `approved_at`, `approved_by`, `created_at`, `gross_pay`, `insurance_deduction`, `net_pay`, `other_deduction`, `period_end_date`, `period_start_date`, `processed_at`, `processed_by`, `remarks`, `status`, `tax_deduction`, `total_deduction`, `updated_at`, `version`, `employee_id`) VALUES (22,'2026-05-07 10:00:00.000000','payroll.officer','2026-05-02 09:00:00.000000',24000000.00,2520000.00,20658000.00,0.00,'2026-04-30','2026-04-01','2026-05-08 10:00:00.000000','payroll.officer','Lương T4/2026','PROCESSED',822000.00,3342000.00,'2026-07-06 06:23:25.644778',0,5);
INSERT INTO `payroll_result` (`id`, `approved_at`, `approved_by`, `created_at`, `gross_pay`, `insurance_deduction`, `net_pay`, `other_deduction`, `period_end_date`, `period_start_date`, `processed_at`, `processed_by`, `remarks`, `status`, `tax_deduction`, `total_deduction`, `updated_at`, `version`, `employee_id`) VALUES (23,'2026-05-07 10:00:00.000000','payroll.officer','2026-05-02 09:00:00.000000',23000000.00,2415000.00,19876000.00,0.00,'2026-04-30','2026-04-01','2026-05-08 10:00:00.000000','payroll.officer','Lương T4/2026','PROCESSED',709000.00,3124000.00,'2026-07-06 06:23:25.644778',0,6);
INSERT INTO `payroll_result` (`id`, `approved_at`, `approved_by`, `created_at`, `gross_pay`, `insurance_deduction`, `net_pay`, `other_deduction`, `period_end_date`, `period_start_date`, `processed_at`, `processed_by`, `remarks`, `status`, `tax_deduction`, `total_deduction`, `updated_at`, `version`, `employee_id`) VALUES (24,'2026-05-07 10:00:00.000000','payroll.officer','2026-05-02 09:00:00.000000',19000000.00,1995000.00,16654000.00,0.00,'2026-04-30','2026-04-01','2026-05-08 10:00:00.000000','payroll.officer','Lương T4/2026','PROCESSED',351000.00,2346000.00,'2026-07-06 06:23:25.644778',0,7);
INSERT INTO `payroll_result` (`id`, `approved_at`, `approved_by`, `created_at`, `gross_pay`, `insurance_deduction`, `net_pay`, `other_deduction`, `period_end_date`, `period_start_date`, `processed_at`, `processed_by`, `remarks`, `status`, `tax_deduction`, `total_deduction`, `updated_at`, `version`, `employee_id`) VALUES (25,'2026-05-07 10:00:00.000000','payroll.officer','2026-05-02 09:00:00.000000',21000000.00,2205000.00,18265000.00,0.00,'2026-04-30','2026-04-01','2026-05-08 10:00:00.000000','payroll.officer','Lương T4/2026','PROCESSED',530000.00,2735000.00,'2026-07-06 06:23:25.644778',0,8);
INSERT INTO `payroll_result` (`id`, `approved_at`, `approved_by`, `created_at`, `gross_pay`, `insurance_deduction`, `net_pay`, `other_deduction`, `period_end_date`, `period_start_date`, `processed_at`, `processed_by`, `remarks`, `status`, `tax_deduction`, `total_deduction`, `updated_at`, `version`, `employee_id`) VALUES (26,'2026-05-07 10:00:00.000000','payroll.officer','2026-05-02 09:00:00.000000',42000000.00,4410000.00,33922000.00,0.00,'2026-04-30','2026-04-01','2026-05-08 10:00:00.000000','payroll.officer','Lương T4/2026','PROCESSED',3668000.00,8078000.00,'2026-07-06 06:23:25.644778',0,9);
INSERT INTO `payroll_result` (`id`, `approved_at`, `approved_by`, `created_at`, `gross_pay`, `insurance_deduction`, `net_pay`, `other_deduction`, `period_end_date`, `period_start_date`, `processed_at`, `processed_by`, `remarks`, `status`, `tax_deduction`, `total_deduction`, `updated_at`, `version`, `employee_id`) VALUES (27,'2026-05-07 10:00:00.000000','payroll.officer','2026-05-02 09:00:00.000000',15000000.00,1575000.00,13304000.00,0.00,'2026-04-30','2026-04-01','2026-05-08 10:00:00.000000','payroll.officer','Lương T4/2026','PROCESSED',121000.00,1696000.00,'2026-07-06 06:23:25.644778',0,10);
INSERT INTO `payroll_result` (`id`, `approved_at`, `approved_by`, `created_at`, `gross_pay`, `insurance_deduction`, `net_pay`, `other_deduction`, `period_end_date`, `period_start_date`, `processed_at`, `processed_by`, `remarks`, `status`, `tax_deduction`, `total_deduction`, `updated_at`, `version`, `employee_id`) VALUES (28,'2026-05-07 10:00:00.000000','payroll.officer','2026-05-02 09:00:00.000000',35000000.00,3675000.00,28910000.00,0.00,'2026-04-30','2026-04-01','2026-05-08 10:00:00.000000','payroll.officer','Lương T4/2026','PROCESSED',2415000.00,6090000.00,'2026-07-06 06:23:25.644778',0,11);
INSERT INTO `payroll_result` (`id`, `approved_at`, `approved_by`, `created_at`, `gross_pay`, `insurance_deduction`, `net_pay`, `other_deduction`, `period_end_date`, `period_start_date`, `processed_at`, `processed_by`, `remarks`, `status`, `tax_deduction`, `total_deduction`, `updated_at`, `version`, `employee_id`) VALUES (29,'2026-05-07 10:00:00.000000','payroll.officer','2026-05-02 09:00:00.000000',14000000.00,1470000.00,12453000.00,0.00,'2026-04-30','2026-04-01','2026-05-08 10:00:00.000000','payroll.officer','Lương T4/2026','PROCESSED',77000.00,1547000.00,'2026-07-06 06:23:25.644778',0,12);
INSERT INTO `payroll_result` (`id`, `approved_at`, `approved_by`, `created_at`, `gross_pay`, `insurance_deduction`, `net_pay`, `other_deduction`, `period_end_date`, `period_start_date`, `processed_at`, `processed_by`, `remarks`, `status`, `tax_deduction`, `total_deduction`, `updated_at`, `version`, `employee_id`) VALUES (30,'2026-05-07 10:00:00.000000','payroll.officer','2026-05-02 09:00:00.000000',32000000.00,3360000.00,26744000.00,0.00,'2026-04-30','2026-04-01','2026-05-08 10:00:00.000000','payroll.officer','Lương T4/2026','PROCESSED',1896000.00,5256000.00,'2026-07-06 06:23:25.644778',0,13);
INSERT INTO `payroll_result` (`id`, `approved_at`, `approved_by`, `created_at`, `gross_pay`, `insurance_deduction`, `net_pay`, `other_deduction`, `period_end_date`, `period_start_date`, `processed_at`, `processed_by`, `remarks`, `status`, `tax_deduction`, `total_deduction`, `updated_at`, `version`, `employee_id`) VALUES (31,'2026-06-06 10:00:00.000000','payroll.officer','2026-06-02 09:00:00.000000',85000000.00,8925000.00,62402000.00,0.00,'2026-05-31','2026-05-01',NULL,NULL,'Lương T5/2026 chờ thanh toán','APPROVED',13673000.00,22598000.00,'2026-07-06 06:23:25.644778',0,1);
INSERT INTO `payroll_result` (`id`, `approved_at`, `approved_by`, `created_at`, `gross_pay`, `insurance_deduction`, `net_pay`, `other_deduction`, `period_end_date`, `period_start_date`, `processed_at`, `processed_by`, `remarks`, `status`, `tax_deduction`, `total_deduction`, `updated_at`, `version`, `employee_id`) VALUES (32,'2026-06-06 10:00:00.000000','payroll.officer','2026-06-02 09:00:00.000000',45000000.00,4725000.00,36070000.00,0.00,'2026-05-31','2026-05-01',NULL,NULL,'Lương T5/2026 chờ thanh toán','APPROVED',4205000.00,8930000.00,'2026-07-06 06:23:25.644778',0,2);
INSERT INTO `payroll_result` (`id`, `approved_at`, `approved_by`, `created_at`, `gross_pay`, `insurance_deduction`, `net_pay`, `other_deduction`, `period_end_date`, `period_start_date`, `processed_at`, `processed_by`, `remarks`, `status`, `tax_deduction`, `total_deduction`, `updated_at`, `version`, `employee_id`) VALUES (33,'2026-06-06 10:00:00.000000','payroll.officer','2026-06-02 09:00:00.000000',55000000.00,5775000.00,42919000.00,0.00,'2026-05-31','2026-05-01',NULL,NULL,'Lương T5/2026 chờ thanh toán','APPROVED',6306000.00,12081000.00,'2026-07-06 06:23:25.644778',0,3);
INSERT INTO `payroll_result` (`id`, `approved_at`, `approved_by`, `created_at`, `gross_pay`, `insurance_deduction`, `net_pay`, `other_deduction`, `period_end_date`, `period_start_date`, `processed_at`, `processed_by`, `remarks`, `status`, `tax_deduction`, `total_deduction`, `updated_at`, `version`, `employee_id`) VALUES (34,'2026-06-06 10:00:00.000000','payroll.officer','2026-06-02 09:00:00.000000',24000000.00,2520000.00,20658000.00,0.00,'2026-05-31','2026-05-01',NULL,NULL,'Lương T5/2026 chờ thanh toán','APPROVED',822000.00,3342000.00,'2026-07-06 06:23:25.644778',0,5);
INSERT INTO `payroll_result` (`id`, `approved_at`, `approved_by`, `created_at`, `gross_pay`, `insurance_deduction`, `net_pay`, `other_deduction`, `period_end_date`, `period_start_date`, `processed_at`, `processed_by`, `remarks`, `status`, `tax_deduction`, `total_deduction`, `updated_at`, `version`, `employee_id`) VALUES (35,'2026-06-06 10:00:00.000000','payroll.officer','2026-06-02 09:00:00.000000',23000000.00,2415000.00,19876000.00,0.00,'2026-05-31','2026-05-01',NULL,NULL,'Lương T5/2026 chờ thanh toán','APPROVED',709000.00,3124000.00,'2026-07-06 06:23:25.644778',0,6);
INSERT INTO `payroll_result` (`id`, `approved_at`, `approved_by`, `created_at`, `gross_pay`, `insurance_deduction`, `net_pay`, `other_deduction`, `period_end_date`, `period_start_date`, `processed_at`, `processed_by`, `remarks`, `status`, `tax_deduction`, `total_deduction`, `updated_at`, `version`, `employee_id`) VALUES (36,'2026-06-06 10:00:00.000000','payroll.officer','2026-06-02 09:00:00.000000',19000000.00,1995000.00,16654000.00,0.00,'2026-05-31','2026-05-01',NULL,NULL,'Lương T5/2026 chờ thanh toán','APPROVED',351000.00,2346000.00,'2026-07-06 06:23:25.644778',0,7);
INSERT INTO `payroll_result` (`id`, `approved_at`, `approved_by`, `created_at`, `gross_pay`, `insurance_deduction`, `net_pay`, `other_deduction`, `period_end_date`, `period_start_date`, `processed_at`, `processed_by`, `remarks`, `status`, `tax_deduction`, `total_deduction`, `updated_at`, `version`, `employee_id`) VALUES (37,'2026-06-06 10:00:00.000000','payroll.officer','2026-06-02 09:00:00.000000',21000000.00,2205000.00,18265000.00,0.00,'2026-05-31','2026-05-01',NULL,NULL,'Lương T5/2026 chờ thanh toán','APPROVED',530000.00,2735000.00,'2026-07-06 06:23:25.644778',0,8);
INSERT INTO `payroll_result` (`id`, `approved_at`, `approved_by`, `created_at`, `gross_pay`, `insurance_deduction`, `net_pay`, `other_deduction`, `period_end_date`, `period_start_date`, `processed_at`, `processed_by`, `remarks`, `status`, `tax_deduction`, `total_deduction`, `updated_at`, `version`, `employee_id`) VALUES (38,'2026-06-06 10:00:00.000000','payroll.officer','2026-06-02 09:00:00.000000',42000000.00,4410000.00,33922000.00,0.00,'2026-05-31','2026-05-01',NULL,NULL,'Lương T5/2026 chờ thanh toán','APPROVED',3668000.00,8078000.00,'2026-07-06 06:23:25.644778',0,9);
INSERT INTO `payroll_result` (`id`, `approved_at`, `approved_by`, `created_at`, `gross_pay`, `insurance_deduction`, `net_pay`, `other_deduction`, `period_end_date`, `period_start_date`, `processed_at`, `processed_by`, `remarks`, `status`, `tax_deduction`, `total_deduction`, `updated_at`, `version`, `employee_id`) VALUES (39,'2026-06-06 10:00:00.000000','payroll.officer','2026-06-02 09:00:00.000000',15000000.00,1575000.00,13304000.00,0.00,'2026-05-31','2026-05-01',NULL,NULL,'Lương T5/2026 chờ thanh toán','APPROVED',121000.00,1696000.00,'2026-07-06 06:23:25.644778',0,10);
INSERT INTO `payroll_result` (`id`, `approved_at`, `approved_by`, `created_at`, `gross_pay`, `insurance_deduction`, `net_pay`, `other_deduction`, `period_end_date`, `period_start_date`, `processed_at`, `processed_by`, `remarks`, `status`, `tax_deduction`, `total_deduction`, `updated_at`, `version`, `employee_id`) VALUES (40,'2026-06-06 10:00:00.000000','payroll.officer','2026-06-02 09:00:00.000000',35000000.00,3675000.00,28910000.00,0.00,'2026-05-31','2026-05-01',NULL,NULL,'Lương T5/2026 chờ thanh toán','APPROVED',2415000.00,6090000.00,'2026-07-06 06:23:25.644778',0,11);
INSERT INTO `payroll_result` (`id`, `approved_at`, `approved_by`, `created_at`, `gross_pay`, `insurance_deduction`, `net_pay`, `other_deduction`, `period_end_date`, `period_start_date`, `processed_at`, `processed_by`, `remarks`, `status`, `tax_deduction`, `total_deduction`, `updated_at`, `version`, `employee_id`) VALUES (41,'2026-06-06 10:00:00.000000','payroll.officer','2026-06-02 09:00:00.000000',14000000.00,1470000.00,12453000.00,0.00,'2026-05-31','2026-05-01',NULL,NULL,'Lương T5/2026 chờ thanh toán','APPROVED',77000.00,1547000.00,'2026-07-06 06:23:25.644778',0,12);
INSERT INTO `payroll_result` (`id`, `approved_at`, `approved_by`, `created_at`, `gross_pay`, `insurance_deduction`, `net_pay`, `other_deduction`, `period_end_date`, `period_start_date`, `processed_at`, `processed_by`, `remarks`, `status`, `tax_deduction`, `total_deduction`, `updated_at`, `version`, `employee_id`) VALUES (42,NULL,NULL,'2026-06-20 09:00:00.000000',85000000.00,8925000.00,62402000.00,0.00,'2026-06-30','2026-06-01',NULL,NULL,'Lương T6/2026 — đang xử lý','DRAFT',13673000.00,22598000.00,'2026-07-06 06:23:25.644778',0,1);
INSERT INTO `payroll_result` (`id`, `approved_at`, `approved_by`, `created_at`, `gross_pay`, `insurance_deduction`, `net_pay`, `other_deduction`, `period_end_date`, `period_start_date`, `processed_at`, `processed_by`, `remarks`, `status`, `tax_deduction`, `total_deduction`, `updated_at`, `version`, `employee_id`) VALUES (43,NULL,NULL,'2026-06-20 09:00:00.000000',45000000.00,4725000.00,36070000.00,0.00,'2026-06-30','2026-06-01',NULL,NULL,'Lương T6/2026 — đang xử lý','DRAFT',4205000.00,8930000.00,'2026-07-06 06:23:25.644778',0,2);
INSERT INTO `payroll_result` (`id`, `approved_at`, `approved_by`, `created_at`, `gross_pay`, `insurance_deduction`, `net_pay`, `other_deduction`, `period_end_date`, `period_start_date`, `processed_at`, `processed_by`, `remarks`, `status`, `tax_deduction`, `total_deduction`, `updated_at`, `version`, `employee_id`) VALUES (44,NULL,NULL,'2026-06-20 09:00:00.000000',55000000.00,5775000.00,42919000.00,0.00,'2026-06-30','2026-06-01',NULL,NULL,'Lương T6/2026 — đang xử lý','DRAFT',6306000.00,12081000.00,'2026-07-06 06:23:25.644778',0,3);
INSERT INTO `payroll_result` (`id`, `approved_at`, `approved_by`, `created_at`, `gross_pay`, `insurance_deduction`, `net_pay`, `other_deduction`, `period_end_date`, `period_start_date`, `processed_at`, `processed_by`, `remarks`, `status`, `tax_deduction`, `total_deduction`, `updated_at`, `version`, `employee_id`) VALUES (45,NULL,NULL,'2026-06-20 09:00:00.000000',22000000.00,2310000.00,19071000.00,0.00,'2026-06-30','2026-06-01',NULL,NULL,'Lương T6/2026 — đang xử lý','DRAFT',619000.00,2929000.00,'2026-07-06 06:23:25.644778',0,4);
INSERT INTO `payroll_result` (`id`, `approved_at`, `approved_by`, `created_at`, `gross_pay`, `insurance_deduction`, `net_pay`, `other_deduction`, `period_end_date`, `period_start_date`, `processed_at`, `processed_by`, `remarks`, `status`, `tax_deduction`, `total_deduction`, `updated_at`, `version`, `employee_id`) VALUES (46,NULL,NULL,'2026-06-20 09:00:00.000000',19000000.00,1995000.00,16654000.00,0.00,'2026-06-30','2026-06-01',NULL,NULL,'Lương T6/2026 — đang xử lý','DRAFT',351000.00,2346000.00,'2026-07-06 06:23:25.644778',0,7);
INSERT INTO `payroll_result` (`id`, `approved_at`, `approved_by`, `created_at`, `gross_pay`, `insurance_deduction`, `net_pay`, `other_deduction`, `period_end_date`, `period_start_date`, `processed_at`, `processed_by`, `remarks`, `status`, `tax_deduction`, `total_deduction`, `updated_at`, `version`, `employee_id`) VALUES (47,NULL,NULL,'2026-06-20 09:00:00.000000',42000000.00,4410000.00,33922000.00,0.00,'2026-06-30','2026-06-01',NULL,NULL,'Lương T6/2026 — đang xử lý','DRAFT',3668000.00,8078000.00,'2026-07-06 06:23:25.644778',0,9);
INSERT INTO `payroll_result` (`id`, `approved_at`, `approved_by`, `created_at`, `gross_pay`, `insurance_deduction`, `net_pay`, `other_deduction`, `period_end_date`, `period_start_date`, `processed_at`, `processed_by`, `remarks`, `status`, `tax_deduction`, `total_deduction`, `updated_at`, `version`, `employee_id`) VALUES (48,NULL,NULL,'2026-06-20 09:00:00.000000',35000000.00,3675000.00,28910000.00,0.00,'2026-06-30','2026-06-01',NULL,NULL,'Lương T6/2026 — đang xử lý','DRAFT',2415000.00,6090000.00,'2026-07-06 06:23:25.644778',0,11);
/*!40000 ALTER TABLE `payroll_result` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payroll_run`
--

DROP TABLE IF EXISTS `payroll_run`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payroll_run` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) NOT NULL,
  `period_end_date` date NOT NULL,
  `period_start_date` date NOT NULL,
  `requested_by` varchar(100) DEFAULT NULL,
  `source_system` varchar(100) DEFAULT NULL,
  `status` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payroll_run`
--

LOCK TABLES `payroll_run` WRITE;
/*!40000 ALTER TABLE `payroll_run` DISABLE KEYS */;
INSERT INTO `payroll_run` (`id`, `created_at`, `period_end_date`, `period_start_date`, `requested_by`, `source_system`, `status`) VALUES (1,'2026-06-07 17:24:17.117321','2026-05-31','2026-05-01','hr.manager','seed','REQUESTED');
INSERT INTO `payroll_run` (`id`, `created_at`, `period_end_date`, `period_start_date`, `requested_by`, `source_system`, `status`) VALUES (2,'2026-06-07 17:24:17.117321','2026-06-30','2026-06-01','payroll.officer','seed','REQUESTED');
INSERT INTO `payroll_run` (`id`, `created_at`, `period_end_date`, `period_start_date`, `requested_by`, `source_system`, `status`) VALUES (3,'2026-04-03 09:00:00.000000','2026-03-31','2026-03-01','payroll.officer','full-seed','PROCESSED');
INSERT INTO `payroll_run` (`id`, `created_at`, `period_end_date`, `period_start_date`, `requested_by`, `source_system`, `status`) VALUES (4,'2026-05-05 09:00:00.000000','2026-04-30','2026-04-01','payroll.officer','full-seed','PROCESSED');
/*!40000 ALTER TABLE `payroll_run` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `processed_sync_events`
--

DROP TABLE IF EXISTS `processed_sync_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `processed_sync_events` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `auth_user_id` varchar(36) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `did` varchar(255) DEFAULT NULL,
  `employee_id` bigint DEFAULT NULL,
  `event_id` varchar(100) NOT NULL,
  `username` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK1fn9jmxs83452d7l94gemh6s3` (`event_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `processed_sync_events`
--

LOCK TABLES `processed_sync_events` WRITE;
/*!40000 ALTER TABLE `processed_sync_events` DISABLE KEYS */;
INSERT INTO `processed_sync_events` (`id`, `auth_user_id`, `created_at`, `did`, `employee_id`, `event_id`, `username`) VALUES (1,'ee831e84-09c8-42f2-98d4-2dd6b9cf83a3','2026-06-05 16:08:45.137987',NULL,1,'dc1b3bec-ed34-40a3-b475-014ff830b37b','proxyuser1780675718589');
INSERT INTO `processed_sync_events` (`id`, `auth_user_id`, `created_at`, `did`, `employee_id`, `event_id`, `username`) VALUES (2,'2ddac8aa-18e8-4a5b-9d11-8ce4e1feca14','2026-06-12 02:26:38.900367',NULL,14,'8ab019db-aa34-41bc-8d6b-84cf4506d9e5','nhan');
INSERT INTO `processed_sync_events` (`id`, `auth_user_id`, `created_at`, `did`, `employee_id`, `event_id`, `username`) VALUES (3,'70e905da-b1be-4c38-87d9-e2816bdafea1','2026-06-12 08:43:33.379622',NULL,16,'ecebb2ab-eb80-4047-8a08-baf35dbcbf8d','kiet');
INSERT INTO `processed_sync_events` (`id`, `auth_user_id`, `created_at`, `did`, `employee_id`, `event_id`, `username`) VALUES (4,'f7b6cbdc-3e60-4acd-adb3-cc941cc51cd6','2026-06-13 15:01:07.022463',NULL,17,'100a0390-f51f-4446-9175-6a619e6df716','perf_1781362857223');
INSERT INTO `processed_sync_events` (`id`, `auth_user_id`, `created_at`, `did`, `employee_id`, `event_id`, `username`) VALUES (5,'3c7b46e9-3843-424f-9bc5-acab1e7ec4b7','2026-07-05 08:30:33.452090',NULL,29,'f2511853-4678-435d-8f20-dc45f8fbf676','user10');
/*!40000 ALTER TABLE `processed_sync_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tax_config`
--

DROP TABLE IF EXISTS `tax_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tax_config` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `country` varchar(3) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `is_active` bit(1) DEFAULT NULL,
  `max_bracket` decimal(12,2) DEFAULT NULL,
  `min_bracket` decimal(12,2) NOT NULL,
  `tax_rate` decimal(5,2) NOT NULL,
  `tax_year` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tax_config`
--

LOCK TABLES `tax_config` WRITE;
/*!40000 ALTER TABLE `tax_config` DISABLE KEYS */;
INSERT INTO `tax_config` (`id`, `country`, `description`, `is_active`, `max_bracket`, `min_bracket`, `tax_rate`, `tax_year`) VALUES (1,'VN','Bậc 1 — Thu nhập đến 5 triệu: thuế 5%',_binary '',5000000.00,0.00,5.00,2024);
INSERT INTO `tax_config` (`id`, `country`, `description`, `is_active`, `max_bracket`, `min_bracket`, `tax_rate`, `tax_year`) VALUES (2,'VN','Bậc 2 — Phần TN từ 5 đến 10 triệu: thuế 10%',_binary '',10000000.00,5000000.00,10.00,2024);
INSERT INTO `tax_config` (`id`, `country`, `description`, `is_active`, `max_bracket`, `min_bracket`, `tax_rate`, `tax_year`) VALUES (3,'VN','Bậc 3 — Phần TN từ 10 đến 18 triệu: thuế 15%',_binary '',18000000.00,10000000.00,15.00,2024);
INSERT INTO `tax_config` (`id`, `country`, `description`, `is_active`, `max_bracket`, `min_bracket`, `tax_rate`, `tax_year`) VALUES (4,'VN','Bậc 4 — Phần TN từ 18 đến 32 triệu: thuế 20%',_binary '',32000000.00,18000000.00,20.00,2024);
INSERT INTO `tax_config` (`id`, `country`, `description`, `is_active`, `max_bracket`, `min_bracket`, `tax_rate`, `tax_year`) VALUES (5,'VN','Bậc 5 — Phần TN từ 32 đến 52 triệu: thuế 25%',_binary '',52000000.00,32000000.00,25.00,2024);
INSERT INTO `tax_config` (`id`, `country`, `description`, `is_active`, `max_bracket`, `min_bracket`, `tax_rate`, `tax_year`) VALUES (6,'VN','Bậc 6 — Phần TN từ 52 đến 80 triệu: thuế 30%',_binary '',80000000.00,52000000.00,30.00,2024);
INSERT INTO `tax_config` (`id`, `country`, `description`, `is_active`, `max_bracket`, `min_bracket`, `tax_rate`, `tax_year`) VALUES (7,'VN','Bậc 7 — Phần TN trên 80 triệu: thuế 35%',_binary '',999999999.00,80000000.00,35.00,2024);
/*!40000 ALTER TABLE `tax_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'hr_service'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-07-06  6:24:28
