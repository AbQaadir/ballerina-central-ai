import React from 'react';
import { AddTodoForm } from './SearchForm';

interface LandingPageProps {
    onSearch: (query: string) => void;
}

export const LandingPage: React.FC<LandingPageProps> = ({ onSearch }) => (
    <div className="flex-grow flex flex-col justify-center items-center text-center p-4">
        <h2 className="text-4xl md:text-5xl font-light text-gray-800 mb-8">
            Discover reusable <span className="font-medium text-ballerina-teal">Ballerina</span> packages
        </h2>
        <AddTodoForm onSearch={onSearch} position={'center'} />
    </div>
);