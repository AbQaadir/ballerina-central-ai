import React from 'react';
import type { Package } from '../types';

interface PackageCardProps {
  packageData: Package;
}

export const PackageCard: React.FC<PackageCardProps> = ({ packageData }) => {
  const handleClick = () => {
    window.open(packageData.link, '_blank');
  };

  return (
    <div 
      onClick={handleClick}
      className="border border-gray-200/80 rounded-2xl p-4 flex gap-4 items-start transition-all duration-300 ease-in-out hover:shadow-lg hover:-translate-y-1 cursor-pointer bg-white"
    >
      <img 
        src={packageData.icon} 
        alt={`${packageData.name} icon`} 
        className="w-14 h-14 rounded-lg flex-shrink-0 mt-1 object-cover" 
      />
      <div className="flex-grow flex flex-col h-full">
        <div className="flex items-center gap-2 flex-wrap mb-1">
          <h3 className="text-lg font-bold bg-gradient-to-r from-ballerina-teal to-teal-400 bg-clip-text text-transparent">
            {packageData.organization}/{packageData.name}
          </h3>
          <span className="text-xs font-semibold bg-gray-100 text-gray-700 px-2.5 py-1 rounded-full">{packageData.version}</span>
        </div>
        <p className="text-sm text-gray-600 mt-1 mb-3">{packageData.summary}</p>
        {packageData.keywords && packageData.keywords.length > 0 && (
            <div className="flex flex-wrap gap-2 mb-3">
            {packageData.keywords.map(keyword => (
                <span key={keyword} className="bg-ballerina-teal/10 text-ballerina-teal text-xs font-medium px-2.5 py-1 rounded-full">
                {keyword}
                </span>
            ))}
            </div>
        )}
      </div>
    </div>
  );
};
