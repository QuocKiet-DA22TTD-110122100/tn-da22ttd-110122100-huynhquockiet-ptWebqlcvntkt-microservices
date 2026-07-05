-- ============================================================
-- ENTERPRISE SCALE ADD-ON SEED — ECC Group HR System (MySQL)
-- DBs: project_db + task_db
-- Muc tieu: them du lieu cap cong ty cho quan ly nhom va phan cong
-- ============================================================

-- ══════════════════════════════════════════════════════════════
-- PROJECT DB
-- ══════════════════════════════════════════════════════════════
USE project_db;

-- ── 1. Projects ──────────────────────────────────────────────
INSERT INTO projects (id, name, description, status, lead_id, created_at, updated_at)
VALUES
    (9,  'Internal Operations Hub',
     'Hop nhat quy trinh noi bo: onboarding, yeu cau noi bo, asset tracking va bao cao van hanh.',
     'ACTIVE', 27, '2026-06-01 08:00:00', NOW(6)),

    (10, 'Customer Support Scale-up',
     'Mo rong nang luc ho tro khach hang: knowledge base, SLA, ticket routing va bao cao chat luong.',
     'ACTIVE', 24, '2026-06-03 08:00:00', NOW(6)),

    (11, 'Security and Compliance Hardening',
     'Tang cuong an toan he thong: secrets rotation, audit log, dependency scan va incident playbook.',
     'ACTIVE', 16, '2026-06-05 08:00:00', NOW(6)),

    (12, 'Data and Reporting Hub',
     'Tong hop so lieu nhan su, project va task vao bo bao cao quan tri cho ban lanh dao.',
     'ACTIVE', 25, '2026-06-07 08:00:00', NOW(6))
ON DUPLICATE KEY UPDATE
    name = VALUES(name), description = VALUES(description),
    status = VALUES(status), lead_id = VALUES(lead_id),
    updated_at = NOW(6);

-- ── 2. Project Assignments ───────────────────────────────────
INSERT INTO project_assignments (id, project_id, employee_id, role, active, assigned_at)
VALUES
    -- Project 9: Internal Operations Hub
    (37, 9, 27, 'MANAGER',   b'1', '2026-06-01 08:00:00'),
    (38, 9, 2,  'DEVELOPER', b'1', '2026-06-02 08:00:00'),
    (39, 9, 10, 'MEMBER',    b'1', '2026-06-02 08:00:00'),
    (40, 9, 12, 'MEMBER',    b'1', '2026-06-03 08:00:00'),
    (41, 9, 18, 'MEMBER',    b'1', '2026-06-03 08:00:00'),
    (42, 9, 20, 'MEMBER',    b'1', '2026-06-03 08:00:00'),

    -- Project 10: Customer Support Scale-up
    (43, 10, 24, 'MANAGER',   b'1', '2026-06-03 08:00:00'),
    (44, 10, 6,  'DEVELOPER', b'1', '2026-06-04 08:00:00'),
    (45, 10, 7,  'QA',        b'1', '2026-06-04 08:00:00'),
    (46, 10, 15, 'DEVELOPER', b'1', '2026-06-05 08:00:00'),
    (47, 10, 21, 'DEVELOPER', b'1', '2026-06-05 08:00:00'),
    (48, 10, 23, 'DEVELOPER', b'1', '2026-06-06 08:00:00'),
    (49, 10, 28, 'MEMBER',    b'1', '2026-06-06 08:00:00'),

    -- Project 11: Security and Compliance Hardening
    (50, 11, 16, 'MANAGER',   b'1', '2026-06-05 08:00:00'),
    (51, 11, 11, 'DEVELOPER', b'1', '2026-06-06 08:00:00'),
    (52, 11, 17, 'DEVELOPER', b'1', '2026-06-06 08:00:00'),
    (53, 11, 22, 'MEMBER',    b'1', '2026-06-07 08:00:00'),
    (54, 11, 25, 'MEMBER',    b'1', '2026-06-07 08:00:00'),
    (55, 11, 26, 'MEMBER',    b'1', '2026-06-07 08:00:00'),

    -- Project 12: Data and Reporting Hub
    (56, 12, 25, 'MANAGER',   b'1', '2026-06-07 08:00:00'),
    (57, 12, 14, 'DEVELOPER', b'1', '2026-06-08 08:00:00'),
    (58, 12, 19, 'MEMBER',    b'1', '2026-06-08 08:00:00'),
    (59, 12, 1,  'MEMBER',    b'1', '2026-06-08 08:00:00'),
    (60, 12, 3,  'MEMBER',    b'1', '2026-06-09 08:00:00'),
    (61, 12, 4,  'MEMBER',    b'1', '2026-06-09 08:00:00'),
    (62, 12, 5,  'MEMBER',    b'1', '2026-06-09 08:00:00'),
    (63, 12, 8,  'MEMBER',    b'1', '2026-06-10 08:00:00'),
    (64, 12, 9,  'MEMBER',    b'1', '2026-06-10 08:00:00')
