import { useEffect, useMemo, useState } from 'react';
import { Link } from 'react-router-dom';
import {
  AlertCircle,
  ArrowRight,
  CheckCircle2,
  Clock3,
  Copy,
  FolderKanban,
  FolderTree,
  Hourglass,
  ListChecks,
  LucideIcon,
  Mail,
  ShieldCheck,
  Sparkles,
  Users,
} from 'lucide-react';
import { departmentApi } from '@/api/department.api';
import { employeeApi } from '@/api/employee.api';
import { projectApi } from '@/api/project.api';
import { roleApi } from '@/api/role.api';
import { taskApi } from '@/api/task.api';
import { userApi } from '@/api/user.api';
import { MainLayout } from '@/components/Layout/MainLayout';
import { Badge } from '@/components/UI/Badge';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/UI/Card';
import { useAuthStore } from '@/store/authStore';
import { useUIStore } from '@/store/uiStore';
import { usePermissions } from '@/hooks/usePermissions';
import { resolveWorkspaceRole, roleProfiles, WorkspaceRole } from '@/config/roleExperience';
import { formatDate, getPasswordExpiryWarning } from '@/utils/format';
import { PERMISSIONS } from '@/utils/permissions';
import { cn } from '@/utils/cn';

type Priority = 'high' | 'medium' | 'normal';

interface RoleWorkItem {
  title: string;
  description: string;
  meta: string;
  priority: Priority;
  href: string;
}

interface RoleDashboardExperience {
  summaryTitle: string;
  operatingModel: string;
  accessNotes: string[];
}

const priorityStyles: Record<Priority, { label: string; variant: 'danger' | 'warning' | 'success' }> = {
  high: { label: 'Ưu tiên cao', variant: 'danger' },
  medium: { label: 'Cần xử lý', variant: 'warning' },
  normal: { label: 'Ổn định', variant: 'success' },
};

// Một tông brand duy nhất (indigo) — màu sắc khác chỉ dành cho trạng thái (Badge).
const cardShell =
  'group relative h-full rounded-2xl border border-slate-200/90 bg-white transition duration-150 ease-out hover:-translate-y-0.5 hover:border-indigo-200 hover:shadow-[0_12px_28px_-10px_rgba(67,56,202,0.18)] focus-within:-translate-y-0.5 focus-within:border-indigo-200';

const iconSquare =
  'flex h-10 w-10 shrink-0 items-center justify-center rounded-xl bg-indigo-50 text-indigo-600 ring-1 ring-indigo-100 transition duration-150 group-hover:scale-105';

