import { useState } from 'react';
import { Link, useParams } from 'react-router-dom';
import { ArrowLeft, Bell, ClipboardEdit, WalletCards } from 'lucide-react';
import { MainLayout } from '@/components/Layout/MainLayout';
import { Badge } from '@/components/UI/Badge';
import { Button } from '@/components/UI/Button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/UI/Card';
import { roleProfiles } from '@/config/roleExperience';
import { useUIStore } from '@/store/uiStore';

interface BhxhEmployee {
  id: string;
  name: string;
  department: string;
  missingField: string;
  joinDate: string;
  notified: boolean;
  updated: boolean;
}

const initialEmployees: BhxhEmployee[] = [
  { id: 'NV-008', name: 'Nguyễn Thị Lan',   department: 'Kỹ thuật',         missingField: 'Số sổ BHXH',               joinDate: '2025-11-01', notified: false, updated: false },
  { id: 'NV-015', name: 'Trần Văn Minh',    department: 'Kinh doanh',        missingField: 'Mức đóng BHYT',            joinDate: '2025-12-15', notified: false, updated: false },
  { id: 'NV-023', name: 'Lê Hoàng Phúc',   department: 'Vận hành',          missingField: 'Số sổ BHXH, BHYT',         joinDate: '2026-01-03', notified: false, updated: false },
  { id: 'NV-031', name: 'Phạm Thu Hà',      department: 'Nhân sự',           missingField: 'Mức lương đóng BHXH',      joinDate: '2026-01-20', notified: false, updated: false },
  { id: 'NV-047', name: 'Đỗ Văn Khoa',      department: 'Kế toán',           missingField: 'Số sổ BHXH',               joinDate: '2026-02-01', notified: false, updated: false },
  { id: 'NV-055', name: 'Võ Thị Nhi',       department: 'Kỹ thuật',         missingField: 'BHYT, mức đóng',           joinDate: '2026-02-15', notified: false, updated: false },
  { id: 'NV-068', name: 'Bùi Quang Huy',    department: 'Kinh doanh',        missingField: 'Số sổ BHXH',               joinDate: '2026-03-01', notified: false, updated: false },
  { id: 'NV-079', name: 'Huỳnh Ngọc Bảo',  department: 'Vận hành',          missingField: 'Đơn vị tham gia BHXH',    joinDate: '2026-03-10', notified: false, updated: false },
  { id: 'NV-088', name: 'Mai Thị Tuyết',    department: 'Chăm sóc KH',      missingField: 'Mức đóng BHXH',            joinDate: '2026-04-01', notified: false, updated: false },
  { id: 'NV-096', name: 'Ngô Anh Tuấn',     department: 'Kế toán',           missingField: 'Số sổ BHXH, BHYT',         joinDate: '2026-04-15', notified: false, updated: false },
  { id: 'NV-104', name: 'Ngô Phương Linh',  department: 'Kế toán',           missingField: 'Thông tin bảo hiểm đầy đủ', joinDate: '2026-05-01', notified: false, updated: false },
];

const taskMeta: Record<string, { title: string; description: string }> = {
  task_bhxh_11: {
    title: 'Thiếu thông tin bảo hiểm',
    description: '11 hồ sơ chưa đủ thông tin BHXH/BHYT trước kỳ payroll. HR cần liên hệ từng nhân viên và cập nhật dữ liệu.',
  },
};

const formatDate = (value: string) =>
  new Date(value).toLocaleDateString('vi-VN', { day: '2-digit', month: '2-digit', year: 'numeric' });

