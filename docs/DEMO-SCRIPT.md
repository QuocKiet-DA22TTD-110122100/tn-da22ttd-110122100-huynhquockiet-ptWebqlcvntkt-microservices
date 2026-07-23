# Kịch bản Demo & Bảo vệ

## 1. Tổng quan hệ thống (2 phút)

### Kiến trúc Microservices
- **API Gateway** (port 8080) — cổng vào duy nhất, xác thực JWT
- **Auth Service** (port 8086) — JWT + RBAC + quản lý tài khoản
- **HR Service** (port 8082) — nhân viên, phòng ban, tổ chức, bảng lương
- **Project Service** (port 8084) — quản lý dự án
- **Task Service** (port 8087) — quản lý tác vụ
- **KMS** (port 8083) — quản lý khóa ký JWT
- **Frontend** (port 3000) — React + TypeScript + Vite

### Hạ tầng
| Component | Công nghệ |
|-----------|-----------|
| Cơ sở dữ liệu | PostgreSQL (Auth), MySQL (HR, Business) |
| Cache | Redis |
| Message Queue | RabbitMQ |
| Service Discovery | Eureka |
| Đóng gói | Docker Compose |

---

## 2. Luồng xác thực & phân quyền (3 phút)

### 2.1. Đăng nhập
```
User → Frontend → API Gateway → Auth Service → KMS (ký JWT) → Redis (blacklist)
```
1. User nhập username/password
2. Auth Service xác thực, kiểm tra khóa tài khoản
3. Nếu đúng → KMS ký JWT (EdDSA/Ed25519)
4. Trả JWT về frontend, lưu vào storage
5. Mỗi request sau đó gửi JWT trong header `Authorization: Bearer <token>`

### 2.2. RBAC
- **@RequiredRoles** annotation trên controller methods
- **AuthRoleInterceptor** kiểm tra JWT, giải mã claims, so khớp role
- **Không dùng** Spring Security — tự xây dựng cơ chế JWT + interceptor

### 2.3. Bảo mật bổ sung
- Rate limiting: tối đa 3 lần đăng nhập sai trong 5 giây
- Khóa tài khoản tự động sau N lần sai
- Password history: không cho dùng lại 3 mật khẩu gần nhất
- Mật khẩu phải: >=8 ký tự, có chữ hoa, thường, số, ký tự đặc biệt
- JWT blacklist qua Redis khi logout
- Internal Secret kiểm tra request nội bộ giữa các service

---

## 3. Các module nghiệp vụ (5 phút)

### 3.1. Quản lý tài khoản & vai trò (`/users`, `/roles`)
- **CRUD** tài khoản + vai trò
- Khóa/Mở khóa tài khoản
- Ma trận phân quyền matrix view
- Audit log mới: mọi thao tác (tạo/sửa/xóa user/role, khóa/mở, đăng nhập, đổi mật khẩu) đều ghi vào bảng `audit_log`

### 3.2. Quản lý nhân viên & phòng ban (`/employees`, `/departments`, `/organizations`)
- CRUD nhân viên, phòng ban, đơn vị tổ chức
- Cây tổ chức (Organization Unit)
- Liên kết nhân viên ↔ phòng ban ↔ đơn vị tổ chức

### 3.3. Quản lý dự án & tác vụ (`/projects`, `/tasks`)
- CRUD dự án, phân công nhân viên
- CRUD tác vụ, filter theo trạng thái/ưu tiên
- Kanban board, Discussions, Notifications
- AI Suggestions (gợi ý thông minh), Risk Radar

### 3.4. Bảng lương (`/payroll`)
- Tạo kỳ lương mới
- Tính lương tự động
- Workflow: PENDING → APPROVED → PROCESSED
- Phê duyệt/Từ chối/Xử lý chi trả
- Lịch sử thay đổi (PayrollHistory)

### 3.5. Role-based Workspaces (`/workspace/:slug`)
- Mỗi role có workspace riêng:
  - **Admin**: Audit, Users, Roles, Organizations, Employees, Departments
  - **HR Manager**: HR Records, Benefits, Departments, Employees
  - **Payroll Officer**: Payroll, Employees
  - **Department Head**: Approvals, Department Reports, Team Tasks
  - **Manager**: Timesheet Approval, Team Tasks, Approvals
  - **Employee**: Timekeeping, Leave, My Tasks, Personal Tasks
  - **User**: Account Security, Profile, Change Password
- Dữ liệu workspace kết nối API thật (audit_log, account-security)

---

## 4. Audit Log (tính năng mới)

### Backend
- Bảng `audit_log` trong PostgreSQL (auth-service)
- Entity: `AuditLog.java` — id, eventType, actorId, actorUsername, targetType, targetId, description, oldValue, newValue, ipAddress, createdAt
- Repository: `AuditLogRepository` — phân trang, lọc theo eventType/khoảng thời gian
- Service: `AuditService` — ghi log + query
- Endpoint: `GET /xac-thuc/nhat-ky` (yêu cầu role ADMIN)
- Các sự kiện được ghi:
  - `LOGIN_SUCCESS` / `LOGIN_MFA_REQUIRED`
  - `USER_CREATE` / `USER_UPDATE` / `USER_DELETE`
  - `ACCOUNT_LOCK` / `ACCOUNT_UNLOCK`
  - `PASSWORD_CHANGE`
  - `ROLE_CREATE` / `ROLE_UPDATE` / `ROLE_DELETE`