const dashboardExperience: Record<WorkspaceRole, RoleDashboardExperience> = {
  user: {
    summaryTitle: 'Tổng quan tài khoản',
    operatingModel: 'Người dùng cơ bản tập trung vào hồ sơ, bảo mật và phạm vi quyền truy cập cá nhân.',
    accessNotes: ['Chỉ thấy hồ sơ, bảo mật và quyền truy cập', 'Không mở module nghiệp vụ khi chưa có role phù hợp', 'Route vẫn được bảo vệ bởi ProtectedRoute'],
  },
  employee: {
    summaryTitle: 'Tổng quan công việc cá nhân',
    operatingModel: 'Nhân viên theo dõi chấm công, nghỉ phép và task cá nhân được giao.',
    accessNotes: ['Có workspace chấm công, nghỉ phép, task cá nhân', 'Không có quyền role hoặc audit hệ thống', 'Chỉ xem dữ liệu trong phạm vi cá nhân'],
  },
  manager: {
    summaryTitle: 'Tổng quan quản lý nhóm',
    operatingModel: 'Quản lý xử lý phê duyệt hằng ngày và giữ nhịp task của nhóm.',
    accessNotes: ['Có duyệt timesheet và task nhóm', 'Không có quyền role/audit hệ thống', 'Dữ liệu nhân sự giới hạn theo nhóm'],
  },
  departmentHead: {
    summaryTitle: 'Tổng quan điều hành phòng ban',
    operatingModel: 'Trưởng phòng theo dõi sức khỏe phòng ban, phê duyệt cấp phòng và rủi ro tải công việc.',
    accessNotes: ['Có báo cáo và phê duyệt cấp phòng', 'Có thể xem nhân sự trong phạm vi phòng ban', 'Không trực tiếp cấu hình role hệ thống'],
  },
  payroll: {
    summaryTitle: 'Tổng quan bảng lương',
    operatingModel: 'Payroll Officer theo dõi kỳ lương, tính lương, phê duyệt và trạng thái chi trả.',
    accessNotes: ['Có quyền xem hồ sơ nhân viên để đối soát payroll', 'Có PAYROLL_MANAGE để tạo kỳ, tính lương và phê duyệt', 'Không có quyền quản lý user, role, project hoặc task'],
  },
  hr: {
    summaryTitle: 'Tổng quan nghiệp vụ nhân sự',
    operatingModel: 'HR giữ dữ liệu nhân sự, phúc lợi và thay đổi phòng ban sẵn sàng cho vận hành.',
    accessNotes: ['Có hồ sơ nhân sự và phúc lợi', 'Có thể quản lý phòng ban/tổ chức', 'Không mặc định có quyền xóa role hệ thống'],
  },
  admin: {
    summaryTitle: 'Tổng quan quản trị',
    operatingModel: 'Admin kiểm soát tài khoản, role, quyền truy cập và các điểm cần audit.',
    accessNotes: ['Có toàn bộ quản trị tài khoản và role', 'Có quyền xem cấu trúc tổ chức', 'Audit là vùng UI chuẩn bị nối backend'],
  },
};

interface DashboardData {
  loading: boolean;
  employees: number | null;
  departments: number | null;
  activeProjects: number | null;
  openTasks: number | null;
  inProgressTasks: number | null;
  completedTasks: number | null;
  urgentTasks: number | null;
  totalUsers: number | null;
  lockedUsers: number | null;
  privilegedUsers: number | null;
  roleCount: number | null;
}

const emptyDashboardData: DashboardData = {
  loading: true,
  employees: null,
  departments: null,
  activeProjects: null,
  openTasks: null,
  inProgressTasks: null,
  completedTasks: null,
  urgentTasks: null,
  totalUsers: null,
  lockedUsers: null,
  privilegedUsers: null,
  roleCount: null,
};

const PRIVILEGED_ROLES = new Set(['ADMIN', 'HR_MANAGER']);

interface DashboardDataPerms {
  employees: boolean;
  departments: boolean;
  projects: boolean;
  tasks: boolean;
  users: boolean;
  roles: boolean;
}

// Chỉ gọi API mà role hiện tại có quyền; endpoint lỗi hoặc thiếu quyền → null (ẩn metric, không bịa số).
const useDashboardData = (perms: DashboardDataPerms): DashboardData => {
  const [data, setData] = useState<DashboardData>(emptyDashboardData);

  useEffect(() => {
    let cancelled = false;

    const fetchAll = async () => {
      const [employees, departments, activeProjects, taskStats, userStats, roleCount] = await Promise.all([
        perms.employees
          ? employeeApi.getAll({ page: 0, size: 1 }).then((r) => r.data.totalElements).catch(() => null)
          : Promise.resolve(null),
        perms.departments
          ? departmentApi.getAll({ page: 0, size: 1 }).then((r) => r.data.totalElements).catch(() => null)
          : Promise.resolve(null),
        perms.projects
          ? projectApi.getAll().then((list) => list.filter((p) => p.status === 'ACTIVE').length).catch(() => null)
          : Promise.resolve(null),
        perms.tasks
          ? taskApi.getAll().then((list) => ({
              open: list.filter((t) => t.status === 'OPEN').length,
              inProgress: list.filter((t) => t.status === 'IN_PROGRESS').length,
              completed: list.filter((t) => t.status === 'COMPLETED').length,
              urgent: list.filter(
                (t) =>
                  (t.priority === 'HIGH' || t.priority === 'URGENT') &&
                  (t.status === 'OPEN' || t.status === 'IN_PROGRESS')
              ).length,
            })).catch(() => null)
          : Promise.resolve(null),
        perms.users
          ? userApi.getAll().then((r) => ({
              total: r.data.length,
              locked: r.data.filter((u) => u.locked).length,
              privileged: r.data.filter((u) => PRIVILEGED_ROLES.has(u.role)).length,
            })).catch(() => null)
          : Promise.resolve(null),
        perms.roles
          ? roleApi.getAll().then((r) => r.data.length).catch(() => null)
          : Promise.resolve(null),
      ]);

      if (cancelled) return;
      setData({
        loading: false,
        employees,
        departments,
        activeProjects,
        openTasks: taskStats?.open ?? null,
        inProgressTasks: taskStats?.inProgress ?? null,
        completedTasks: taskStats?.completed ?? null,
        urgentTasks: taskStats?.urgent ?? null,
        totalUsers: userStats?.total ?? null,
        lockedUsers: userStats?.locked ?? null,
        privilegedUsers: userStats?.privileged ?? null,
        roleCount,
      });
    };

    void fetchAll();
    return () => {
      cancelled = true;
    };
  }, [perms.employees, perms.departments, perms.projects, perms.tasks, perms.users, perms.roles]);

  return data;
};

