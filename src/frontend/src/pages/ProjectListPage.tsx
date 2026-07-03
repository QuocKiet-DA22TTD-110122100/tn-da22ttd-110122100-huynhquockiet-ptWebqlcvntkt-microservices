import { useEffect, useMemo, useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import {
  Activity, BarChart3, CalendarDays, Edit,
  FolderKanban, Plus, Target, Trash2, TrendingUp, Users,
} from 'lucide-react';
import { projectApi } from '@/api/project.api';
import { taskApi } from '@/api/task.api';
import { Badge } from '@/components/UI/Badge';
import { Button } from '@/components/UI/Button';
import { Card } from '@/components/UI/Card';
import { ConfirmModal } from '@/components/UI/ConfirmModal';
import { TablePagination } from '@/components/UI/DataListPage';
import { Input } from '@/components/UI/Input';
import { MainLayout } from '@/components/Layout/MainLayout';
import { usePermissions } from '@/hooks/usePermissions';
import { useUIStore } from '@/store/uiStore';
import { Project, ProjectStatus } from '@/types/project';
import { Task } from '@/types/task';
import { PERMISSIONS } from '@/utils/permissions';
import { cn } from '@/utils/cn';

/* ─── types ──────────────────────────────────────────────────── */

interface ProjectRow extends Project {
  memberCount: number;
  taskCount: number;
  completedTaskCount: number;
}

/* ─── label / colour maps ────────────────────────────────────── */

const statusLabels: Record<ProjectStatus, string> = {
  ACTIVE: 'Đang chạy', PAUSED: 'Tạm dừng', COMPLETED: 'Hoàn tất', ARCHIVED: 'Lưu trữ',
};
const statusVariants: Record<ProjectStatus, 'success' | 'warning' | 'info' | 'muted'> = {
  ACTIVE: 'success', PAUSED: 'warning', COMPLETED: 'info', ARCHIVED: 'muted',
};

const formatDate = (v?: string | null) => v ? new Date(v).toLocaleDateString('vi-VN') : '--';

const pageSizeOptions = [10, 20, 50];

/* ─── SVG Vertical Bar Chart ─────────────────────────────────── */

interface BarDatum { label: string; value: number; color: string; sublabel?: string }
interface LineDatum { label: string; value: number }
interface HorizontalDatum { label: string; value: number; sub?: string; color?: string }

const chartGrid = [0, 0.25, 0.5, 0.75, 1];

const ChartHeader = ({ icon: Icon, title, subtitle }: {
  icon: typeof BarChart3;
  title: string;
  subtitle?: string;
}) => (
  <div className="flex items-start justify-between gap-3">
    <div>
      <p className="text-sm font-semibold text-slate-950">{title}</p>
      {subtitle && <p className="mt-1 text-xs leading-5 text-slate-500">{subtitle}</p>}
    </div>
    <div className="grid h-9 w-9 shrink-0 place-items-center rounded-lg bg-blue-50 text-blue-700">
      <Icon size={17} />
    </div>
  </div>
);

const VBarChart = ({ data, title, subtitle }: { data: BarDatum[]; title: string; subtitle?: string }) => {
  const W = 360; const H = 178; const PB = 32; const PT = 16; const PL = 30; const PR = 8;
  const innerW = W - PL - PR;
  const innerH = H - PB - PT;
  const max = Math.max(...data.map(d => d.value), 1);
  const barW = innerW / Math.max(data.length, 1);
  const barGap = Math.max(10, Math.floor(barW * 0.34));

  return (
    <div className="space-y-4">
      <ChartHeader icon={BarChart3} title={title} subtitle={subtitle} />
      <svg viewBox={`0 0 ${W} ${H}`} className="h-[178px] w-full" role="img" aria-label={title}>
        {chartGrid.map(t => {
          const y = PT + innerH * (1 - t);
          return (
            <g key={t}>
              <line x1={PL} y1={y} x2={W - PR} y2={y} stroke="#e8eef5" strokeWidth="1" />
              {t > 0 && (
                <text x={PL - 7} y={y + 3} textAnchor="end" fontSize="8" fill="#64748b">
                  {Math.round(max * t)}
                </text>
              )}
            </g>
          );
        })}
        {data.map((d, i) => {
          const bh = Math.max(2, (d.value / max) * innerH);
          const bx = PL + i * barW + barGap / 2;
          const bw = Math.max(12, barW - barGap);
          const by = PT + innerH - bh;
          return (
            <g key={d.label}>
              <rect x={bx} y={PT} width={bw} height={innerH} rx="7" fill="#f1f5f9" />
              <rect x={bx} y={by} width={bw} height={bh} rx="7" fill={d.color} />
              <text x={bx + bw / 2} y={Math.max(11, by - 5)} textAnchor="middle" fontSize="8" fontWeight="700" fill="#334155">
                {d.value}
              </text>
              <text x={bx + bw / 2} y={H - 9} textAnchor="middle" fontSize="8" fontWeight="600" fill="#64748b">
                {d.sublabel ?? d.label}
              </text>
            </g>
          );
        })}
      </svg>
    </div>
  );
};

const LineAreaChart = ({ data, title, subtitle, color = '#2563eb', suffix = '%' }: {
  data: LineDatum[];
  title: string;
  subtitle?: string;
  color?: string;
  suffix?: string;
}) => {
  const W = 360; const H = 178; const PB = 32; const PT = 18; const PL = 30; const PR = 10;
  const innerW = W - PL - PR;
  const innerH = H - PB - PT;
  const max = Math.max(...data.map(d => d.value), suffix === '%' ? 100 : 1);
  const pts = data.map((d, i) => ({
    x: PL + (i / Math.max(data.length - 1, 1)) * innerW,
    y: PT + innerH * (1 - d.value / max),
    ...d,
  }));
  const linePath = pts.map((p, i) => `${i === 0 ? 'M' : 'L'}${p.x},${p.y}`).join(' ');
  const areaPath = pts.length > 0
    ? `${linePath} L${pts[pts.length - 1].x},${PT + innerH} L${pts[0].x},${PT + innerH} Z`
    : '';

  return (
    <div className="space-y-4">
      <ChartHeader icon={TrendingUp} title={title} subtitle={subtitle} />
      {data.length === 0 ? (
        <div className="grid h-[178px] place-items-center rounded-lg bg-slate-50 text-xs text-slate-500">
          Chưa có dữ liệu để vẽ biểu đồ
        </div>
      ) : (
        <svg viewBox={`0 0 ${W} ${H}`} className="h-[178px] w-full" role="img" aria-label={title}>
          {chartGrid.map(t => {
            const y = PT + innerH * (1 - t);
            return <line key={t} x1={PL} y1={y} x2={W - PR} y2={y} stroke="#e8eef5" strokeWidth="1" />;
          })}
          {areaPath && <path d={areaPath} fill={color} fillOpacity="0.12" />}
          {linePath && <path d={linePath} fill="none" stroke={color} strokeWidth="2.5" strokeLinejoin="round" strokeLinecap="round" />}
          {pts.map(p => (
            <g key={p.label}>
              <circle cx={p.x} cy={p.y} r="4" fill="white" stroke={color} strokeWidth="2" />
              <text x={p.x} y={Math.max(10, p.y - 8)} textAnchor="middle" fontSize="8" fontWeight="700" fill="#334155">
                {p.value}{suffix}
              </text>
              <text x={p.x} y={H - 9} textAnchor="middle" fontSize="7.5" fontWeight="600" fill="#64748b">
                {p.label.length > 9 ? `${p.label.slice(0, 8)}...` : p.label}
              </text>
            </g>
          ))}
        </svg>
      )}
    </div>
  );
};

const HorizBarList = ({ data, title, subtitle }: {
  data: HorizontalDatum[];
  title: string;
  subtitle?: string;
}) => {
  const max = Math.max(...data.map(d => d.value), 1);
  return (
    <div className="space-y-4">
      <ChartHeader icon={Users} title={title} subtitle={subtitle} />
      <div className="space-y-3">
        {data.map(d => (
          <div key={d.label} className="space-y-1.5">
            <div className="flex items-center justify-between gap-3">
              <span className="truncate text-xs font-semibold text-slate-700" title={d.label}>{d.label}</span>
              <span className="shrink-0 text-xs font-bold tabular-nums text-slate-600">
                {d.value}{d.sub ? ` ${d.sub}` : ''}
              </span>
            </div>
            <div className="h-2 w-full overflow-hidden rounded-full bg-slate-100">
              <div
                className="h-full rounded-full transition-[width] duration-700 ease-out"
                style={{ width: `${(d.value / max) * 100}%`, backgroundColor: d.color ?? '#2563eb' }}
              />
            </div>
          </div>
        ))}
        {data.length === 0 && (
          <div className="grid h-[178px] place-items-center rounded-lg bg-slate-50 text-xs text-slate-500">
            Chưa có dữ liệu phân công
          </div>
        )}
      </div>
    </div>
  );
};

/* ─── Main page ──────────────────────────────────────────────── */

export const ProjectListPage = () => {
  const navigate = useNavigate();
  const { can } = usePermissions();
  const { addNotification } = useUIStore();
  const canCreateProject = can(PERMISSIONS.PROJECT_CREATE);
  const canUpdateProject = can(PERMISSIONS.PROJECT_UPDATE);
  const canDeleteProject = can(PERMISSIONS.PROJECT_DELETE);

  const [projects, setProjects] = useState<ProjectRow[]>([]);
  const [allTasks, setAllTasks] = useState<Task[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [confirmTarget, setConfirmTarget] = useState<ProjectRow | null>(null);
  const [deletingId, setDeletingId] = useState<number | null>(null);
  const [search, setSearch] = useState('');
  const [statusFilter, setStatusFilter] = useState<'ALL' | ProjectStatus>('ALL');
  const [page, setPage] = useState(1);
  const [pageSize, setPageSize] = useState(10);

  const loadProjects = async () => {
    setLoading(true);
    setError(null);
    try {
      const [projectList, tasks] = await Promise.all([
        projectApi.getAll(),
        taskApi.getAll().catch(() => [] as Task[]),
      ]);

      setAllTasks(tasks);

      const taskCountMap = tasks.reduce<Record<number, number>>((acc, t) => {
        acc[t.projectId] = (acc[t.projectId] ?? 0) + 1;
        return acc;
      }, {});

      const completedTaskMap = tasks.reduce<Record<number, number>>((acc, t) => {
        if (t.status === 'COMPLETED') acc[t.projectId] = (acc[t.projectId] ?? 0) + 1;
        return acc;
      }, {});

      const memberCounts = await Promise.all(
        projectList.map((p) =>
          projectApi.getAssignments(p.id)
            .then((list) => list.filter((a) => a.active).length)
            .catch(() => 0)
        )
      );

      setProjects(
        projectList.map((p, i) => ({
          ...p,
          memberCount: memberCounts[i],
          taskCount: taskCountMap[p.id] ?? 0,
          completedTaskCount: completedTaskMap[p.id] ?? 0,
        }))
      );
    } catch {
      setError('Không thể tải danh sách dự án.');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => { void loadProjects(); }, []);
  useEffect(() => { setPage(1); }, [search, statusFilter, pageSize]);

  const handleDeleteConfirm = async () => {
    if (!confirmTarget) return;
    setDeletingId(confirmTarget.id);
    try {
      await projectApi.remove(confirmTarget.id);
      setConfirmTarget(null);
      addNotification({ type: 'success', message: `Đã xóa dự án "${confirmTarget.name}".` });
      await loadProjects();
    } catch {
      addNotification({ type: 'error', message: 'Không thể xóa dự án. Vui lòng thử lại.' });
    } finally {
      setDeletingId(null);
    }
  };

  /* ── chart data ── */

  const taskStatusChartData = useMemo<BarDatum[]>(() => [
    { label: 'Mở', sublabel: 'Mở', value: allTasks.filter(t => t.status === 'OPEN').length, color: '#2563eb' },
    { label: 'Đang làm', sublabel: 'Làm', value: allTasks.filter(t => t.status === 'IN_PROGRESS').length, color: '#f59e0b' },
    { label: 'Hoàn tất', sublabel: 'Xong', value: allTasks.filter(t => t.status === 'COMPLETED').length, color: '#10b981' },
    { label: 'Đã hủy', sublabel: 'Hủy', value: allTasks.filter(t => t.status === 'CANCELLED').length, color: '#94a3b8' },
  ], [allTasks]);

  const projectStatusChartData = useMemo<BarDatum[]>(() => [
    { label: 'Đang chạy', sublabel: 'Chạy', value: projects.filter(p => p.status === 'ACTIVE').length, color: '#2563eb' },
    { label: 'Tạm dừng', sublabel: 'Dừng', value: projects.filter(p => p.status === 'PAUSED').length, color: '#f59e0b' },
    { label: 'Hoàn tất', sublabel: 'Xong', value: projects.filter(p => p.status === 'COMPLETED').length, color: '#10b981' },
    { label: 'Lưu trữ', sublabel: 'Lưu', value: projects.filter(p => p.status === 'ARCHIVED').length, color: '#64748b' },
  ], [projects]);

  const completionChartData = useMemo<LineDatum[]>(() =>
    projects
      .filter(p => p.taskCount > 0)
      .slice(0, 8)
      .map(p => ({
        label: p.name.length > 10 ? p.name.slice(0, 9) + '…' : p.name,
        value: Math.round((p.completedTaskCount / p.taskCount) * 100),
      })),
    [projects]
  );

  const memberChartData = useMemo(() =>
    [...projects]
      .sort((a, b) => b.memberCount - a.memberCount)
      .slice(0, 6)
      .map((p, index) => ({
        label: p.name,
        value: p.memberCount,
        sub: 'TV',
        color: ['#2563eb', '#0891b2', '#10b981', '#f59e0b', '#8b5cf6', '#64748b'][index],
      })),
    [projects]
  );

  /* ── stat cards ── */

  const totalTasks = allTasks.length;
  const completedTasks = allTasks.filter(t => t.status === 'COMPLETED').length;
  const openTasks = allTasks.filter(t => t.status === 'OPEN' || t.status === 'IN_PROGRESS').length;
  const totalMembers = projects.reduce((s, p) => s + p.memberCount, 0);
  const completionRate = totalTasks > 0 ? Math.round((completedTasks / totalTasks) * 100) : 0;

  const projectStats = useMemo(() => [
    {
      label: 'Tổng dự án',
      value: projects.length,
      detail: `${projects.filter(p => p.status === 'ACTIVE').length} đang chạy`,
      icon: FolderKanban,
      text: 'text-blue-700',
      bg: 'bg-blue-50',
    },
    {
      label: 'Task cần xử lý',
      value: openTasks,
      detail: `${totalTasks} task toàn hệ thống`,
      icon: Activity,
      text: 'text-amber-700',
      bg: 'bg-amber-50',
    },
    {
      label: 'Tỷ lệ hoàn thành',
      value: `${completionRate}%`,
      detail: `${completedTasks}/${totalTasks} task đã xong`,
      icon: Target,
      text: 'text-emerald-700',
      bg: 'bg-emerald-50',
    },
    {
      label: 'Tổng thành viên',
      value: totalMembers,
      detail: 'đang được phân công',
      icon: Users,
      text: 'text-slate-700',
      bg: 'bg-slate-100',
    },
  ], [completedTasks, completionRate, openTasks, projects, totalMembers, totalTasks]);

  /* ── filter + table ── */

  const filteredProjects = useMemo(() => {
    const q = search.trim().toLowerCase();
    return projects.filter(p => {
      const matchSearch = !q || p.name.toLowerCase().includes(q) || String(p.leadId).includes(q);
      const matchStatus = statusFilter === 'ALL' || p.status === statusFilter;
      return matchSearch && matchStatus;
    });
  }, [projects, search, statusFilter]);

  const totalPages = Math.max(1, Math.ceil(filteredProjects.length / pageSize));
  const pagedProjects = filteredProjects.slice((page - 1) * pageSize, page * pageSize);

  return (
    <MainLayout>
      <div className="space-y-5">

        {/* ── Hero header ──────────────────────────────────────────────── */}
        <div className="relative overflow-hidden rounded-2xl bg-gradient-to-br from-sky-800 via-cyan-900 to-slate-950 px-6 py-7 shadow-xl">
          <div className="pointer-events-none absolute -right-16 -top-16 h-48 w-48 rounded-full bg-sky-400/10 blur-3xl" />
          <div className="pointer-events-none absolute bottom-0 left-1/4 h-32 w-32 rounded-full bg-cyan-400/10 blur-2xl" />

          <div className="relative flex flex-col gap-5 sm:flex-row sm:items-center sm:justify-between">
            <div className="flex items-center gap-4">
              <div className="flex h-11 w-11 items-center justify-center rounded-xl bg-sky-400/20 ring-1 ring-sky-300/30">
                <FolderKanban size={22} className="text-sky-200" />
              </div>
              <div>
                <h1 className="text-xl font-bold text-white">Quản lý dự án</h1>
                <p className="mt-0.5 text-sm text-sky-300">Theo dõi tiến độ, phân công và biểu đồ tổng quan toàn bộ dự án</p>
              </div>
            </div>

            <div className="flex flex-wrap items-center gap-3">
              {[
                { label: 'Tổng dự án',  value: projects.length,                                        icon: FolderKanban, color: 'text-sky-300' },
                { label: 'Đang chạy',   value: projects.filter((p) => p.status === 'ACTIVE').length,    icon: TrendingUp,   color: 'text-emerald-300' },
                { label: 'Task cần xử lý', value: openTasks,                                            icon: Activity,     color: 'text-amber-300' },
              ].map(({ label, value, icon: Icon, color }) => (
                <div key={label} className="flex items-center gap-2.5 rounded-xl bg-white/5 px-4 py-2.5 ring-1 ring-white/10">
                  <Icon size={16} className={color} />
                  <div>
                    <div className="text-xs text-sky-300/80">{label}</div>
                    <div className="text-base font-bold leading-none text-white mt-0.5">{value}</div>
                  </div>
                </div>
              ))}

              {canCreateProject && (
                <Link to="/projects/add">
                  <Button size="sm" className="gap-1.5">
                    <Plus size={16} />
                    Tạo dự án
                  </Button>
                </Link>
              )}
            </div>
          </div>
        </div>

        {/* Stats */}
        <section className="grid grid-cols-1 gap-3 sm:grid-cols-2 xl:grid-cols-4">
          {projectStats.map((stat, i) => (
            <Card key={stat.label} className="relative overflow-hidden p-5 animate-fade-up" style={{ animationDelay: `${i * 60}ms` }}>
              <div className="flex items-start justify-between gap-3">
                <div className="min-w-0">
                  <p className="truncate text-sm font-semibold text-slate-600">{stat.label}</p>
                  <p className="mt-1 font-display text-3xl font-bold tabular-nums tracking-tight text-slate-950">
                    {loading ? '—' : stat.value}
                  </p>
                  <p className="mt-2 truncate text-xs font-medium text-slate-500">{stat.detail}</p>
                </div>
                <div className={`flex h-10 w-10 shrink-0 items-center justify-center rounded-lg ${stat.bg} ${stat.text}`}>
                  <stat.icon size={20} />
                </div>
              </div>
            </Card>
          ))}
        </section>

        {/* Charts */}
        <div className="grid gap-4 lg:grid-cols-2 xl:grid-cols-4">
          <Card className="p-5">
            {loading ? (
              <div className="h-[230px] animate-shimmer rounded-lg bg-slate-100" />
            ) : (
              <VBarChart
                data={projectStatusChartData}
                title="Trạng thái dự án"
                subtitle={`${projects.length} dự án đang được quản lý`}
              />
            )}
          </Card>

          <Card className="p-5">
            {loading ? (
              <div className="h-[230px] animate-shimmer rounded-lg bg-slate-100" />
            ) : (
              <VBarChart
                data={taskStatusChartData}
                title="Khối lượng task"
                subtitle={`Tổng ${allTasks.length} task toàn hệ thống`}
              />
            )}
          </Card>

          <Card className="p-5 lg:col-span-2 xl:col-span-1">
            {loading ? (
              <div className="h-[230px] animate-shimmer rounded-lg bg-slate-100" />
            ) : (
              <LineAreaChart
                data={completionChartData}
                title="Tiến độ hoàn thành"
                subtitle="Top dự án có task, tính theo % hoàn tất"
                color="#10b981"
              />
            )}
          </Card>

          <Card className="p-5">
            {loading ? (
              <div className="h-[230px] animate-shimmer rounded-lg bg-slate-100" />
            ) : (
              <HorizBarList
                data={memberChartData}
                title="Phân công nhân sự"
                subtitle="Top dự án theo số thành viên active"
              />
            )}
          </Card>
        </div>

        {/* Filters */}
        <Card className="overflow-hidden">
          <div className="h-1 bg-blue-700" />
          <div className="grid gap-4 p-5 md:grid-cols-[minmax(0,1fr)_200px]">
            <Input
              label="Tìm kiếm"
              placeholder="Tên dự án hoặc lead ID..."
              value={search}
              onChange={(e) => setSearch(e.target.value)}
            />
            <div>
              <label htmlFor="status-filter" className="mb-1 block text-sm font-medium text-slate-700">
                Trạng thái
              </label>
              <select
                id="status-filter"
                value={statusFilter}
                onChange={(e) => setStatusFilter(e.target.value as 'ALL' | ProjectStatus)}
                className="h-10 w-full rounded-md border border-slate-300 bg-white px-3 text-sm focus:outline-none focus:ring-2 focus:ring-cyan-500"
              >
                <option value="ALL">Tất cả</option>
                {(Object.entries(statusLabels) as [ProjectStatus, string][]).map(([v, l]) => (
                  <option key={v} value={v}>{l}</option>
                ))}
              </select>
            </div>
          </div>
        </Card>

        {/* Project table */}
        <Card className="overflow-hidden">
          {loading ? (
            <div className="space-y-3 p-5">
              {Array.from({ length: 5 }).map((_, i) => (
                <div key={i} className="h-12 animate-shimmer rounded-lg bg-slate-100" />
              ))}
            </div>
          ) : error ? (
            <div className="flex flex-col items-center gap-3 py-16 text-center">
              <p className="text-sm text-rose-600">{error}</p>
              <Button variant="outline" size="sm" onClick={() => void loadProjects()}>Thử lại</Button>
            </div>
          ) : pagedProjects.length === 0 ? (
            <div className="flex flex-col items-center gap-2 py-16 text-center">
              <FolderKanban size={40} className="text-slate-300" />
              <p className="text-sm text-slate-600">Không có dự án nào phù hợp.</p>
            </div>
          ) : (
            <div className="overflow-x-auto">
              <table className="w-full text-sm">
                <thead>
                  <tr className="border-b border-slate-100 bg-slate-50">
                    <th className="px-4 py-3 text-left text-xs font-semibold uppercase tracking-wide text-slate-500">Dự án</th>
                    <th className="px-4 py-3 text-left text-xs font-semibold uppercase tracking-wide text-slate-500">Trạng thái</th>
                    <th className="px-4 py-3 text-center text-xs font-semibold uppercase tracking-wide text-slate-500">Thành viên</th>
                    <th className="px-4 py-3 text-center text-xs font-semibold uppercase tracking-wide text-slate-500">Task</th>
                    <th className="px-4 py-3 text-center text-xs font-semibold uppercase tracking-wide text-slate-500">Hoàn thành</th>
                    <th className="px-4 py-3 text-left text-xs font-semibold uppercase tracking-wide text-slate-500">Ngày tạo</th>
                    <th className="px-4 py-3 text-left text-xs font-semibold uppercase tracking-wide text-slate-500">Lead</th>
                    <th className="px-4 py-3" />
                  </tr>
                </thead>
                <tbody className="divide-y divide-slate-100">
                  {pagedProjects.map((project, idx) => {
                    const pct = project.taskCount > 0
                      ? Math.round((project.completedTaskCount / project.taskCount) * 100)
                      : null;
                    return (
                      <tr
                        key={project.id}
                        className={cn('group animate-fade-up cursor-pointer transition-colors duration-100 hover:bg-slate-50')}
                        style={{ animationDelay: `${Math.min(idx * 35, 350)}ms` }}
                        onClick={() => navigate(`/projects/${project.id}`)}
                      >
                        {/* Name + description */}
                        <td className="px-4 py-3">
                          <p className="font-semibold text-slate-900 group-hover:text-cyan-700 transition-colors">
                            {project.name}
                          </p>
                          <p className="mt-0.5 text-xs text-slate-400 line-clamp-1">
                            {project.description || 'Chưa có mô tả'}
                          </p>
                        </td>

                        {/* Status */}
                        <td className="px-4 py-3">
                          <Badge variant={statusVariants[project.status]}>
                            {statusLabels[project.status]}
                          </Badge>
                        </td>

                        {/* Members */}
                        <td className="px-4 py-3 text-center">
                          <span className="inline-flex items-center gap-1 rounded-full bg-slate-100 px-2 py-0.5 text-xs font-medium text-slate-700">
                            <Users size={11} />
                            {project.memberCount}
                          </span>
                        </td>

                        {/* Tasks open / total */}
                        <td className="px-4 py-3 text-center">
                          <span className="text-xs font-semibold tabular-nums text-slate-700">
                            {project.completedTaskCount}
                            <span className="font-normal text-slate-400">/{project.taskCount}</span>
                          </span>
                        </td>

                        {/* Progress bar + % */}
                        <td className="px-4 py-3">
                          {pct !== null ? (
                            <div className="flex items-center gap-2">
                              <div className="h-1.5 w-20 overflow-hidden rounded-full bg-slate-100">
                                <div
                                  className={cn(
                                    'h-full rounded-full',
                                    pct >= 100 ? 'bg-emerald-500' : pct >= 60 ? 'bg-cyan-500' : pct >= 30 ? 'bg-amber-400' : 'bg-rose-400',
                                  )}
                                  style={{ width: `${pct}%` }}
                                />
                              </div>
                              <span className="text-xs font-semibold tabular-nums text-slate-600">{pct}%</span>
                            </div>
                          ) : (
                            <span className="text-xs text-slate-400">—</span>
                          )}
                        </td>

                        {/* Created */}
                        <td className="px-4 py-3">
                          <span className="inline-flex items-center gap-1 text-xs text-slate-500">
                            <CalendarDays size={11} />
                            {formatDate(project.createdAt)}
                          </span>
                        </td>

                        {/* Lead */}
                        <td className="px-4 py-3">
                          <span className="rounded bg-slate-100 px-1.5 py-0.5 text-xs font-mono text-slate-600">
                            #{project.leadId}
                          </span>
                        </td>

                        {/* Actions */}
                        <td className="px-4 py-3">
                          <div
                            className="flex items-center gap-1.5 opacity-0 transition-opacity group-hover:opacity-100"
                            onClick={(e) => e.stopPropagation()}
                          >
                            {canUpdateProject && (
                              <button
                                type="button"
                                title="Sửa"
                                className="rounded p-1 text-slate-400 hover:bg-cyan-50 hover:text-cyan-700 transition-colors"
                                onClick={() => navigate(`/projects/edit/${project.id}`)}
                              >
                                <Edit size={14} />
                              </button>
                            )}
                            {canDeleteProject && (
                              <button
                                type="button"
                                title="Xóa"
                                disabled={deletingId === project.id}
                                className="rounded p-1 text-slate-400 hover:bg-rose-50 hover:text-rose-600 transition-colors disabled:opacity-40"
                                onClick={() => setConfirmTarget(project)}
                              >
                                <Trash2 size={14} />
                              </button>
                            )}
                          </div>
                        </td>
                      </tr>
                    );
                  })}
                </tbody>
              </table>
            </div>
          )}

          {!loading && !error && (
            <TablePagination
              currentPage={page}
              totalPages={totalPages}
              totalItems={filteredProjects.length}
              pageSize={pageSize}
              pageSizeOptions={pageSizeOptions}
              itemLabel="dự án"
              onPageChange={setPage}
              onPageSizeChange={setPageSize}
            />
          )}
        </Card>
      </div>

      <ConfirmModal
        isOpen={confirmTarget !== null}
        title="Xóa dự án"
        message={`Bạn có chắc muốn xóa dự án "${confirmTarget?.name}"? Hành động này không thể hoàn tác.`}
        confirmLabel="Xóa dự án"
        variant="danger"
        isLoading={deletingId !== null}
        onConfirm={() => void handleDeleteConfirm()}
        onCancel={() => setConfirmTarget(null)}
      />
    </MainLayout>
  );
};
