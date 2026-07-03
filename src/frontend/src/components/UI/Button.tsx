import { ButtonHTMLAttributes, ReactNode } from 'react';
import { Loader2 } from 'lucide-react';
import { cn } from '@/utils/cn';

interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'primary' | 'secondary' | 'danger' | 'success' | 'ghost' | 'outline';
  size?: 'sm' | 'md' | 'lg' | 'icon';
  isLoading?: boolean;
  children: ReactNode;
}

const variantStyles = {
  primary: [
    'border border-blue-700/80',
    'bg-gradient-to-b from-blue-500 to-blue-600 text-white',
    'shadow-[0_1px_2px_rgba(29,78,216,0.4),inset_0_1px_0_rgba(255,255,255,0.15)]',
    'hover:from-blue-600 hover:to-blue-700',
    'active:from-blue-700 active:to-blue-700 active:shadow-none',
    'focus:ring-blue-600',
  ].join(' '),

  secondary: [
    'border border-slate-300 bg-white text-slate-800',
    'shadow-[0_1px_2px_rgba(15,23,42,0.08),inset_0_1px_0_rgba(255,255,255,0.9)]',
    'hover:border-slate-400 hover:bg-slate-50',
    'active:bg-slate-100 active:shadow-none',
    'focus:ring-slate-500',
  ].join(' '),

  danger: [
    'border border-rose-700/80',
    'bg-gradient-to-b from-rose-500 to-rose-600 text-white',
    'shadow-[0_1px_2px_rgba(190,18,60,0.4),inset_0_1px_0_rgba(255,255,255,0.15)]',
    'hover:from-rose-600 hover:to-rose-700',
    'active:from-rose-700 active:to-rose-700 active:shadow-none',
    'focus:ring-rose-500',
  ].join(' '),

  success: [
    'border border-emerald-700/80',
    'bg-gradient-to-b from-emerald-500 to-emerald-600 text-white',
    'shadow-[0_1px_2px_rgba(4,120,87,0.4),inset_0_1px_0_rgba(255,255,255,0.15)]',
    'hover:from-emerald-600 hover:to-emerald-700',
    'active:from-emerald-700 active:to-emerald-700 active:shadow-none',
    'focus:ring-emerald-500',
  ].join(' '),

  ghost: [
    'border border-transparent bg-transparent text-slate-700',
    'shadow-none',
    'hover:bg-slate-100 hover:text-slate-950',
    'active:bg-slate-200',
    'focus:ring-slate-500',
  ].join(' '),

  outline: [
    'border border-slate-300 bg-white text-slate-800',
    'shadow-none',
    'hover:border-blue-300 hover:bg-blue-50 hover:text-blue-700',
    'active:bg-blue-100',
    'focus:ring-blue-600',
  ].join(' '),
};

const sizeStyles = {
  sm:   'h-8 px-3 text-xs gap-1.5 rounded-md',
  md:   'h-10 px-4 text-sm gap-2 rounded-lg',
  lg:   'h-11 px-5 text-base gap-2 rounded-lg',
  icon: 'h-10 w-10 p-0 rounded-lg',
};

export const Button = ({
  variant = 'primary',
  size = 'md',
  isLoading = false,
  children,
  className = '',
  disabled,
  ...props
}: ButtonProps) => {
  const isDisabled = disabled || isLoading;

  return (
    <button
      className={cn(
        'interactive-lift inline-flex cursor-pointer items-center justify-center font-semibold',
        'focus:outline-none focus:ring-2 focus:ring-offset-2',
        'transition-[transform,box-shadow,background,border-color,color] duration-150',
        'disabled:pointer-events-none disabled:opacity-50',
        variantStyles[variant],
        sizeStyles[size],
        className
      )}
      disabled={isDisabled}
      {...props}
    >
      {isLoading ? (
        <>
          <Loader2 className="h-4 w-4 animate-spin" aria-hidden="true" />
          <span>Đang xử lý...</span>
        </>
      ) : (
        children
      )}
    </button>
  );
};