interface HealthMetric {
  label: string;
  value: number;
  hint: string;
}

// Mỗi role xem một lát cắt số liệu thật khác nhau; metric không có dữ liệu (null) bị ẩn.
const buildHealthMetrics = (role: WorkspaceRole, data: DashboardData): HealthMetric[] => {
  const m = (label: string, value: number | null, hint: string): HealthMetric | null =>
    value === null ? null : { label, value, hint };

  const taskMetrics = [
    m('Task đang thực hiện', data.inProgressTasks, 'Đang trong In Progress'),
    m('Task ưu tiên cao', data.urgentTasks, 'HIGH/URGENT chưa hoàn tất'),
    m('Task hoàn tất', data.completedTasks, 'Tích lũy trên hệ thống'),
  ];

  const byRole: Record<WorkspaceRole, Array<HealthMetric | null>> = {
    user: [],
    employee: taskMetrics,
    manager: taskMetrics,
    departmentHead: taskMetrics,
    payroll: [m('Nhân viên', data.employees, 'Hồ sơ phục vụ đối soát lương')],
    hr: [
      m('Phòng ban', data.departments, 'Đơn vị đang theo dõi'),
      m('Task đang thực hiện', data.inProgressTasks, 'Trên toàn hệ thống'),
      m('Task ưu tiên cao', data.urgentTasks, 'HIGH/URGENT chưa hoàn tất'),
    ],
    admin: [
      m('Tài khoản hệ thống', data.totalUsers, 'Đang quản lý trong auth service'),
      m('Tài khoản bị khóa', data.lockedUsers, 'Khóa do đăng nhập sai hoặc do admin'),
      m('Quyền quản trị cao', data.privilegedUsers, 'Role ADMIN và HR_MANAGER'),
      m('Role đang dùng', data.roleCount, 'Định nghĩa trong hệ thống'),
    ],
  };

  return byRole[role].filter((x): x is HealthMetric => x !== null).slice(0, 4);
};

