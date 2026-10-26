import React from 'react';

export const Header: React.FC = () => (
    <header className="px-4 md:px-6 py-3 border-b border-gray-200 flex-shrink-0">
        <div className="max-w-7xl mx-auto flex justify-between items-center">
             <img src="https://central.ballerina.io/images/ballerina-central-logo-grey-1.svg" alt="Ballerina Central Logo" className="h-6" />
            <nav className="flex items-center gap-6 md:gap-8">
                <a href="#" className="text-base font-medium text-ballerina-teal hover:opacity-80 transition-opacity">Ballerina</a>
                <a href="#" className="text-base font-medium text-ballerina-teal hover:opacity-80 transition-opacity">Learn</a>
                <a href="#" className="text-base font-semibold border border-ballerina-teal text-ballerina-teal px-4 py-2 rounded-full hover:bg-ballerina-teal/10 transition-colors">
                    Sign in / Sign up
                </a>
            </nav>
        </div>
    </header>
);