export const BenefitsReviewPage = () => {
  const { taskId = '' } = useParams();
  const { addNotification } = useUIStore();
  const [employees, setEmployees] = useState<BhxhEmployee[]>(initialEmployees);

  const meta = taskMeta[taskId] ?? {
    title: 'Xem xét hồ sơ',
    description: 'Danh sách nhân viên cần bổ sung thông tin bảo hiểm.',
  };

  const notifiedCount = employees.filter((e) => e.notified).length;
  const updatedCount = employees.filter((e) => e.updated).length;
  const pendingCount = employees.filter((e) => !e.updated).length;

  const sendReminder = (emp: BhxhEmployee) => {
    setEmployees((prev) =>
      prev.map((e) => (e.id === emp.id ? { ...e, notified: true } : e))
    );
    addNotification({
      type: 'success',
      message: `Đã gửi nhắc nhở tới ${emp.name} (${emp.id}) qua email nội bộ.`,
    });
  };

  const sendAllReminders = () => {
    const pending = employees.filter((e) => !e.notified);
    if (pending.length === 0) {
      addNotification({ type: 'info', message: 'Tất cả nhân viên đã được gửi nhắc nhở.' });
      return;
    }
    setEmployees((prev) => prev.map((e) => ({ ...e, notified: true })));
    addNotification({
      type: 'success',
      message: `Đã gửi nhắc nhở hàng loạt tới ${pending.length} nhân viên.`,
    });
  };

  const openUpdateForm = (emp: BhxhEmployee) => {
    setEmployees((prev) =>
      prev.map((e) => (e.id === emp.id ? { ...e, updated: true } : e))
    );
    addNotification({
      type: 'info',
      message: `Đã mở form cập nhật BHXH cho ${emp.name} — kết nối API /api/benefits/employees/${emp.id}/insurance khi backend sẵn sàng.`,
    });
  };

  const heroTone = roleProfiles.hr.toneClass;

  return (
    <MainLayout>
      <div className="space-y-6">
        {/* Header */}
        <section className={`relative overflow-hidden rounded-2xl bg-gradient-to-br ${heroTone} px-6 py-7 shadow-xl`}>
          {/* Decorative orbs */}
          <div className="pointer-events-none absolute -right-16 -top-16 h-48 w-48 rounded-full bg-cyan-400/10 blur-3xl" />
          <div className="pointer-events-none absolute -bottom-12 left-1/3 h-36 w-36 rounded-full bg-emerald-400/10 blur-2xl" />

          <div className="relative flex flex-col gap-5 sm:flex-row sm:items-start sm:justify-between">
            <div className="flex min-w-0 gap-4">
              <div className="flex h-12 w-12 shrink-0 items-center justify-center rounded-xl bg-white/15 ring-1 ring-white/25">
                <WalletCards size={24} className="text-white" />
              </div>
              <div className="min-w-0">
                <p className="text-xs font-semibold uppercase tracking-wide text-white/70">Phúc lợi · Rà soát hồ sơ</p>
                <h1 className="mt-1 text-2xl font-bold tracking-tight text-white">{meta.title}</h1>
                <p className="mt-2 max-w-2xl text-sm leading-6 text-slate-300">{meta.description}</p>
              </div>
            </div>
            <Link to="/workspace/benefits" className="shrink-0">
              <Button type="button" variant="outline">
                <ArrowLeft size={15} />
                Quay lại Phúc lợi
              </Button>
            </Link>
          </div>

          {/* Stat pills */}
          <div className="relative mt-5 flex flex-wrap gap-3">
            {[
              { label: 'Chờ cập nhật', value: pendingCount, hint: 'Hồ sơ chưa bổ sung BHXH' },
              { label: 'Đã nhắc nhở', value: notifiedCount, hint: 'Đã gửi thông báo qua email' },
              { label: 'Đã cập nhật', value: updatedCount, hint: 'Hồ sơ đã điền đủ thông tin' },
            ].map((m) => (
              <div
                key={m.label}
                className="flex flex-col rounded-xl bg-white/5 px-4 py-2.5 ring-1 ring-white/10 backdrop-blur-sm"
              >
                <span className="text-xs text-slate-300">{m.label}</span>
                <span className="mt-0.5 text-base font-bold leading-none text-white">{m.value}</span>
                <span className="mt-1 text-[10px] leading-tight text-slate-400">{m.hint}</span>
              </div>
            ))}
          </div>
        </section>

        {/* Actions toolbar */}
        <Card className="p-4">
          <div className="flex flex-wrap items-center gap-3">
            <p className="text-sm font-semibold text-slate-700">Hành động hàng loạt:</p>
            <Button type="button" variant="secondary" onClick={sendAllReminders}>
              <Bell size={15} />
              Gửi nhắc nhở tất cả
            </Button>
            <Button
              type="button"
              variant="outline"
              onClick={() =>
                addNotification({
                  type: 'info',
                  message: 'GET /api/benefits/tasks/task_bhxh_11/employees — endpoint chưa có backend trong phiên bản MVP.',
                })
              }
            >
              Tải lại từ API
            </Button>
            <span className="ml-auto text-xs text-slate-400">
              API: <code className="rounded bg-slate-100 px-1.5 py-0.5 font-mono">GET /api/benefits/tasks/{taskId}/employees</code>
            </span>
          </div>
        </Card>

        {/* Employee table */}
        <Card className="overflow-hidden">
          <CardHeader>
            <CardTitle>Danh sách {employees.length} nhân viên cần bổ sung BHXH</CardTitle>
            <CardDescription>
              Bấm "Gửi nhắc nhở" để thông báo qua email, "Cập nhật BHXH" để điền nhanh thông tin còn thiếu.
            </CardDescription>
          </CardHeader>
          <CardContent className="p-0">
            <div className="overflow-x-auto">
              <table className="w-full min-w-[800px] text-left text-sm">
                <thead className="border-b border-slate-200 bg-slate-50 text-xs font-semibold uppercase tracking-wide text-slate-500">
                  <tr>
                    <th className="px-5 py-3">Mã NV</th>
                    <th className="px-5 py-3">Nhân viên</th>
                    <th className="px-5 py-3">Phòng ban</th>
                    <th className="px-5 py-3">Thông tin còn thiếu</th>
                    <th className="px-5 py-3">Ngày vào</th>
                    <th className="px-5 py-3">Trạng thái</th>
                    <th className="px-5 py-3 text-right">Hành động</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-slate-100 bg-white">
                  {employees.map((emp, idx) => (
                    <tr
                      key={emp.id}
                      className="group animate-fade-up transition-colors hover:bg-slate-50/60"
                      style={{ animationDelay: `${Math.min(idx * 35, 350)}ms` }}
                    >
                      <td className="px-5 py-3.5 font-mono text-xs font-semibold text-slate-500">{emp.id}</td>
                      <td className="px-5 py-3.5">
                        <p className="font-semibold text-slate-900">{emp.name}</p>
                      </td>
                      <td className="px-5 py-3.5 text-slate-600">{emp.department}</td>
                      <td className="px-5 py-3.5">
                        <span className="inline-flex items-center gap-1 rounded-md bg-amber-50 px-2 py-1 text-xs font-semibold text-amber-800 ring-1 ring-amber-200">
                          {emp.missingField}
                        </span>
                      </td>
                      <td className="px-5 py-3.5 text-slate-500">{formatDate(emp.joinDate)}</td>
                      <td className="px-5 py-3.5">
                        {emp.updated ? (
                          <Badge variant="success">Đã cập nhật</Badge>
                        ) : emp.notified ? (
                          <Badge variant="info">Đã nhắc nhở</Badge>
                        ) : (
                          <Badge variant="warning">Chờ xử lý</Badge>
                        )}
                      </td>
                      <td className="px-5 py-3.5">
                        <div className="flex items-center justify-end gap-2">
                          <button
                            type="button"
                            disabled={emp.notified}
                            onClick={() => sendReminder(emp)}
                            className="inline-flex items-center gap-1.5 rounded-md border border-slate-200 bg-white px-2.5 py-1.5 text-xs font-semibold text-slate-700 transition hover:border-blue-300 hover:bg-blue-50 hover:text-blue-800 disabled:cursor-not-allowed disabled:opacity-40 focus:outline-none focus:ring-2 focus:ring-blue-400 focus:ring-offset-1"
                          >
                            <Bell size={12} />
                            {emp.notified ? 'Đã gửi' : 'Nhắc nhở'}
                          </button>
                          <button
                            type="button"
                            disabled={emp.updated}
                            onClick={() => openUpdateForm(emp)}
                            className="inline-flex items-center gap-1.5 rounded-md border border-cyan-600 bg-cyan-600 px-2.5 py-1.5 text-xs font-semibold text-white transition hover:bg-cyan-700 disabled:cursor-not-allowed disabled:opacity-40 focus:outline-none focus:ring-2 focus:ring-cyan-500 focus:ring-offset-1"
                          >
                            <ClipboardEdit size={12} />
                            {emp.updated ? 'Đã cập nhật' : 'Cập nhật BHXH'}
                          </button>
                        </div>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </CardContent>
        </Card>

        {/* API contract note */}
        <div className="rounded-lg border border-slate-200 bg-slate-50 p-4 text-sm text-slate-600">
          <p className="font-semibold text-slate-700">API Contracts (chưa có backend)</p>
          <ul className="mt-2 space-y-1 font-mono text-xs text-slate-500">
            <li>GET /api/benefits/tasks/{taskId}/employees — tải danh sách nhân viên</li>
            <li>POST /api/benefits/employees/:id/notify — gửi nhắc nhở qua email/chat</li>
            <li>PATCH /api/benefits/employees/:id/insurance — cập nhật thông tin BHXH</li>
          </ul>
        </div>
      </div>
    </MainLayout>
  );
};