// Queue tổng hợp từ dữ liệu thật, sắp theo mức khẩn; tối đa 3 mục.
const buildWorkQueue = (data: DashboardData): RoleWorkItem[] => {
  const items: RoleWorkItem[] = [];

  if ((data.lockedUsers ?? 0) > 0) {
    items.push({
      title: `${data.lockedUsers} tài khoản đang bị khóa`,
      description: 'Kiểm tra và mở khóa nếu tài khoản bị khóa nhầm do đăng nhập sai.',
      meta: 'Quản lý tài khoản',
      priority: 'high',
      href: '/users',
    });
  }

  if ((data.urgentTasks ?? 0) > 0) {
    items.push({
      title: `${data.urgentTasks} task ưu tiên cao đang mở`,
      description: 'Task HIGH/URGENT chưa hoàn tất — xử lý hoặc điều phối trước.',
      meta: 'Task',
      priority: 'high',
      href: '/tasks',
    });
  }

  if ((data.inProgressTasks ?? 0) > 0) {
    items.push({
      title: `${data.inProgressTasks} task đang thực hiện`,
      description: 'Theo dõi tiến độ và cập nhật trạng thái khi hoàn tất.',
      meta: 'Task',
      priority: 'medium',
      href: '/tasks',
    });
  }

  if ((data.openTasks ?? 0) > 0) {
    items.push({
      title: `${data.openTasks} task mở chưa bắt đầu`,
      description: 'Nhận việc hoặc giao cho thành viên phù hợp.',
      meta: 'Task',
      priority: 'normal',
      href: '/tasks',
    });
  }

  return items.slice(0, 3);
};

const HeroLiveStats = ({ data, canViewEmployees, canViewProjects, canViewTasks }: {
  data: DashboardData;
  canViewEmployees: boolean;
  canViewProjects: boolean;
  canViewTasks: boolean;
}) => {
  const pendingTasks =
    data.openTasks === null && data.inProgressTasks === null
      ? null
      : (data.openTasks ?? 0) + (data.inProgressTasks ?? 0);

  const items: Array<{ label: string; value: number | null; icon: LucideIcon }> = [];
  if (canViewEmployees) items.push({ label: 'Nhân viên',       value: data.employees,      icon: Users });
  if (canViewProjects)  items.push({ label: 'Dự án đang chạy', value: data.activeProjects, icon: FolderKanban });
  if (canViewTasks)     items.push({ label: 'Task cần xử lý',  value: pendingTasks,        icon: ListChecks });

  const visible = items.filter((item) => data.loading || item.value !== null);
  if (visible.length === 0) return null;

  return (
    <div className="flex flex-wrap gap-3">
      {visible.map((item) => (
        <div
          key={item.label}
          className="flex items-center gap-3 rounded-xl bg-white px-4 py-2.5 shadow-[0_1px_2px_rgba(67,56,202,0.07)] ring-1 ring-indigo-100"
        >
          <item.icon size={16} className="shrink-0 text-indigo-500" />
          <div>
            <p className="text-[11px] font-semibold uppercase tracking-wide text-indigo-400">{item.label}</p>
            <p className="mt-0.5 text-xl font-bold leading-none tabular-nums text-slate-900">
              {data.loading ? '—' : item.value}
            </p>
          </div>
        </div>
      ))}
    </div>
  );
};

const WorkQueueList = ({ items, loading, hasData }: { items: RoleWorkItem[]; loading: boolean; hasData: boolean }) => {
  if (loading) {
    return (
      <div className="space-y-3">
        {[0, 1].map((i) => (
          <div key={i} className="h-20 animate-shimmer rounded-xl bg-slate-100" />
        ))}
      </div>
    );
  }

  // Phân biệt "đã tải, không có việc" với "không tải được nguồn dữ liệu nào".
  if (items.length === 0) {
    return (
      <div className="rounded-xl border border-dashed border-slate-200 bg-slate-50/60 p-6 text-center">
        {hasData ? (
          <>
            <CheckCircle2 size={22} className="mx-auto text-emerald-500" />
            <p className="mt-2 text-sm font-semibold text-slate-700">Không có việc tồn đọng</p>
            <p className="mt-1 text-xs text-slate-400">Mục cần chú ý sẽ xuất hiện khi có dữ liệu mới.</p>
          </>
        ) : (
          <>
            <AlertCircle size={22} className="mx-auto text-slate-400" />
            <p className="mt-2 text-sm font-semibold text-slate-700">Chưa tải được dữ liệu</p>
            <p className="mt-1 text-xs text-slate-400">Backend có thể đang khởi động — tải lại trang sau ít phút.</p>
          </>
        )}
      </div>
    );
  }

  return (
    <div className="divide-y divide-slate-200 overflow-hidden rounded-xl border border-slate-200 bg-white">
      {items.map((item) => {
        const priority = priorityStyles[item.priority];

        return (
          <div key={item.title} className="grid gap-3 p-3 sm:grid-cols-[1fr_auto] sm:items-center">
            <div className="min-w-0">
              <div className="flex flex-wrap items-center gap-2">
                <h3 className="font-semibold text-slate-900">{item.title}</h3>
                <Badge variant={priority.variant}>{priority.label}</Badge>
              </div>
              <p className="mt-1 text-sm leading-6 text-slate-500">{item.description}</p>
              <div className="mt-2 inline-flex items-center gap-2 rounded-md bg-slate-100 px-2 py-1 text-xs font-semibold text-slate-600">
                <Clock3 size={14} />
                {item.meta}
              </div>
            </div>

            <Link
              to={item.href}
              className="inline-flex h-9 items-center justify-center gap-1.5 rounded-md border border-slate-200 bg-white px-3 text-sm font-semibold text-indigo-600 transition hover:border-indigo-200 hover:bg-indigo-50 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
            >
              Mở
              <ArrowRight size={15} />
            </Link>
          </div>
        );
      })}
    </div>
  );
};

