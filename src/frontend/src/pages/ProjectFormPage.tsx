import { FormEvent, useEffect, useState } from 'react';
import { Link, useNavigate, useParams } from 'react-router-dom';
import { AlertCircle, ArrowLeft, FolderKanban, Save } from 'lucide-react';
import { employeeApi } from '@/api/employee.api';
import { projectApi } from '@/api/project.api';
import { Button } from '@/components/UI/Button';
import { Card, CardContent } from '@/components/UI/Card';
import { EmptyState } from '@/components/UI/EmptyState';
import { Input } from '@/components/UI/Input';
import { MainLayout } from '@/components/Layout/MainLayout';
import { Employee } from '@/types/employee';
import { ProjectRequest, ProjectStatus } from '@/types/project';

const statusLabels: Record<ProjectStatus, string> = {
  ACTIVE: 'Đang chạy',
  PAUSED: 'Tạm dừng',
  COMPLETED: 'Hoàn tất',
  ARCHIVED: 'Lưu trữ',
};

const emptyForm: ProjectRequest = {
  name: '',
  description: '',
  status: 'ACTIVE',
  leadId: 1,
};

export const ProjectFormPage = () => {
  const { id } = useParams();
  const navigate = useNavigate();
  const projectId = id ? Number(id) : null;
  const isEditing = projectId !== null;
  const [form, setForm] = useState<ProjectRequest>(emptyForm);
  const [loading, setLoading] = useState(isEditing);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [fieldErrors, setFieldErrors] = useState<Record<string, string>>({});
  const [employees, setEmployees] = useState<Employee[]>([]);
  const [referenceError, setReferenceError] = useState<string | null>(null);

  useEffect(() => {
    const loadEmployees = async () => {
      try {
        const response = await employeeApi.getAll({ page: 0, size: 100 });
        setEmployees(response.data.content);
      } catch {
        setReferenceError('Chưa tải được danh sách nhân viên. Có thể nhập Lead ID thủ công để tiếp tục.');
      }
    };

    void loadEmployees();
  }, []);

  useEffect(() => {
    if (!projectId) return;

    const loadProject = async () => {
      setLoading(true);
      setError(null);

      try {
        const project = await projectApi.getById(projectId);
        setForm({
          name: project.name,
          description: project.description || '',
          status: project.status,
          leadId: project.leadId,
        });
      } catch {
        setError('Không thể tải dữ liệu dự án để chỉnh sửa.');
      } finally {
        setLoading(false);
      }
    };

    void loadProject();
  }, [projectId]);

  const handleSubmit = async (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    const nextFieldErrors: Record<string, string> = {};
    const normalizedName = form.name.trim();
    const normalizedLeadId = Number(form.leadId);

    if (!normalizedName) {
      nextFieldErrors.name = 'Ten du an la bat buoc.';
    }

    if (!Number.isFinite(normalizedLeadId) || normalizedLeadId < 1) {
      nextFieldErrors.leadId = 'Vui long chon truong du an hop le.';
    }

    setFieldErrors(nextFieldErrors);
    if (Object.keys(nextFieldErrors).length > 0) return;

    setSaving(true);
    setError(null);

    try {
      const payload: ProjectRequest = {
        ...form,
        name: normalizedName,
        description: form.description?.trim() || null,
        leadId: normalizedLeadId,
      };

      const saved = projectId ? await projectApi.update(projectId, payload) : await projectApi.create(payload);
      navigate(`/projects/${saved.id}`);
    } catch {
      setError('Không thể lưu dự án. Vui lòng kiểm tra dữ liệu và thử lại.');
    } finally {
      setSaving(false);
    }
  };

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
                <h1 className="text-xl font-bold text-white">{isEditing ? 'Sửa dự án' : 'Tạo dự án'}</h1>
                <p className="mt-0.5 text-sm text-sky-300">
                  {isEditing ? 'Cập nhật thông tin vận hành, trạng thái và người phụ trách dự án.' : 'Tạo dự án mới và chỉ định người phụ trách chính.'}
                </p>
              </div>
            </div>

            <div className="flex flex-wrap items-center gap-3">
              <div className="rounded-xl bg-white/5 px-4 py-2.5 ring-1 ring-white/10">
                <div className="text-xs text-sky-300/80">Chế độ</div>
                <div className="text-base font-bold leading-none text-white mt-0.5">{isEditing ? 'Chỉnh sửa' : 'Tạo mới'}</div>
              </div>
              <div className="rounded-xl bg-white/5 px-4 py-2.5 ring-1 ring-white/10">
                <div className="text-xs text-sky-300/80">Nhân viên</div>
                <div className="text-base font-bold leading-none text-white mt-0.5">{employees.length}</div>
              </div>

              <Link to="/projects">
                <Button type="button" variant="secondary" className="gap-1.5">
                  <ArrowLeft size={16} />
                  Quay lại
                </Button>
              </Link>
            </div>
          </div>
        </div>

        {error && (
          <Card className="border-rose-200">
            <EmptyState icon={AlertCircle} title="Có lỗi xảy ra" description={error} />
          </Card>
        )}

        <Card>
          <CardContent>
            {loading ? (
              <div className="space-y-4">
                <div className="h-10 animate-pulse rounded bg-slate-100" />
                <div className="h-28 animate-pulse rounded bg-slate-100" />
              </div>
            ) : (
              <form className="space-y-5" onSubmit={(event) => void handleSubmit(event)}>
                <Input
                  label="Tên dự án"
                  required
                  value={form.name}
                  onChange={(event) => setForm((current) => ({ ...current, name: event.target.value }))}
                  error={fieldErrors.name}
                />

                <div>
                  <label htmlFor="project-description" className="mb-1.5 block text-sm font-semibold text-slate-700">
                    Mô tả
                  </label>
                  <textarea
                    id="project-description"
                    value={form.description || ''}
                    onChange={(event) => setForm((current) => ({ ...current, description: event.target.value }))}
                    rows={4}
                    className="w-full rounded-md border border-slate-300 bg-white px-3 py-2 text-sm text-slate-950 shadow-[0_1px_1px_rgba(15,23,42,0.04)] transition placeholder:text-slate-500 hover:border-slate-500 focus:border-cyan-600 focus:outline-none focus:ring-2 focus:ring-cyan-700/15"
                  />
                </div>

                <div className="grid gap-4 md:grid-cols-2">
                  <div>
                    <label htmlFor="project-status" className="mb-1.5 block text-sm font-semibold text-slate-700">
                      Trạng thái
                    </label>
                    <select
                      id="project-status"
                      value={form.status || 'ACTIVE'}
                      onChange={(event) => setForm((current) => ({ ...current, status: event.target.value as ProjectStatus }))}
                      className="h-10 w-full rounded-md border border-slate-300 bg-white px-3 text-sm text-slate-950 shadow-[0_1px_1px_rgba(15,23,42,0.04)] transition hover:border-slate-500 focus:border-cyan-600 focus:outline-none focus:ring-2 focus:ring-cyan-700/15"
                    >
                      {Object.entries(statusLabels).map(([value, label]) => (
                        <option key={value} value={value}>
                          {label}
                        </option>
                      ))}
                    </select>
                  </div>

                  <div>
                    <label htmlFor="project-lead" className="mb-1.5 block text-sm font-semibold text-slate-700">
                      Trưởng dự án <span className="ml-1 text-rose-500">*</span>
                    </label>
                    {employees.length > 0 ? (
                      <select
                        id="project-lead"
                        value={form.leadId || ''}
                        onChange={(event) => setForm((current) => ({ ...current, leadId: Number(event.target.value) }))}
                        className="h-10 w-full rounded-md border border-slate-300 bg-white px-3 text-sm text-slate-950 shadow-[0_1px_1px_rgba(15,23,42,0.04)] transition hover:border-slate-500 focus:border-cyan-600 focus:outline-none focus:ring-2 focus:ring-cyan-700/15"
                      >
                        <option value="" disabled>
                          Chọn trưởng dự án
                        </option>
                        {employees.map((employee) => (
                          <option key={employee.id} value={employee.id}>
                            {employee.name} #{employee.id}{employee.position ? ` - ${employee.position}` : ''}
                          </option>
                        ))}
                      </select>
                    ) : (
                      <Input
                        id="project-lead"
                        required
                        type="number"
                        min={1}
                        value={form.leadId}
                        onChange={(event) => setForm((current) => ({ ...current, leadId: Number(event.target.value) }))}
                        error={fieldErrors.leadId}
                        helperText={referenceError || 'Nhập ID nhân viên phụ trách dự án.'}
                      />
                    )}
                    {employees.length > 0 && fieldErrors.leadId && <p className="mt-1.5 text-sm text-rose-600">{fieldErrors.leadId}</p>}
                    {employees.length > 0 && referenceError && <p className="mt-1.5 text-xs text-amber-700">{referenceError}</p>}
                  </div>
                </div>

                <div className="flex flex-col-reverse gap-3 border-t border-slate-200 pt-5 sm:flex-row sm:justify-end">
                  <Link to="/projects">
                    <Button type="button" variant="secondary" className="w-full sm:w-auto" disabled={saving}>
                      Hủy
                    </Button>
                  </Link>
                  <Button type="submit" isLoading={saving}>
                    <Save size={16} />
                    Lưu dự án
                  </Button>
                </div>
              </form>
            )}
          </CardContent>
        </Card>
      </div>
    </MainLayout>
  );
};
