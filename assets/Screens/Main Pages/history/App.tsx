import { useState } from 'react';
import svgPaths from "./imports/svg-h4p1z0em35";
import imgVisaPng41 from "figma:asset/5d085a41c0740ec6118c5c25b886831b4e5db03e.png";

type Transaction = {
  id: string;
  type: string;
  status: 'Paid' | 'Failed';
  amount: number;
  date: string;
  time: string;
  icon: 'tuition' | 'bus' | 'library';
  term?: string;
};

const transactions: Transaction[] = [
  {
    id: '1',
    type: 'Tuition Fee',
    status: 'Paid',
    amount: 15500,
    date: '10 July 2025',
    time: '6:00 pm',
    icon: 'tuition',
    term: 'Term 3'
  },
  {
    id: '2',
    type: 'Bus Fee',
    status: 'Paid',
    amount: 10000,
    date: '10 July 2025',
    time: '6:00 pm',
    icon: 'bus',
    term: 'Term 2'
  },
  {
    id: '3',
    type: 'Library Fee',
    status: 'Failed',
    amount: 1000,
    date: '10 July 2025',
    time: '6:00 pm',
    icon: 'library',
    term: 'Term 1'
  }
];

function TransactionIcon({ icon, status }: { icon: Transaction['icon']; status: Transaction['status'] }) {
  const bgColor = status === 'Paid' ? '#2dbe60' : '#dc2626';

  if (icon === 'tuition') {
    return (
      <div className="bg-[var(--bg)] overflow-clip relative rounded-[8px] shrink-0 size-[40px]" style={{ '--bg': bgColor } as React.CSSProperties}>
        <div className="absolute inset-[20%]">
          <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24 24">
            <path d={svgPaths.p217bb200} fill="white" />
          </svg>
        </div>
      </div>
    );
  }

  if (icon === 'bus') {
    return (
      <div className="bg-[#2dbe60] overflow-clip relative rounded-[8px] shrink-0 size-[40px]">
        <div className="absolute inset-[20%]">
          <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24 24">
            <path d={svgPaths.p2657bb00} fill="white" />
            <path d={svgPaths.p15b8700} fill="white" />
            <path d={svgPaths.p28daad80} fill="white" />
          </svg>
        </div>
      </div>
    );
  }

  if (icon === 'library') {
    return (
      <div className="bg-[#dc2626] overflow-clip relative rounded-[8px] shrink-0 size-[40px]">
        <div className="absolute inset-[20%]">
          <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24 24">
            <path d="M6 6.5L18 18.5" stroke="white" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" />
            <path d="M6 18.5L18 6.5" stroke="white" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" />
          </svg>
        </div>
      </div>
    );
  }

  return null;
}