const ActionCard = ({
  title,
  description,
  icon: Icon,
  href,
  disabled,
}: {
  title: string;
  description: string;
  icon: LucideIcon;
  href?: string;
  disabled?: boolean;
}) => {
  const content = (
    <div
      className={cn(
        cardShell,
        disabled && 'opacity-60 hover:translate-y-0 hover:border-slate-200/90 hover:shadow-none'
      )}
    >
      <div className="flex h-full flex-col p-4">
        <div className="mb-4 flex items-start justify-between gap-3">
          <div className={iconSquare}>
            <Icon size={20} strokeWidth={2.2} />
          </div>
          {disabled && <Badge variant="muted">Đang khóa</Badge>}
        </div>
        <h3 className="font-semibold text-slate-900">{title}</h3>
        <p className="mt-1.5 flex-1 text-sm leading-6 text-slate-500">{description}</p>
        <div className={cn('mt-4 inline-flex items-center gap-1.5 text-sm font-semibold', disabled ? 'text-slate-400' : 'text-indigo-600')}>
          {disabled ? 'Chưa có quyền' : 'Mở chức năng'}
          {!disabled && <ArrowRight size={15} className="transition-transform duration-150 group-hover:translate-x-0.5" />}
        </div>
      </div>
    </div>
  );

  if (!href || disabled) {
    return <div>{content}</div>;
  }

  return (
    <Link to={href} className="block rounded-2xl focus:outline-none focus:ring-2 focus:ring-indigo-500/40">
      {content}
    </Link>
  );
};