### Frontend
- Audit workspace (`/workspace/audit`) hiển thị dữ liệu thật từ API
- Hiển thị danh sách sự kiện gần đây với: mô tả, người thao tác, IP, thời gian
- Fallback về phân tích từ user/role API khi audit_log chưa có dữ liệu

---

## 5. Kịch bản demo chi tiết (8-10 phút)

### Mở đầu (1 phút)
> "Hệ thống được xây dựng theo kiến trúc Microservices với 8 service chính, đóng gói bằng Docker Compose. Tôi sẽ demo luồng từ đăng nhập đến các nghiệp vụ cốt lõi."

### Bước 1: Khởi động hệ thống (1 phút)
```bash
cd src
docker compose -f compose.minimal.yml up -d
# Kiểm tra: docker ps → tất cả container đều healthy
```

### Bước 2: Đăng nhập & Xác thực (1 phút)
1. Mở http://localhost:3000
2. Đăng nhập với tài khoản admin
3. **Chỉ rõ**: JWT được tạo, lưu vào localStorage, gửi kèm mỗi request
4. Kiểm tra: thử request không có token → 401

### Bước 3: Quản trị hệ thống (2 phút)
1. **User Management** (`/users`): Tạo user mới, khóa/mở khóa
2. **Role Management** (`/roles`): Tạo role, gán permission, xem matrix
3. **Audit Log** (`/workspace/audit`): Xem log các thao tác vừa thực hiện

### Bước 4: Nghiệp vụ nhân sự (1.5 phút)
1. **Nhân viên** (`/employees`): Thêm/sửa/xóa nhân viên
2. **Phòng ban** (`/departments`): Tạo phòng ban, gán trưởng phòng
3. **Tổ chức** (`/organizations`): Xem cây đơn vị

### Bước 5: Dự án & Công việc (1.5 phút)
1. **Dự án** (`/projects`): Tạo dự án, phân công
2. **Tác vụ** (`/tasks`): Tạo task, filter, cập nhật trạng thái
3. **Work Management** (`/work`): Kanban board, discussions

### Bước 6: Bảng lương (1 phút)
1. Tạo kỳ lương mới
2. Tính lương
3. Workflow: Pending → Approve → Processed

### Bước 7: Role-based Workspace (1 phút)
1. Demo workspace với user có role khác nhau
2. Account Security workspace hiển thị thông tin tài khoản thật
3. Audit workspace hiển thị log thật

### Kết luận (1 phút)
> "Hệ thống đã đáp ứng các yêu cầu: (1) Kiến trúc Microservices với các service độc lập, (2) JWT + RBAC bảo vệ toàn bộ API, (3) Các module nghiệp vụ đầy đủ, (4) Audit log ghi lại mọi thao tác nhạy cảm, (5) Giao diện phân vai theo từng nhóm người dùng."

---

## 6. Câu hỏi bảo vệ thường gặp

### Kiến trúc
- **Tại sao chọn Microservices thay vì Monolith?** → Khả năng mở rộng độc lập, mỗi service có database riêng, dễ bảo trì
- **Tại sao không dùng Spring Security?** → Tự xây dựng JWT để kiểm soát hoàn toàn luồng xác thực, phù hợp với EdDSA
- **Cơ chế giao tiếp giữa các service?** → REST đồng bộ qua Gateway, RabbitMQ bất đồng bộ cho sự kiện (đồng bộ user, thông báo)

### Bảo mật
- **Làm sao JWT không bị giả mạo?** → Ký bằng EdDSA/Ed25519, khóa riêng chỉ KMS biết, các service xác thực qua JWKS
- **Token bị đánh cắp thì sao?** → Có blacklist qua Redis khi logout, token có thời gian hết hạn
- **Rate limiting hoạt động thế nào?** → LoginAttemptService đếm số lần fail, khóa 30 phút sau N lần

### Audit Log
- **Tại sao audit log đặt trong Auth Service?** → Vì phần lớn sự kiện audit liên quan đến bảo mật/auth (đăng nhập, khóa/mở, thay đổi role)
- **Audit log có thể bị giả mạo?** → Chỉ ghi ở backend, không cho phép sửa/xóa, chỉ Admin mới xem được

### Demo
- **Có bao nhiêu container?** → 10 container: gateway, auth, hr, project, task, kms, frontend, postgresql, mysql, redis
- **Docker compose nào dùng cho demo?** → `compose.minimal.yml` — chạy các service + database, không bao gồm Eureka/RabbitMQ để đơn giản

---

## 7. Kiến trúc chi tiết (cho slide)

```
┌─────────────────────────────────────────────────────────┐
│                     Frontend (React)                     │
│              http://localhost:3000                       │
└──────────────────────────┬──────────────────────────────┘
                           │ HTTP (JWT Bearer)
                           ▼
┌─────────────────────────────────────────────────────────┐
│                   API Gateway (Netty)                    │
│                   http://localhost:8080                  │
│              AuthRoleInterceptor (JWT check)             │
└──┬──────┬──────┬──────┬──────┬──────┬───────────────────┘
   │      │      │      │      │      │
   ▼      ▼      ▼      ▼      ▼      ▼
 Auth   KMS    HR    Project Task  Frontend
 :8086 :8083 :8082  :8084  :8087  :3000
   │      │
   ▼      ▼
 Redis  ─┴─ PostgreSQL (Auth)
                  MySQL (HR, Business)
```