function TransactionCard({ transaction }: { transaction: Transaction }) {
  const statusColor = transaction.status === 'Paid' ? '#2dbe60' : '#dc2626';

  return (
    <div className="bg-white content-stretch flex flex-col items-end p-[16px] rounded-[12px] shadow-[0px_5px_40px_0px_rgba(128,128,135,0.1),0px_0px_1px_0px_rgba(0,81,198,0.75)] w-full">
      <div className="content-stretch flex flex-col gap-[12px] items-start w-full">
        <div className="content-stretch flex items-start justify-between w-full">
          <div className="content-stretch flex gap-[10px] items-center">
            <TransactionIcon icon={transaction.icon} status={transaction.status} />
            <div className="content-stretch flex flex-col gap-[6px] items-start">
              <p className="font-['SF_Pro:Regular',sans-serif] font-normal leading-[22px] text-[#1f2933] text-[15px] text-nowrap" style={{ fontVariationSettings: "'wdth' 100" }}>
                {transaction.type}
              </p>
              <div className="content-stretch flex gap-[5px] items-center justify-center">
                <div className="h-[14px] w-[34px]">
                  <img alt="" className="max-w-none object-50%-50% object-cover pointer-events-none size-full" src={imgVisaPng41} />
                </div>
                <p className="font-['SF_Pro:Regular',sans-serif] font-normal leading-[18px] text-[#6b7280] text-[12px] text-nowrap" style={{ fontVariationSettings: "'wdth' 100" }}>
                  **** 9918
                </p>
              </div>
            </div>
          </div>
          <div className="content-stretch flex flex-col gap-[3px] items-end justify-center text-nowrap">
            <p className="font-['SF_Pro:Semibold',sans-serif] font-[590] leading-[18px] text-[12px]" style={{ color: statusColor, fontVariationSettings: "'wdth' 100" }}>
              {transaction.status}
            </p>
            <p className="font-['Plus_Jakarta_Sans:SemiBold',sans-serif] font-semibold leading-[24px] text-[#1f2933] text-[18px]">
              ₹ {transaction.amount.toLocaleString()}
            </p>
          </div>
        </div>
        <div className="content-stretch flex items-center justify-between w-full">
          <div className="content-stretch flex gap-[6px] items-center justify-center">
            <p className="font-['SF_Pro:Regular',sans-serif] font-normal leading-[22px] text-[#6b7280] text-[15px] text-nowrap" style={{ fontVariationSettings: "'wdth' 100" }}>
              {transaction.date}
            </p>
            <div className="flex items-center justify-center">
              <div className="flex-none rotate-[180deg]">
                <div className="size-[4px]">
                  <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 4 4">
                    <circle cx="2" cy="2" fill="#6B7280" r="2" />
                  </svg>
                </div>
              </div>
            </div>
            <p className="font-['SF_Pro:Regular',sans-serif] font-normal leading-[22px] text-[#6b7280] text-[15px] text-nowrap" style={{ fontVariationSettings: "'wdth' 100" }}>
              {transaction.time}
            </p>
          </div>
          <div className="flex items-center justify-center">
            <div className="flex-none rotate-[180deg]">
              <div className="size-[24px]">
                <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24 24">
                  <path d={svgPaths.p2a5cd480} stroke="#6B7280" strokeLinecap="round" strokeLinejoin="round" strokeMiterlimit="10" strokeWidth="1.5" />
                </svg>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

function FilterTabs({ activeFilter, onFilterChange }: { activeFilter: string; onFilterChange: (filter: string) => void }) {
  const filters = ['All', 'Term 1', 'Term 2', 'Term 3'];

  return (
    <div className="content-stretch flex gap-[16px] items-center">
      {filters.map((filter) => (
        <button
          key={filter}
          onClick={() => onFilterChange(filter)}
          className={`content-stretch flex items-center px-[16px] py-[10px] rounded-[12px] shrink-0 relative ${
            activeFilter === filter ? 'bg-[#1f2933]' : ''
          }`}
        >
          {activeFilter !== filter && (
            <div aria-hidden="true" className="absolute border border-[#6b7280] border-solid inset-0 pointer-events-none rounded-[12px]" />
          )}
          <p
            className={`font-['SF_Pro:Regular',sans-serif] font-normal leading-[18px] text-[12px] text-nowrap ${
              activeFilter === filter ? 'text-[#fafafa]' : 'text-[#6b7280]'
            }`}
            style={{ fontVariationSettings: "'wdth' 100" }}
          >
            {filter}
          </p>
        </button>
      ))}
    </div>
  );
}

export default function App() {
  const [activeFilter, setActiveFilter] = useState('All');

  const filteredTransactions = transactions.filter((transaction) => {
    if (activeFilter === 'All') return true;
    return transaction.term === activeFilter;
  });

  return (
    <div className="min-h-screen bg-[#fafafa] flex justify-center">
      <div className="w-full max-w-[430px] min-h-screen bg-[#fafafa] pb-[100px] relative">
        {/* Header */}
        <div className="relative pt-[39px] px-[24px] pb-[66px]">
          <div className="flex items-center justify-between">
            <button className="bg-white content-stretch flex flex-col items-center justify-center p-[11px] rounded-[50px] shadow-[0px_5px_40px_0px_rgba(128,128,135,0.1),0px_0px_1px_0px_rgba(0,81,198,0.75)]">
              <div className="size-[24px]">
                <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24 24">
                  <path d="M13.5 18H4M20 12H4M20 6H4" stroke="#1F2933" strokeLinecap="round" strokeWidth="2" />
                </svg>
              </div>
            </button>

            <p className="font-['Plus_Jakarta_Sans:SemiBold',sans-serif] font-semibold leading-[24px] text-[#1f2933] text-[18px] text-nowrap absolute left-1/2 -translate-x-1/2">
              History
            </p>

            <button className="bg-white content-stretch flex flex-col gap-[10px] items-center justify-center p-[9px] rounded-[50px] shadow-[0px_5px_40px_0px_rgba(128,128,135,0.1),0px_0px_1px_0px_rgba(0,81,198,0.75)] relative">
              <div className="size-[28px]">
                <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24 24">
                  <path d={svgPaths.p2e393100} stroke="#292D32" strokeLinecap="round" strokeMiterlimit="10" strokeWidth="1.5" />
                  <path d={svgPaths.p3718def0} stroke="#292D32" strokeLinecap="round" strokeLinejoin="round" strokeMiterlimit="10" strokeWidth="1.5" />
                  <path d={svgPaths.p21656e00} stroke="#292D32" strokeMiterlimit="10" strokeWidth="1.5" />
                </svg>
              </div>
              <div className="absolute right-[9px] top-[11px] size-[8px]">
                <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 9 9">
                  <circle cx="4.5" cy="4.5" fill="#007DFC" r="4" stroke="white" />
                </svg>
              </div>
            </button>
          </div>
        </div>

        {/* Filter Tabs */}
        <div className="px-[24px] mb-[24px]">
          <FilterTabs activeFilter={activeFilter} onFilterChange={setActiveFilter} />
        </div>

        {/* Transaction List */}
        <div className="px-[24px] flex flex-col gap-[16px]">
          {filteredTransactions.map((transaction) => (
            <TransactionCard key={transaction.id} transaction={transaction} />
          ))}
        </div>

        {/* Bottom Navigation */}
        <div className="fixed bottom-0 left-1/2 -translate-x-1/2 w-full max-w-[430px] bg-white border-t border-[#e5e7eb] content-stretch flex items-center justify-around px-[16px] py-[12px]">
          <button className="content-stretch flex flex-col gap-[5px] items-center">
            <div className="size-[24px]">
              <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24 24">
                <path d="M12 18V15" stroke="#6B7280" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
                <path d={svgPaths.p1f860900} stroke="#6B7280" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
              </svg>
            </div>
            <p className="font-['SF_Pro:Regular',sans-serif] font-normal leading-[18px] text-[#6b7280] text-[12px] text-nowrap" style={{ fontVariationSettings: "'wdth' 100" }}>
              Home
            </p>
          </button>

          <button className="content-stretch flex flex-col gap-[5px] items-center">
            <div className="size-[24px]">
              <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24 24">
                <path d="M2 8.50496H22" stroke="#6B7280" strokeLinecap="round" strokeLinejoin="round" strokeMiterlimit="10" strokeWidth="1.5" />
                <path d="M6 16.505H8" stroke="#6B7280" strokeLinecap="round" strokeLinejoin="round" strokeMiterlimit="10" strokeWidth="1.5" />
                <path d="M10.5 16.505H14.5" stroke="#6B7280" strokeLinecap="round" strokeLinejoin="round" strokeMiterlimit="10" strokeWidth="1.5" />
                <path d={svgPaths.p34478e00} stroke="#6B7280" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
              </svg>
            </div>
            <p className="font-['SF_Pro:Regular',sans-serif] font-normal leading-[18px] text-[#6b7280] text-[12px] text-nowrap" style={{ fontVariationSettings: "'wdth' 100" }}>
              Fees
            </p>
          </button>

          <button className="content-stretch flex flex-col gap-[5px] items-center">
            <div className="size-[24px]">
              <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24 24">
                <clipPath id="clip0_1_573">
                  <rect fill="white" height="24" width="24" />
                </clipPath>
                <g clipPath="url(#clip0_1_573)">
                  <path d="M4 4V8H7" stroke="#007DFC" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" />
                  <path d={svgPaths.p1d901900} stroke="#007DFC" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" />
                  <path d="M12.0006 7L12 12.2752L16 16" stroke="#007DFC" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" />
                </g>
              </svg>
            </div>
            <p className="font-['SF_Pro:Semibold',sans-serif] font-[590] leading-[18px] text-[#007dfc] text-[12px] text-nowrap" style={{ fontVariationSettings: "'wdth' 100" }}>
              History
            </p>
          </button>

          <button className="content-stretch flex flex-col gap-[5px] items-center">
            <div className="size-[24px]">
              <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24 24">
                <path d={svgPaths.p2e393100} stroke="#6B7280" strokeLinecap="round" strokeMiterlimit="10" strokeWidth="1.5" />
                <path d={svgPaths.p3718def0} stroke="#6B7280" strokeLinecap="round" strokeLinejoin="round" strokeMiterlimit="10" strokeWidth="1.5" />
                <path d={svgPaths.p21656e00} stroke="#6B7280" strokeMiterlimit="10" strokeWidth="1.5" />
              </svg>
            </div>
            <p className="font-['SF_Pro:Regular',sans-serif] font-normal leading-[18px] text-[#6b7280] text-[12px] text-nowrap" style={{ fontVariationSettings: "'wdth' 100" }}>
              Alerts
            </p>
          </button>

          <button className="content-stretch flex flex-col gap-[5px] items-center">
            <div className="size-[24px]">
              <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24 24">
                <path d={svgPaths.p3aeab480} stroke="#6B7280" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
                <path d={svgPaths.p364c500} stroke="#6B7280" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
                <circle cx="12" cy="12" r="10" stroke="#6B7280" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
              </svg>
            </div>
            <p className="font-['SF_Pro:Regular',sans-serif] font-normal leading-[18px] text-[#6b7280] text-[12px] text-nowrap" style={{ fontVariationSettings: "'wdth' 100" }}>
              Profile
            </p>
          </button>
        </div>
      </div>
    </div>
  );
}