const PendingApprovalPanel = ({
  user,
  onCopyEmail,
}: {
  user: ReturnType<typeof useAuthStore.getState>['user'];
  onCopyEmail: (email: string) => void;
}) => {
  const userRecord = (user || {}) as Record<string, unknown>;
  const firstString = (...values: unknown[]): string | undefined =>
    values.find((v): v is string => typeof v === 'string');

  const createdAt = firstString(userRecord.createdAt, userRecord.registeredAt) ?? new Date().toISOString();
  const groupName = firstString(userRecord.departmentName, userRecord.requestedGroup) ?? 'Nhóm: Phát triển phần mềm';
  const approverName = firstString(userRecord.approverName) ?? 'Quản trị viên hệ thống';
  const approverEmail = firstString(userRecord.approverEmail) ?? 'admin@company.com';

  const pendingCards = [
    {
      title: 'Trạng thái tài khoản',
      body: 'Hồ sơ của bạn đã được ghi nhận và đang chờ kiểm tra quyền truy cập.',
      className: 'border-dashed border-orange-200 bg-[#FFF7ED] text-[#C2410C]',
      iconClass: 'bg-orange-100 text-[#C2410C] ring-orange-200',
      icon: Hourglass,
      content: (
        <>
          <div className="mt-4 inline-flex rounded-full bg-orange-100 px-3 py-1 text-sm font-bold text-[#C2410C] ring-1 ring-orange-200">
            Đang chờ phê duyệt
          </div>
          <dl className="mt-5 grid gap-3 text-sm">
            <div>
              <dt className="font-semibold text-orange-900">Ngày tạo tài khoản</dt>
              <dd className="mt-1 text-orange-800">{formatDate(createdAt, 'dd/MM/yyyy')}</dd>
            </div>
            <div>
              <dt className="font-semibold text-orange-900">Dự kiến xử lý</dt>
              <dd className="mt-1 text-orange-800">Trong 1-2 ngày làm việc</dd>
            </div>
          </dl>
        </>
      ),
    },
    {
      title: 'Nhóm đăng ký tham gia',
      body: 'Nhóm/phòng ban được dùng để xác định leader hoặc admin chịu trách nhiệm duyệt.',
      className: 'border-blue-100 bg-blue-50 text-blue-900',
      iconClass: 'bg-blue-100 text-blue-700 ring-blue-200',
      icon: FolderTree,
      content: (
        <div className="mt-5 rounded-xl border border-blue-100 bg-white/75 p-4">
          <div className="flex items-center gap-3">
            <div className="h-2 w-2 rounded-full bg-blue-500" />
            <p className="font-bold text-blue-950">{groupName}</p>
          </div>
          <div className="ml-1 mt-3 border-l border-blue-200 pl-5 text-sm leading-6 text-blue-700">
            Công ty / Khối kỹ thuật / {groupName.replace(/^Nhóm:\s*/i, '')}
          </div>
        </div>
      ),
    },
    {
      title: 'Người phê duyệt',
      body: 'Liên hệ người phụ trách nếu thông tin nhóm hoặc email đăng ký chưa chính xác.',
      className: 'border-slate-200 bg-white text-slate-900',
      iconClass: 'bg-slate-100 text-slate-700 ring-slate-200',
      icon: Mail,
      content: (
        <div className="mt-5 flex items-center justify-between gap-3 rounded-xl border border-slate-200 bg-slate-50 p-4">
          <div className="min-w-0">
            <p className="truncate font-bold text-slate-950">{approverName}</p>
            <p className="mt-1 truncate text-sm text-slate-500">{approverEmail}</p>
          </div>
          <button
            type="button"
            onClick={() => onCopyEmail(approverEmail)}
            className="inline-flex h-10 w-10 shrink-0 items-center justify-center rounded-lg border border-slate-200 bg-white text-slate-700 transition hover:bg-slate-100"
            aria-label="Copy email người phê duyệt"
          >
            <Copy size={18} />
          </button>
        </div>
      ),
    },
  ];

  return (
    <section className="grid grid-cols-1 gap-4 lg:grid-cols-3">
      {pendingCards.map((card) => (
        <div key={card.title} className={cn('card-hover rounded-2xl border p-5 shadow-sm', card.className)}>
          <div className="flex items-start justify-between gap-4">
            <div className="min-w-0">
              <h2 className="text-lg font-bold">{card.title}</h2>
              <p className="mt-2 text-sm leading-6 text-slate-500">{card.body}</p>
            </div>
            <div className={cn('flex h-12 w-12 shrink-0 items-center justify-center rounded-2xl ring-1', card.iconClass)}>
              <card.icon size={24} className={card.icon === Hourglass ? 'animate-pulse' : undefined} />
            </div>
          </div>
          {card.content}
        </div>
      ))}
    </section>
  );
};