ON DUPLICATE KEY UPDATE
    role = VALUES(role), active = VALUES(active),
    assigned_at = VALUES(assigned_at);

-- ══════════════════════════════════════════════════════════════
-- TASK DB
-- ══════════════════════════════════════════════════════════════
USE task_db;

INSERT INTO tasks (id, title, description, status, priority, assignee_id, project_id, created_at, updated_at)
VALUES
    -- Project 9: Internal Operations Hub
    (49, 'Soan quy trinh onboarding noi bo',
     'Tao checklist chuan cho nhan su moi: tai khoan, thiet bi, quyen truy cap va phan cong nhom.',
     'OPEN', 'HIGH', 27, 9, '2026-06-01 09:00:00', NOW(6)),

    (50, 'Chuan hoa luong yeu cau noi bo',
     'Thiet ke form tap trung cho yeu cau HR, IT va hanh chinh; bo sung trang thai xu ly.',
     'IN_PROGRESS', 'HIGH', 2, 9, '2026-06-02 09:00:00', NOW(6)),

    (51, 'Kiem ke tai san cap nhat',
     'Doi chieu laptop, the, may in va tai san van phong theo chi nhanh.',
     'OPEN', 'MEDIUM', 10, 9, '2026-06-02 09:00:00', NOW(6)),

    (52, 'Dong bo du lieu chuyen khoan phuc loi',
     'Kiem tra thong tin phuc loi va khoan ho tro de san sang cho ky payroll tiep theo.',
     'OPEN', 'HIGH', 18, 9, '2026-06-03 09:00:00', NOW(6)),

    (53, 'Dashboard theo doi request noi bo',
     'Tao dashboard don gian cho so luong request moi, dang xu ly va da dong.',
     'OPEN', 'MEDIUM', 20, 9, '2026-06-03 09:00:00', NOW(6)),

    (54, 'Lich hop nhom va nhac viec',
     'Dinh nghia luong hop hang tuan va thong bao nhac viec cho truong nhom.',
     'COMPLETED', 'LOW', 12, 9, '2026-06-03 09:00:00', NOW(6)),

    -- Project 10: Customer Support Scale-up
    (55, 'Xay dung knowledge base cho support',
     'Bo sung bai viet FAQ, quy trinh tiep nhan ticket va mau tra loi nhanh.',
     'IN_PROGRESS', 'HIGH', 24, 10, '2026-06-03 09:00:00', NOW(6)),

    (56, 'Thiet ke giao dien support dashboard',
     'Hien thi ticket dang mo, SLA vi pham va phan bo theo agent.',
     'IN_PROGRESS', 'HIGH', 6, 10, '2026-06-04 09:00:00', NOW(6)),

    (57, 'Test regression support flow',
     'Kiem thu ky luong tat ca workflow ticket: tao, cap nhat, dong va reopen.',
     'OPEN', 'HIGH', 7, 10, '2026-06-04 09:00:00', NOW(6)),

    (58, 'Automation SLA escalation',
     'Bao dong va chuyen cap khi ticket qua han xu ly.',
     'OPEN', 'HIGH', 15, 10, '2026-06-05 09:00:00', NOW(6)),

    (59, 'Backend API cho case support',
     'Xay dung API lay danh sach case va cap nhat trang thai xu ly.',
     'IN_PROGRESS', 'HIGH', 21, 10, '2026-06-05 09:00:00', NOW(6)),

    (60, 'Onboarding va shadowing cho member moi',
     'Huong dan quy trinh support, cach phan loai ticket va quy tac ung xu.',
     'OPEN', 'MEDIUM', 23, 10, '2026-06-06 09:00:00', NOW(6)),

    (61, 'Bao cao CSAT theo thang',
     'Tong hop diem hai long khach hang va xep hang agent.',
     'OPEN', 'LOW', 28, 10, '2026-06-06 09:00:00', NOW(6)),

    -- Project 11: Security and Compliance Hardening
    (62, 'Tu dong hoa xoay secrets',
     'Doi secrets dinh ky va ghi log cac su kien thay doi.',
     'IN_PROGRESS', 'URGENT', 11, 11, '2026-06-05 09:00:00', NOW(6)),

    (63, 'Review bao mat CI pipeline',
     'Kiem tra secret expose, scan image va quyen truy cap runner.',
     'OPEN', 'HIGH', 16, 11, '2026-06-06 09:00:00', NOW(6)),

    (64, 'Audit log cho he thong cloud',
     'Them audit trace cho thao tac quan trong va trich xuat forensics.',
     'OPEN', 'HIGH', 17, 11, '2026-06-06 09:00:00', NOW(6)),

    (65, 'Ma tran quyen truy cap',
     'Doi chieu role, quyen va nhom de phat hien quyen thua.',
     'OPEN', 'MEDIUM', 22, 11, '2026-06-07 09:00:00', NOW(6)),

    (66, 'Incident response playbook',
     'Chuan hoa cac buoc xu ly su co va danh sach lien lac khi khan cap.',
     'OPEN', 'HIGH', 25, 11, '2026-06-07 09:00:00', NOW(6)),

    (67, 'Dependency and SAST scan policy',
     'Bat quet dependency va bao cao loi bao mat hang ngay.',
     'COMPLETED', 'MEDIUM', 26, 11, '2026-06-07 09:00:00', NOW(6)),

    -- Project 12: Data and Reporting Hub
    (68, 'Executive KPI dashboard',
     'Dashboard tong hop so lieu nhan su, chi phi va tien do du an.',
     'IN_PROGRESS', 'HIGH', 25, 12, '2026-06-07 09:00:00', NOW(6)),

    (69, 'Turnover analytics theo phong ban',
     'Phan tich ty le nghi viec va xuat so sanh giua cac phong ban.',
     'OPEN', 'HIGH', 14, 12, '2026-06-08 09:00:00', NOW(6)),

    (70, 'Revenue pipeline overview',
     'Tong hop du lieu pipeline kinh doanh va mapping sang nhan su phu trach.',
     'OPEN', 'MEDIUM', 19, 12, '2026-06-08 09:00:00', NOW(6)),

    (71, 'Normalize department KPI data',
     'Lam sach du lieu KPI de dong bo voi DWH.',
     'OPEN', 'MEDIUM', 1, 12, '2026-06-08 09:00:00', NOW(6)),

    (72, 'Project allocation report',
     'Tong hop so nguoi tren moi du an va canh bao team qua tai.',
     'IN_PROGRESS', 'HIGH', 3, 12, '2026-06-09 09:00:00', NOW(6)),

    (73, 'Task aging cleanup',
     'Loc cac task qua han va de xuat xu ly nhanh.',
     'OPEN', 'HIGH', 4, 12, '2026-06-09 09:00:00', NOW(6)),

    (74, 'Sprint status export',
     'Xuat bao cao sprint de gui ban lanh dao vao cuoi tuan.',
     'OPEN', 'LOW', 5, 12, '2026-06-09 09:00:00', NOW(6)),

    (75, 'Org chart sync job',
     'Dong bo cay to chuc va phong ban sang dashboard quan tri.',
     'OPEN', 'MEDIUM', 8, 12, '2026-06-10 09:00:00', NOW(6)),

    (76, 'Monthly leadership summary',
     'Tao ban tom tat thang cho ban lanh dao, gom nhan su, du an va chi phi.',
     'OPEN', 'HIGH', 9, 12, '2026-06-10 09:00:00', NOW(6))
