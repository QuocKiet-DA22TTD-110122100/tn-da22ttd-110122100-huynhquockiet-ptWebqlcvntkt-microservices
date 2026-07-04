import { ReactNode } from 'react';
import { LucideIcon } from 'lucide-react';
import { cn } from '@/utils/cn';

export interface HeroStat {
  label: string;
  value: ReactNode;
  hint?: string;
  icon?: LucideIcon;
}

interface HeroHeaderProps {
  icon: LucideIcon;
  title: string;
  description?: string;
  eyebrow?: string;
  stats?: HeroStat[];
  actions?: ReactNode;
  align?: 'center' | 'start';
  className?: string;
  children?: ReactNode;
}

/**
 * Shared page hero: soft analogous blue→indigo card (replaces the old per-page
 * dark gradient banners). One brand tone everywhere — pages are told apart by
 * icon + copy, not by hue.
 */
export const HeroHeader = ({
  icon: Icon,
  title,
  description,
  eyebrow,
  stats,
  actions,
  align = 'center',
  className = '',
  children,
}: HeroHeaderProps) => (
  <div
    className={cn(
      'relative overflow-hidden rounded-[20px] px-6 py-7',
      'bg-gradient-to-br from-blue-50 via-indigo-100 to-white',
      'shadow-[0_1px_1px_rgba(67,56,202,0.05),0_18px_34px_-12px_rgba(67,56,202,0.20)]',
      className
    )}
  >
    <div
      className={cn(
        'relative flex flex-col gap-5 sm:flex-row sm:justify-between',
        align === 'center' ? 'sm:items-center' : 'sm:items-start'
      )}
    >
      <div className="flex min-w-0 items-center gap-4">
        <div className="flex h-11 w-11 shrink-0 items-center justify-center rounded-xl bg-gradient-to-br from-blue-200 to-indigo-200">
          <Icon size={22} className="text-indigo-800" />
        </div>
        <div className="min-w-0">
          {eyebrow && (
            <p className="text-xs font-semibold uppercase tracking-wide text-indigo-500">{eyebrow}</p>
          )}
          <h1 className="text-xl font-bold text-slate-900">{title}</h1>
          {description && <p className="mt-0.5 text-sm text-indigo-700">{description}</p>}
        </div>
      </div>

      {(Boolean(stats?.length) || actions) && (
        <div className="flex flex-wrap items-center gap-3">
          {stats?.map(({ label, value, hint, icon: StatIcon }) => (
            <div
              key={label}
              className="flex items-center gap-2.5 rounded-xl bg-white px-4 py-2.5 shadow-[0_1px_2px_rgba(67,56,202,0.07)] ring-1 ring-indigo-100"
            >
              {StatIcon && <StatIcon size={16} className="text-indigo-500" />}
              <div>
                <div className="text-xs text-indigo-600">{label}</div>
                <div className="mt-0.5 text-base font-bold leading-none text-indigo-950">{value}</div>
                {hint && <div className="mt-0.5 text-[10px] leading-tight text-indigo-400">{hint}</div>}
              </div>
            </div>
          ))}
          {actions}
        </div>
      )}
    </div>
    {children}
  </div>
);
