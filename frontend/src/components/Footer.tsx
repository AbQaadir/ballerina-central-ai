import React from 'react';

export const Footer: React.FC = () => (
    <footer className="px-4 md:px-6 py-4 border-t border-gray-200 flex-shrink-0">
        <div className="max-w-7xl mx-auto flex flex-wrap justify-between items-center text-sm text-ballerina-teal gap-4">
            <div className="flex gap-4">
                <a href="#" className="hover:opacity-80 transition-opacity">Terms of service</a>
                <a href="#" className="hover:opacity-80 transition-opacity">Privacy policy</a>
                <a href="#" className="hover:opacity-80 transition-opacity">Cookie policy</a>
                <a href="#" className="hover:opacity-80 transition-opacity">Delete policy</a>
            </div>
            <span className="font-medium">© 2025 WSO2 LLC</span>
        </div>
    </footer>
);