ON DUPLICATE KEY UPDATE
    title = VALUES(title),
    description = VALUES(description),
    status = VALUES(status),
    priority = VALUES(priority),
    assignee_id = VALUES(assignee_id),
    project_id = VALUES(project_id),
    updated_at = NOW(6);

-- ── 3. Task History ──────────────────────────────────────────
INSERT INTO task_history (id, task_id, project_id, previous_status, new_status, reason, changed_at, changed_by)
VALUES
    (23, 50, 9, 'OPEN',       'IN_PROGRESS', 'Kick-off quy trinh noi bo',              '2026-06-02 10:00:00', 27),
    (24, 54, 9, 'IN_PROGRESS','COMPLETED',   'Lich hop da duoc cap nhat va chot lich',  '2026-06-04 16:00:00', 12),
    (25, 55, 10, 'OPEN',      'IN_PROGRESS', 'Bat dau xay dung knowledge base',         '2026-06-04 10:00:00', 24),
    (26, 56, 10, 'OPEN',      'IN_PROGRESS', 'Da co mockup dashboard support',          '2026-06-04 11:00:00', 6),
    (27, 62, 11, 'OPEN',      'IN_PROGRESS', 'Bat dau xay dung luong xoay secrets',     '2026-06-05 10:00:00', 11),
    (28, 67, 11, 'OPEN',      'COMPLETED',   'Policy scan da duoc phe duyet',           '2026-06-07 15:00:00', 26),
    (29, 68, 12, 'OPEN',      'IN_PROGRESS', 'Dashboard KPI da duoc khoi dong',         '2026-06-08 09:30:00', 25),
    (30, 72, 12, 'OPEN',      'IN_PROGRESS', 'Bat dau tinh toan allocation report',     '2026-06-09 10:00:00', 3),
    (31, 76, 12, 'OPEN',      'IN_PROGRESS', 'Ban lanh dao yeu cau ban tom tat thang',   '2026-06-10 09:30:00', 9),
    (32, 71, 12, 'OPEN',      'IN_PROGRESS', 'Lam sach KPI data truoc khi import',       '2026-06-08 12:00:00', 1)
ON DUPLICATE KEY UPDATE
    previous_status = VALUES(previous_status),
    new_status = VALUES(new_status),
    reason = VALUES(reason),
    changed_at = VALUES(changed_at),
    changed_by = VALUES(changed_by);