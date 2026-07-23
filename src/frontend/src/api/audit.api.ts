import apiClient from '@/utils/axios';

export interface AuditLogEntry {
  id: string;
  eventType: string;
  actorId: string | null;
  actorUsername: string | null;
  targetType: string | null;
  targetId: string | null;
  description: string | null;
  oldValue: string | null;
  newValue: string | null;
  ipAddress: string | null;
  createdAt: string;
}

export interface AuditLogPage {
  content: AuditLogEntry[];
  totalElements: number;
  totalPages: number;
  size: number;
  number: number;
  first: boolean;
  last: boolean;
}

export const auditApi = {
  getLogs: async (params?: {
    eventType?: string;
    from?: string;
    to?: string;
    page?: number;
    size?: number;
  }): Promise<AuditLogPage> => {
    const response = await apiClient.get<AuditLogPage>('/xac-thuc/nhat-ky', { params });
    return response.data;
  },
};