export const DashboardPage = () => {
  const { user } = useAuthStore();
  const { addNotification } = useUIStore();
  const { can } = usePermissions();
  const [passwordWarning, setPasswordWarning] = useState<string | null>(null);

  const workspaceRole = resolveWorkspaceRole(user?.roles);
  const roleProfile = roleProfiles[workspaceRole];
  const experience = dashboardExperience[workspaceRole];
  const isPendingUser = workspaceRole === 'user';

  const canViewEmployees = can(PERMISSIONS.EMPLOYEE_VIEW);
  const canViewProjects  = can(PERMISSIONS.PROJECT_VIEW);
  const canViewTasks     = can(PERMISSIONS.TASK_VIEW);
  const dashboardData = useDashboardData({
    employees: canViewEmployees,
    departments: can(PERMISSIONS.DEPARTMENT_VIEW),
    projects: canViewProjects,
    tasks: canViewTasks,
    users: can(PERMISSIONS.USER_VIEW),
    roles: can(PERMISSIONS.ROLE_VIEW),
  });
  const healthMetrics = useMemo(
    () => buildHealthMetrics(workspaceRole, dashboardData),
    [workspaceRole, dashboardData]
  );
  const workQueue = useMemo(() => buildWorkQueue(dashboardData), [dashboardData]);

  const visibleActions = useMemo(
    () => roleProfile.actions.filter((action) => !action.permission || can(action.permission)),
    [can, roleProfile.actions]
  );

  useEffect(() => {
    if (user?.passwordExpiresAt) {
      setPasswordWarning(getPasswordExpiryWarning(user.passwordExpiresAt));
      return;
    }

    setPasswordWarning(null);
  }, [user]);

  const handleCopyApproverEmail = async (email: string) => {
    try {
      await navigator.clipboard.writeText(email);
      addNotification({ type: 'success', message: 'Đã copy email người phê duyệt.' });
    } catch {
      addNotification({ type: 'error', message: 'Không thể copy email. Vui lòng thử lại.' });
    }
  };

  return (
    <MainLayout>
      <div className="space-y-6">
        {!isPendingUser && (
          <section className="relative overflow-hidden rounded-[20px] bg-gradient-to-br from-blue-50 via-indigo-100 to-white shadow-[0_1px_1px_rgba(67,56,202,0.05),0_18px_34px_-12px_rgba(67,56,202,0.20)]">
          <div className="relative grid gap-6 p-6 lg:grid-cols-[1fr_360px] lg:p-8">
            <div className="flex min-w-0 flex-col">
              <div>
                <div className="mb-4 inline-flex items-center gap-2 rounded-full bg-white px-3 py-1 text-sm font-semibold text-indigo-700 shadow-sm ring-1 ring-indigo-100">
                  <Sparkles size={16} />
                  {roleProfile.badge}
                </div>
                <h2 className="text-2xl font-semibold tracking-[-0.02em] text-balance text-slate-900 sm:text-3xl">{roleProfile.headline}</h2>
                <p className="mt-2 max-w-3xl text-sm leading-6 text-indigo-700 sm:text-base">
                  Chào mừng trở lại, {user?.fullName || user?.username || 'bạn'}. {roleProfile.description}
                </p>
              </div>

              {(canViewEmployees || canViewProjects || canViewTasks) && (
                <div className="mt-auto pt-6">
                  <HeroLiveStats
                    data={dashboardData}
                    canViewEmployees={canViewEmployees}
                    canViewProjects={canViewProjects}
                    canViewTasks={canViewTasks}
                  />
                </div>
              )}
            </div>

            <div className="rounded-2xl bg-white p-5 shadow-[0_1px_2px_rgba(67,56,202,0.07)] ring-1 ring-indigo-100">
              <p className="text-xs font-semibold uppercase tracking-wide text-indigo-500">{experience.summaryTitle}</p>
              <p className="mt-1.5 text-sm leading-6 text-slate-500">{experience.operatingModel}</p>
              {healthMetrics.length > 0 && (
                <dl className="mt-4 divide-y divide-slate-100">
                  {healthMetrics.map((metric) => (
                    <div key={metric.label} className="flex items-baseline justify-between gap-4 py-2.5 first:pt-0 last:pb-0 animate-fade-up">
                      <div className="min-w-0">
                        <dt className="text-sm font-medium text-slate-700">{metric.label}</dt>
                        <dd className="mt-0.5 text-xs leading-5 text-slate-400">{metric.hint}</dd>
                      </div>
                      <dd className="shrink-0 text-lg font-bold tabular-nums text-indigo-950">{metric.value}</dd>
                    </div>
                  ))}
                </dl>
              )}
            </div>
          </div>
        </section>
        )}

        {passwordWarning && (
          <div className="rounded-lg border border-amber-200 bg-amber-50 p-4 shadow-sm">
            <div className="flex items-start gap-3">
              <AlertCircle className="mt-0.5 shrink-0 text-amber-600" size={20} />
              <p className="text-sm text-amber-800">{passwordWarning}</p>
            </div>
          </div>
        )}

        {isPendingUser && <PendingApprovalPanel user={user} onCopyEmail={handleCopyApproverEmail} />}

        {!isPendingUser && (
        <section className="grid grid-cols-1 gap-4 md:grid-cols-3">
          {roleProfile.statCards.map((card) => (
            <div key={card.label} className={cardShell}>
              <div className="flex h-full flex-col p-5">
                <div className="flex items-start justify-between gap-4">
                  <div className="min-w-0">
                    <p className="text-xs font-semibold uppercase tracking-wide text-slate-400">{card.label}</p>
                    <p className="mt-1.5 text-xl font-bold text-slate-900">{card.value}</p>
                  </div>
                  <div className={iconSquare}>
                    <card.icon size={20} strokeWidth={2.2} />
                  </div>
                </div>
                <p className="mt-3 text-sm leading-6 text-slate-500">{card.hint}</p>
              </div>
            </div>
          ))}
        </section>
        )}

        {!isPendingUser && (
        <section className="grid items-start gap-6 xl:grid-cols-[1fr_360px]">
          <Card>
            <CardHeader>
              <CardTitle>Chức năng theo vai trò</CardTitle>
              <CardDescription>Chỉ hiển thị những thao tác phù hợp với role và quyền hiện tại.</CardDescription>
            </CardHeader>
            <CardContent>
              <div className="grid gap-3 md:grid-cols-2 xl:grid-cols-3">
                {visibleActions.map((action) => (
                  <ActionCard
                    key={action.title}
                    title={action.title}
                    description={action.description}
                    icon={action.icon}
                    href={action.href}
                    disabled={action.status === 'soon'}
                  />
                ))}
              </div>
            </CardContent>
          </Card>

          <div className="space-y-6">
            <Card>
              <CardHeader>
                <CardTitle>Việc cần chú ý</CardTitle>
                <CardDescription>Tổng hợp trực tiếp từ dữ liệu hệ thống theo quyền của bạn.</CardDescription>
              </CardHeader>
              <CardContent>
                <WorkQueueList
                  items={workQueue}
                  loading={dashboardData.loading}
                  hasData={[dashboardData.urgentTasks, dashboardData.inProgressTasks, dashboardData.openTasks, dashboardData.lockedUsers].some(
                    (v) => v !== null
                  )}
                />
              </CardContent>
            </Card>

            <Card>
              <CardHeader>
                <CardTitle>Phạm vi truy cập</CardTitle>
                <CardDescription>Vai trò hiện tại: {roleProfile.label}</CardDescription>
              </CardHeader>
              <CardContent>
                <div className="space-y-2">
                  {experience.accessNotes.map((note) => (
                    <div key={note} className="flex gap-2 text-sm text-slate-600">
                      <ShieldCheck size={17} className="mt-0.5 shrink-0 text-indigo-500" />
                      <span>{note}</span>
                    </div>
                  ))}
                </div>

                <div className="mt-5 flex flex-wrap gap-2">
                  {(user?.roles || []).map((role) => (
                    <Badge key={role} variant="info">
                      {role}
                    </Badge>
                  ))}
                  {(!user?.roles || user.roles.length === 0) && <Badge variant="muted">Chưa có role từ token</Badge>}
                </div>
              </CardContent>
            </Card>
          </div>
        </section>
        )}
      </div>
    </MainLayout>
  );
};
