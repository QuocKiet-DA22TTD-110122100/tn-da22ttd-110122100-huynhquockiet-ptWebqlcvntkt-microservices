--
-- PostgreSQL database dump
--

\restrict nWtttzSWqapX4qnzrIYrwoPVe8Zg71p03sLA2r5BJfOzee5R5eS7fbAHaByojAS

-- Dumped from database version 16.13
-- Dumped by pg_dump version 16.13

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: audit_log; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.audit_log (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    event_type character varying(50) NOT NULL,
    actor_id character varying(36),
    actor_username character varying(100),
    target_type character varying(50),
    target_id character varying(36),
    description character varying(1000),
    old_value text,
    new_value text,
    ip_address character varying(45),
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: role_definitions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.role_definitions (
    name character varying(50) NOT NULL,
    description character varying(500) NOT NULL,
    permissions text NOT NULL,
    system_role boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: user_password_history; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_password_history (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    password_hash character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: user_sync_dlq; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_sync_dlq (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    event_id uuid NOT NULL,
    user_id uuid NOT NULL,
    username character varying(100) NOT NULL,
    role character varying(50) NOT NULL,
    retry_count integer NOT NULL,
    failure_reason text,
    payload_json text,
    failed_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: user_sync_outbox; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_sync_outbox (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    event_id uuid NOT NULL,
    user_id uuid NOT NULL,
    username character varying(100) NOT NULL,
    role character varying(50) NOT NULL,
    status character varying(20) NOT NULL,
    retry_count integer DEFAULT 0 NOT NULL,
    max_retries integer DEFAULT 5 NOT NULL,
    next_retry_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    synced_at timestamp with time zone,
    last_error text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT user_sync_outbox_status_check CHECK (((status)::text = ANY ((ARRAY['PENDING'::character varying, 'RETRYING'::character varying, 'SYNCED'::character varying, 'FAILED'::character varying])::text[])))
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    username character varying(100) NOT NULL,
    password_hash character varying(255) NOT NULL,
    role character varying(50) NOT NULL,
    password_updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    locked boolean DEFAULT false NOT NULL,
    locked_at timestamp with time zone,
    two_factor_enabled boolean DEFAULT false NOT NULL,
    two_factor_secret character varying(128),
    two_factor_enabled_at timestamp with time zone
);


--
-- Data for Name: audit_log; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.audit_log (id, event_type, actor_id, actor_username, target_type, target_id, description, old_value, new_value, ip_address, created_at) VALUES ('2cbd07ca-bb40-4671-9273-da05433502b1', 'LOGIN_SUCCESS', NULL, NULL, 'USER', NULL, 'Đăng nhập thành công: admin', NULL, NULL, NULL, '2026-07-06 04:53:22.651653+00');
INSERT INTO public.audit_log (id, event_type, actor_id, actor_username, target_type, target_id, description, old_value, new_value, ip_address, created_at) VALUES ('66dcf39b-e8d5-432d-bf02-d0a0b8e224fc', 'LOGIN_SUCCESS', NULL, NULL, 'USER', NULL, 'Đăng nhập thành công: admin', NULL, NULL, NULL, '2026-07-06 06:16:00.177439+00');
INSERT INTO public.audit_log (id, event_type, actor_id, actor_username, target_type, target_id, description, old_value, new_value, ip_address, created_at) VALUES ('0563bc8a-d854-42a7-8bec-fa4bfb679f80', 'LOGIN_SUCCESS', NULL, NULL, 'USER', NULL, 'Đăng nhập thành công: admin', NULL, NULL, NULL, '2026-07-06 06:16:58.886418+00');
INSERT INTO public.audit_log (id, event_type, actor_id, actor_username, target_type, target_id, description, old_value, new_value, ip_address, created_at) VALUES ('91997d1f-1985-4cf1-bd9d-edd47ca543de', 'LOGIN_SUCCESS', NULL, NULL, 'USER', NULL, 'Đăng nhập thành công: admin', NULL, NULL, NULL, '2026-07-06 06:16:58.952867+00');
INSERT INTO public.audit_log (id, event_type, actor_id, actor_username, target_type, target_id, description, old_value, new_value, ip_address, created_at) VALUES ('bb093615-ce5d-4064-8421-f9a29db6f676', 'LOGIN_SUCCESS', NULL, NULL, 'USER', NULL, 'Đăng nhập thành công: admin', NULL, NULL, NULL, '2026-07-06 06:16:58.87284+00');
INSERT INTO public.audit_log (id, event_type, actor_id, actor_username, target_type, target_id, description, old_value, new_value, ip_address, created_at) VALUES ('64130f20-f089-406a-9e8c-7313cac84245', 'LOGIN_SUCCESS', NULL, NULL, 'USER', NULL, 'Đăng nhập thành công: admin', NULL, NULL, NULL, '2026-07-06 06:16:58.885978+00');
INSERT INTO public.audit_log (id, event_type, actor_id, actor_username, target_type, target_id, description, old_value, new_value, ip_address, created_at) VALUES ('36c62f9f-9d97-46bb-b1b4-56fabaae6009', 'LOGIN_SUCCESS', NULL, NULL, 'USER', NULL, 'Đăng nhập thành công: admin', NULL, NULL, NULL, '2026-07-06 06:16:59.141962+00');


--
-- Data for Name: role_definitions; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.role_definitions (name, description, permissions, system_role, created_at, updated_at) VALUES ('ADMIN', 'Quản trị hệ thống toàn quyền', 'ALL', true, '2026-07-06 06:12:03.224897+00', '2026-07-06 06:12:03.224897+00');
INSERT INTO public.role_definitions (name, description, permissions, system_role, created_at, updated_at) VALUES ('HR_MANAGER', 'Quản lý nhân sự', 'READ_EMPLOYEE,WRITE_EMPLOYEE,DELETE_EMPLOYEE,READ_DEPARTMENT,WRITE_DEPARTMENT,DELETE_DEPARTMENT,READ_ORGANIZATION,WRITE_ORGANIZATION,READ_USER,READ_PROJECT,READ_TASK,READ_PAYROLL,WRITE_PAYROLL,APPROVE_PAYROLL', true, '2026-07-06 06:12:03.224897+00', '2026-07-06 06:12:03.224897+00');
INSERT INTO public.role_definitions (name, description, permissions, system_role, created_at, updated_at) VALUES ('PAYROLL_OFFICER', 'Chuyên viên tính lương', 'READ_EMPLOYEE,READ_PAYROLL,WRITE_PAYROLL,APPROVE_PAYROLL,PROCESS_PAYROLL', true, '2026-07-06 06:12:03.224897+00', '2026-07-06 06:12:03.224897+00');
INSERT INTO public.role_definitions (name, description, permissions, system_role, created_at, updated_at) VALUES ('DEPARTMENT_HEAD', 'Trưởng phòng', 'READ_EMPLOYEE,READ_DEPARTMENT,READ_ORGANIZATION,READ_PROJECT,READ_TASK,WRITE_TASK', true, '2026-07-06 06:12:03.224897+00', '2026-07-06 06:12:03.224897+00');
INSERT INTO public.role_definitions (name, description, permissions, system_role, created_at, updated_at) VALUES ('MANAGER', 'Quản lý dự án / nhóm', 'READ_EMPLOYEE,READ_DEPARTMENT,READ_PROJECT,WRITE_PROJECT,READ_TASK,WRITE_TASK,DELETE_TASK', true, '2026-07-06 06:12:03.224897+00', '2026-07-06 06:12:03.224897+00');
INSERT INTO public.role_definitions (name, description, permissions, system_role, created_at, updated_at) VALUES ('EMPLOYEE', 'Nhân viên tiêu chuẩn', 'READ_EMPLOYEE,READ_DEPARTMENT,READ_ORGANIZATION,READ_PROJECT,READ_TASK', true, '2026-07-06 06:12:03.224897+00', '2026-07-06 06:12:03.224897+00');
INSERT INTO public.role_definitions (name, description, permissions, system_role, created_at, updated_at) VALUES ('USER', 'Người dùng chưa phân quyền', '', true, '2026-07-06 06:12:03.224897+00', '2026-07-06 06:12:03.224897+00');


--
-- Data for Name: user_password_history; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.user_password_history (id, user_id, password_hash, created_at) VALUES ('5b6f808e-9cae-4f2d-8a9f-d0f3e25f68cf', '28759924-7b71-4220-bf8d-06d64ce7cae6', '$argon2id$v=19$m=16384,t=2,p=1$8EcW3dyBX1zOpzRDM5yVkw$6WWw2ZyPPKi9/5ttPXrUqzJaTR6koEQW7ph9hXSyMZ0', '2026-07-06 06:12:03.250297+00');
INSERT INTO public.user_password_history (id, user_id, password_hash, created_at) VALUES ('9fffe7be-0d4d-4b79-8d93-7159306123cd', '3c07be88-39df-4e33-8e20-71ba6ad4af5a', '$argon2id$v=19$m=16384,t=2,p=1$8EcW3dyBX1zOpzRDM5yVkw$6WWw2ZyPPKi9/5ttPXrUqzJaTR6koEQW7ph9hXSyMZ0', '2026-07-06 06:12:03.250297+00');
INSERT INTO public.user_password_history (id, user_id, password_hash, created_at) VALUES ('f0974040-ce86-4f2b-a91f-9fe905ce45b0', 'f6f8b8a7-7df7-42f4-a3e1-c34daed22755', '$argon2id$v=19$m=16384,t=2,p=1$8EcW3dyBX1zOpzRDM5yVkw$6WWw2ZyPPKi9/5ttPXrUqzJaTR6koEQW7ph9hXSyMZ0', '2026-07-06 06:12:03.250297+00');
INSERT INTO public.user_password_history (id, user_id, password_hash, created_at) VALUES ('9268f0ac-d193-4baa-aea1-84fe40b437f0', '49ca806e-2725-4af8-a049-2625ea5bc8ac', '$argon2id$v=19$m=16384,t=2,p=1$8EcW3dyBX1zOpzRDM5yVkw$6WWw2ZyPPKi9/5ttPXrUqzJaTR6koEQW7ph9hXSyMZ0', '2026-07-06 06:12:03.250297+00');
INSERT INTO public.user_password_history (id, user_id, password_hash, created_at) VALUES ('c4b2747a-155e-4f37-a93b-fd473f75d514', 'f9831e0f-9b28-43d9-b3ab-94df70f2e33e', '$argon2id$v=19$m=16384,t=2,p=1$8EcW3dyBX1zOpzRDM5yVkw$6WWw2ZyPPKi9/5ttPXrUqzJaTR6koEQW7ph9hXSyMZ0', '2026-07-06 06:12:03.250297+00');
INSERT INTO public.user_password_history (id, user_id, password_hash, created_at) VALUES ('d1000001-0000-0000-0000-000000000001', 'a1000019-0000-0000-0000-000000000019', '$argon2id$v=19$m=16384,t=2,p=1$8EcW3dyBX1zOpzRDM5yVkw$6WWw2ZyPPKi9/5ttPXrUqzJaTR6koEQW7ph9hXSyMZ0', '2026-07-06 06:12:03.250297+00');
INSERT INTO public.user_password_history (id, user_id, password_hash, created_at) VALUES ('d1000002-0000-0000-0000-000000000002', 'a1000020-0000-0000-0000-000000000020', '$argon2id$v=19$m=16384,t=2,p=1$8EcW3dyBX1zOpzRDM5yVkw$6WWw2ZyPPKi9/5ttPXrUqzJaTR6koEQW7ph9hXSyMZ0', '2026-07-06 06:12:03.250297+00');
INSERT INTO public.user_password_history (id, user_id, password_hash, created_at) VALUES ('d1000003-0000-0000-0000-000000000003', 'a1000021-0000-0000-0000-000000000021', '$argon2id$v=19$m=16384,t=2,p=1$8EcW3dyBX1zOpzRDM5yVkw$6WWw2ZyPPKi9/5ttPXrUqzJaTR6koEQW7ph9hXSyMZ0', '2026-07-06 06:12:03.250297+00');
INSERT INTO public.user_password_history (id, user_id, password_hash, created_at) VALUES ('d1000004-0000-0000-0000-000000000004', 'a1000022-0000-0000-0000-000000000022', '$argon2id$v=19$m=16384,t=2,p=1$8EcW3dyBX1zOpzRDM5yVkw$6WWw2ZyPPKi9/5ttPXrUqzJaTR6koEQW7ph9hXSyMZ0', '2026-07-06 06:12:03.250297+00');
INSERT INTO public.user_password_history (id, user_id, password_hash, created_at) VALUES ('d1000005-0000-0000-0000-000000000005', 'a1000023-0000-0000-0000-000000000023', '$argon2id$v=19$m=16384,t=2,p=1$8EcW3dyBX1zOpzRDM5yVkw$6WWw2ZyPPKi9/5ttPXrUqzJaTR6koEQW7ph9hXSyMZ0', '2026-07-06 06:12:03.250297+00');


--
-- Data for Name: user_sync_dlq; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: user_sync_outbox; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.users (id, username, password_hash, role, password_updated_at, created_at, updated_at, locked, locked_at, two_factor_enabled, two_factor_secret, two_factor_enabled_at) VALUES ('28759924-7b71-4220-bf8d-06d64ce7cae6', 'admin', '$argon2id$v=19$m=16384,t=2,p=1$8EcW3dyBX1zOpzRDM5yVkw$6WWw2ZyPPKi9/5ttPXrUqzJaTR6koEQW7ph9hXSyMZ0', 'ADMIN', '2026-07-06 06:12:03.235839+00', '2026-07-06 06:12:03.235839+00', '2026-07-06 06:12:03.235839+00', false, NULL, false, NULL, NULL);
INSERT INTO public.users (id, username, password_hash, role, password_updated_at, created_at, updated_at, locked, locked_at, two_factor_enabled, two_factor_secret, two_factor_enabled_at) VALUES ('a1000013-0000-0000-0000-000000000013', 'tran.duc.hung', '$argon2id$v=19$m=16384,t=2,p=1$8EcW3dyBX1zOpzRDM5yVkw$6WWw2ZyPPKi9/5ttPXrUqzJaTR6koEQW7ph9hXSyMZ0', 'DEPARTMENT_HEAD', '2026-07-06 06:12:03.235839+00', '2026-07-06 06:12:03.235839+00', '2026-07-06 06:12:03.235839+00', false, NULL, false, NULL, NULL);
INSERT INTO public.users (id, username, password_hash, role, password_updated_at, created_at, updated_at, locked, locked_at, two_factor_enabled, two_factor_secret, two_factor_enabled_at) VALUES ('3c07be88-39df-4e33-8e20-71ba6ad4af5a', 'hr.manager', '$argon2id$v=19$m=16384,t=2,p=1$8EcW3dyBX1zOpzRDM5yVkw$6WWw2ZyPPKi9/5ttPXrUqzJaTR6koEQW7ph9hXSyMZ0', 'HR_MANAGER', '2026-07-06 06:12:03.235839+00', '2026-07-06 06:12:03.235839+00', '2026-07-06 06:12:03.235839+00', false, NULL, false, NULL, NULL);
INSERT INTO public.users (id, username, password_hash, role, password_updated_at, created_at, updated_at, locked, locked_at, two_factor_enabled, two_factor_secret, two_factor_enabled_at) VALUES ('a1000014-0000-0000-0000-000000000014', 'nguyen.minh.tuan', '$argon2id$v=19$m=16384,t=2,p=1$8EcW3dyBX1zOpzRDM5yVkw$6WWw2ZyPPKi9/5ttPXrUqzJaTR6koEQW7ph9hXSyMZ0', 'HR_MANAGER', '2026-07-06 06:12:03.235839+00', '2026-07-06 06:12:03.235839+00', '2026-07-06 06:12:03.235839+00', false, NULL, false, NULL, NULL);
INSERT INTO public.users (id, username, password_hash, role, password_updated_at, created_at, updated_at, locked, locked_at, two_factor_enabled, two_factor_secret, two_factor_enabled_at) VALUES ('f6f8b8a7-7df7-42f4-a3e1-c34daed22755', 'payroll.officer', '$argon2id$v=19$m=16384,t=2,p=1$8EcW3dyBX1zOpzRDM5yVkw$6WWw2ZyPPKi9/5ttPXrUqzJaTR6koEQW7ph9hXSyMZ0', 'PAYROLL_OFFICER', '2026-07-06 06:12:03.235839+00', '2026-07-06 06:12:03.235839+00', '2026-07-06 06:12:03.235839+00', false, NULL, false, NULL, NULL);
INSERT INTO public.users (id, username, password_hash, role, password_updated_at, created_at, updated_at, locked, locked_at, two_factor_enabled, two_factor_secret, two_factor_enabled_at) VALUES ('a1000015-0000-0000-0000-000000000015', 'pham.thu.hoa', '$argon2id$v=19$m=16384,t=2,p=1$8EcW3dyBX1zOpzRDM5yVkw$6WWw2ZyPPKi9/5ttPXrUqzJaTR6koEQW7ph9hXSyMZ0', 'PAYROLL_OFFICER', '2026-07-06 06:12:03.235839+00', '2026-07-06 06:12:03.235839+00', '2026-07-06 06:12:03.235839+00', false, NULL, false, NULL, NULL);
INSERT INTO public.users (id, username, password_hash, role, password_updated_at, created_at, updated_at, locked, locked_at, two_factor_enabled, two_factor_secret, two_factor_enabled_at) VALUES ('49ca806e-2725-4af8-a049-2625ea5bc8ac', 'manager', '$argon2id$v=19$m=16384,t=2,p=1$8EcW3dyBX1zOpzRDM5yVkw$6WWw2ZyPPKi9/5ttPXrUqzJaTR6koEQW7ph9hXSyMZ0', 'MANAGER', '2026-07-06 06:12:03.235839+00', '2026-07-06 06:12:03.235839+00', '2026-07-06 06:12:03.235839+00', false, NULL, false, NULL, NULL);
INSERT INTO public.users (id, username, password_hash, role, password_updated_at, created_at, updated_at, locked, locked_at, two_factor_enabled, two_factor_secret, two_factor_enabled_at) VALUES ('a1000002-0000-0000-0000-000000000002', 'pham.bich.ngoc', '$argon2id$v=19$m=16384,t=2,p=1$8EcW3dyBX1zOpzRDM5yVkw$6WWw2ZyPPKi9/5ttPXrUqzJaTR6koEQW7ph9hXSyMZ0', 'MANAGER', '2026-07-06 06:12:03.235839+00', '2026-07-06 06:12:03.235839+00', '2026-07-06 06:12:03.235839+00', false, NULL, false, NULL, NULL);
INSERT INTO public.users (id, username, password_hash, role, password_updated_at, created_at, updated_at, locked, locked_at, two_factor_enabled, two_factor_secret, two_factor_enabled_at) VALUES ('a1000003-0000-0000-0000-000000000003', 'tran.duc.thanh', '$argon2id$v=19$m=16384,t=2,p=1$8EcW3dyBX1zOpzRDM5yVkw$6WWw2ZyPPKi9/5ttPXrUqzJaTR6koEQW7ph9hXSyMZ0', 'MANAGER', '2026-07-06 06:12:03.235839+00', '2026-07-06 06:12:03.235839+00', '2026-07-06 06:12:03.235839+00', false, NULL, false, NULL, NULL);
INSERT INTO public.users (id, username, password_hash, role, password_updated_at, created_at, updated_at, locked, locked_at, two_factor_enabled, two_factor_secret, two_factor_enabled_at) VALUES ('a1000006-0000-0000-0000-000000000006', 'nguyen.thanh.long', '$argon2id$v=19$m=16384,t=2,p=1$8EcW3dyBX1zOpzRDM5yVkw$6WWw2ZyPPKi9/5ttPXrUqzJaTR6koEQW7ph9hXSyMZ0', 'MANAGER', '2026-07-06 06:12:03.235839+00', '2026-07-06 06:12:03.235839+00', '2026-07-06 06:12:03.235839+00', false, NULL, false, NULL, NULL);
INSERT INTO public.users (id, username, password_hash, role, password_updated_at, created_at, updated_at, locked, locked_at, two_factor_enabled, two_factor_secret, two_factor_enabled_at) VALUES ('f9831e0f-9b28-43d9-b3ab-94df70f2e33e', 'employee', '$argon2id$v=19$m=16384,t=2,p=1$8EcW3dyBX1zOpzRDM5yVkw$6WWw2ZyPPKi9/5ttPXrUqzJaTR6koEQW7ph9hXSyMZ0', 'EMPLOYEE', '2026-07-06 06:12:03.235839+00', '2026-07-06 06:12:03.235839+00', '2026-07-06 06:12:03.235839+00', false, NULL, false, NULL, NULL);
INSERT INTO public.users (id, username, password_hash, role, password_updated_at, created_at, updated_at, locked, locked_at, two_factor_enabled, two_factor_secret, two_factor_enabled_at) VALUES ('a1000001-0000-0000-0000-000000000001', 'nguyen.van.an', '$argon2id$v=19$m=16384,t=2,p=1$8EcW3dyBX1zOpzRDM5yVkw$6WWw2ZyPPKi9/5ttPXrUqzJaTR6koEQW7ph9hXSyMZ0', 'EMPLOYEE', '2026-07-06 06:12:03.235839+00', '2026-07-06 06:12:03.235839+00', '2026-07-06 06:12:03.235839+00', false, NULL, false, NULL, NULL);
INSERT INTO public.users (id, username, password_hash, role, password_updated_at, created_at, updated_at, locked, locked_at, two_factor_enabled, two_factor_secret, two_factor_enabled_at) VALUES ('a1000004-0000-0000-0000-000000000004', 'le.hoang.minh', '$argon2id$v=19$m=16384,t=2,p=1$8EcW3dyBX1zOpzRDM5yVkw$6WWw2ZyPPKi9/5ttPXrUqzJaTR6koEQW7ph9hXSyMZ0', 'EMPLOYEE', '2026-07-06 06:12:03.235839+00', '2026-07-06 06:12:03.235839+00', '2026-07-06 06:12:03.235839+00', false, NULL, false, NULL, NULL);
INSERT INTO public.users (id, username, password_hash, role, password_updated_at, created_at, updated_at, locked, locked_at, two_factor_enabled, two_factor_secret, two_factor_enabled_at) VALUES ('a1000005-0000-0000-0000-000000000005', 'vo.kim.chi', '$argon2id$v=19$m=16384,t=2,p=1$8EcW3dyBX1zOpzRDM5yVkw$6WWw2ZyPPKi9/5ttPXrUqzJaTR6koEQW7ph9hXSyMZ0', 'EMPLOYEE', '2026-07-06 06:12:03.235839+00', '2026-07-06 06:12:03.235839+00', '2026-07-06 06:12:03.235839+00', false, NULL, false, NULL, NULL);
INSERT INTO public.users (id, username, password_hash, role, password_updated_at, created_at, updated_at, locked, locked_at, two_factor_enabled, two_factor_secret, two_factor_enabled_at) VALUES ('a1000007-0000-0000-0000-000000000007', 'truong.thi.lan', '$argon2id$v=19$m=16384,t=2,p=1$8EcW3dyBX1zOpzRDM5yVkw$6WWw2ZyPPKi9/5ttPXrUqzJaTR6koEQW7ph9hXSyMZ0', 'EMPLOYEE', '2026-07-06 06:12:03.235839+00', '2026-07-06 06:12:03.235839+00', '2026-07-06 06:12:03.235839+00', false, NULL, false, NULL, NULL);
INSERT INTO public.users (id, username, password_hash, role, password_updated_at, created_at, updated_at, locked, locked_at, two_factor_enabled, two_factor_secret, two_factor_enabled_at) VALUES ('a1000008-0000-0000-0000-000000000008', 'hoang.duc.nam', '$argon2id$v=19$m=16384,t=2,p=1$8EcW3dyBX1zOpzRDM5yVkw$6WWw2ZyPPKi9/5ttPXrUqzJaTR6koEQW7ph9hXSyMZ0', 'EMPLOYEE', '2026-07-06 06:12:03.235839+00', '2026-07-06 06:12:03.235839+00', '2026-07-06 06:12:03.235839+00', false, NULL, false, NULL, NULL);
INSERT INTO public.users (id, username, password_hash, role, password_updated_at, created_at, updated_at, locked, locked_at, two_factor_enabled, two_factor_secret, two_factor_enabled_at) VALUES ('a1000009-0000-0000-0000-000000000009', 'dang.thi.huong', '$argon2id$v=19$m=16384,t=2,p=1$8EcW3dyBX1zOpzRDM5yVkw$6WWw2ZyPPKi9/5ttPXrUqzJaTR6koEQW7ph9hXSyMZ0', 'EMPLOYEE', '2026-07-06 06:12:03.235839+00', '2026-07-06 06:12:03.235839+00', '2026-07-06 06:12:03.235839+00', false, NULL, false, NULL, NULL);
INSERT INTO public.users (id, username, password_hash, role, password_updated_at, created_at, updated_at, locked, locked_at, two_factor_enabled, two_factor_secret, two_factor_enabled_at) VALUES ('a1000010-0000-0000-0000-000000000010', 'bui.quang.vinh', '$argon2id$v=19$m=16384,t=2,p=1$8EcW3dyBX1zOpzRDM5yVkw$6WWw2ZyPPKi9/5ttPXrUqzJaTR6koEQW7ph9hXSyMZ0', 'EMPLOYEE', '2026-07-06 06:12:03.235839+00', '2026-07-06 06:12:03.235839+00', '2026-07-06 06:12:03.235839+00', false, NULL, false, NULL, NULL);
INSERT INTO public.users (id, username, password_hash, role, password_updated_at, created_at, updated_at, locked, locked_at, two_factor_enabled, two_factor_secret, two_factor_enabled_at) VALUES ('a1000011-0000-0000-0000-000000000011', 'do.thi.thuy', '$argon2id$v=19$m=16384,t=2,p=1$8EcW3dyBX1zOpzRDM5yVkw$6WWw2ZyPPKi9/5ttPXrUqzJaTR6koEQW7ph9hXSyMZ0', 'EMPLOYEE', '2026-07-06 06:12:03.235839+00', '2026-07-06 06:12:03.235839+00', '2026-07-06 06:12:03.235839+00', false, NULL, false, NULL, NULL);
INSERT INTO public.users (id, username, password_hash, role, password_updated_at, created_at, updated_at, locked, locked_at, two_factor_enabled, two_factor_secret, two_factor_enabled_at) VALUES ('a1000012-0000-0000-0000-000000000012', 'ly.van.hoa', '$argon2id$v=19$m=16384,t=2,p=1$8EcW3dyBX1zOpzRDM5yVkw$6WWw2ZyPPKi9/5ttPXrUqzJaTR6koEQW7ph9hXSyMZ0', 'EMPLOYEE', '2026-07-06 06:12:03.235839+00', '2026-07-06 06:12:03.235839+00', '2026-07-06 06:12:03.235839+00', false, NULL, false, NULL, NULL);
INSERT INTO public.users (id, username, password_hash, role, password_updated_at, created_at, updated_at, locked, locked_at, two_factor_enabled, two_factor_secret, two_factor_enabled_at) VALUES ('a1000016-0000-0000-0000-000000000016', 'tran.hai.yen', '$argon2id$v=19$m=16384,t=2,p=1$8EcW3dyBX1zOpzRDM5yVkw$6WWw2ZyPPKi9/5ttPXrUqzJaTR6koEQW7ph9hXSyMZ0', 'HR_MANAGER', '2026-07-06 06:12:03.235839+00', '2026-07-06 06:12:03.235839+00', '2026-07-06 06:12:03.235839+00', false, NULL, false, NULL, NULL);
INSERT INTO public.users (id, username, password_hash, role, password_updated_at, created_at, updated_at, locked, locked_at, two_factor_enabled, two_factor_secret, two_factor_enabled_at) VALUES ('a1000017-0000-0000-0000-000000000017', 'dang.quoc.bao', '$argon2id$v=19$m=16384,t=2,p=1$8EcW3dyBX1zOpzRDM5yVkw$6WWw2ZyPPKi9/5ttPXrUqzJaTR6koEQW7ph9hXSyMZ0', 'MANAGER', '2026-07-06 06:12:03.235839+00', '2026-07-06 06:12:03.235839+00', '2026-07-06 06:12:03.235839+00', false, NULL, false, NULL, NULL);
INSERT INTO public.users (id, username, password_hash, role, password_updated_at, created_at, updated_at, locked, locked_at, two_factor_enabled, two_factor_secret, two_factor_enabled_at) VALUES ('a1000018-0000-0000-0000-000000000018', 'hoang.kim.ngan', '$argon2id$v=19$m=16384,t=2,p=1$8EcW3dyBX1zOpzRDM5yVkw$6WWw2ZyPPKi9/5ttPXrUqzJaTR6koEQW7ph9hXSyMZ0', 'EMPLOYEE', '2026-07-06 06:12:03.235839+00', '2026-07-06 06:12:03.235839+00', '2026-07-06 06:12:03.235839+00', false, NULL, false, NULL, NULL);
INSERT INTO public.users (id, username, password_hash, role, password_updated_at, created_at, updated_at, locked, locked_at, two_factor_enabled, two_factor_secret, two_factor_enabled_at) VALUES ('a1000019-0000-0000-0000-000000000019', 'pham.hoang.nam', '$argon2id$v=19$m=16384,t=2,p=1$8EcW3dyBX1zOpzRDM5yVkw$6WWw2ZyPPKi9/5ttPXrUqzJaTR6koEQW7ph9hXSyMZ0', 'EMPLOYEE', '2026-07-06 06:12:03.235839+00', '2026-07-06 06:12:03.235839+00', '2026-07-06 06:12:03.235839+00', false, NULL, false, NULL, NULL);
INSERT INTO public.users (id, username, password_hash, role, password_updated_at, created_at, updated_at, locked, locked_at, two_factor_enabled, two_factor_secret, two_factor_enabled_at) VALUES ('a1000020-0000-0000-0000-000000000020', 'vo.thanh.dat', '$argon2id$v=19$m=16384,t=2,p=1$8EcW3dyBX1zOpzRDM5yVkw$6WWw2ZyPPKi9/5ttPXrUqzJaTR6koEQW7ph9hXSyMZ0', 'EMPLOYEE', '2026-07-06 06:12:03.235839+00', '2026-07-06 06:12:03.235839+00', '2026-07-06 06:12:03.235839+00', false, NULL, false, NULL, NULL);
INSERT INTO public.users (id, username, password_hash, role, password_updated_at, created_at, updated_at, locked, locked_at, two_factor_enabled, two_factor_secret, two_factor_enabled_at) VALUES ('a1000021-0000-0000-0000-000000000021', 'nguyen.my.duyen', '$argon2id$v=19$m=16384,t=2,p=1$8EcW3dyBX1zOpzRDM5yVkw$6WWw2ZyPPKi9/5ttPXrUqzJaTR6koEQW7ph9hXSyMZ0', 'EMPLOYEE', '2026-07-06 06:12:03.235839+00', '2026-07-06 06:12:03.235839+00', '2026-07-06 06:12:03.235839+00', false, NULL, false, NULL, NULL);
INSERT INTO public.users (id, username, password_hash, role, password_updated_at, created_at, updated_at, locked, locked_at, two_factor_enabled, two_factor_secret, two_factor_enabled_at) VALUES ('a1000022-0000-0000-0000-000000000022', 'bui.manh.khoa', '$argon2id$v=19$m=16384,t=2,p=1$8EcW3dyBX1zOpzRDM5yVkw$6WWw2ZyPPKi9/5ttPXrUqzJaTR6koEQW7ph9hXSyMZ0', 'EMPLOYEE', '2026-07-06 06:12:03.235839+00', '2026-07-06 06:12:03.235839+00', '2026-07-06 06:12:03.235839+00', false, NULL, false, NULL, NULL);
INSERT INTO public.users (id, username, password_hash, role, password_updated_at, created_at, updated_at, locked, locked_at, two_factor_enabled, two_factor_secret, two_factor_enabled_at) VALUES ('a1000023-0000-0000-0000-000000000023', 'le.minh.chau', '$argon2id$v=19$m=16384,t=2,p=1$8EcW3dyBX1zOpzRDM5yVkw$6WWw2ZyPPKi9/5ttPXrUqzJaTR6koEQW7ph9hXSyMZ0', 'EMPLOYEE', '2026-07-06 06:12:03.235839+00', '2026-07-06 06:12:03.235839+00', '2026-07-06 06:12:03.235839+00', false, NULL, false, NULL, NULL);


--
-- Name: audit_log audit_log_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_log
    ADD CONSTRAINT audit_log_pkey PRIMARY KEY (id);


--
-- Name: role_definitions role_definitions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_definitions
    ADD CONSTRAINT role_definitions_pkey PRIMARY KEY (name);


--
-- Name: user_password_history user_password_history_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_password_history
    ADD CONSTRAINT user_password_history_pkey PRIMARY KEY (id);


--
-- Name: user_sync_dlq user_sync_dlq_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_sync_dlq
    ADD CONSTRAINT user_sync_dlq_pkey PRIMARY KEY (id);


--
-- Name: user_sync_outbox user_sync_outbox_event_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_sync_outbox
    ADD CONSTRAINT user_sync_outbox_event_id_key UNIQUE (event_id);


--
-- Name: user_sync_outbox user_sync_outbox_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_sync_outbox
    ADD CONSTRAINT user_sync_outbox_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: idx_audit_log_actor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_audit_log_actor_id ON public.audit_log USING btree (actor_id);


--
-- Name: idx_audit_log_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_audit_log_created_at ON public.audit_log USING btree (created_at);


--
-- Name: idx_audit_log_event_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_audit_log_event_type ON public.audit_log USING btree (event_type);


--
-- Name: idx_audit_log_target; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_audit_log_target ON public.audit_log USING btree (target_type, target_id);


--
-- Name: idx_user_password_history_user_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_password_history_user_created ON public.user_password_history USING btree (user_id, created_at DESC);


--
-- Name: idx_user_sync_dlq_user_failed; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_sync_dlq_user_failed ON public.user_sync_dlq USING btree (user_id, failed_at DESC);


--
-- Name: idx_user_sync_outbox_polling; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_sync_outbox_polling ON public.user_sync_outbox USING btree (status, next_retry_at, created_at);


--
-- Name: idx_user_sync_outbox_user_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_sync_outbox_user_created ON public.user_sync_outbox USING btree (user_id, created_at DESC);


--
-- Name: user_password_history fk_user_password_history_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_password_history
    ADD CONSTRAINT fk_user_password_history_user FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict nWtttzSWqapX4qnzrIYrwoPVe8Zg71p03sLA2r5BJfOzee5R5eS7fbAHaByojAS

