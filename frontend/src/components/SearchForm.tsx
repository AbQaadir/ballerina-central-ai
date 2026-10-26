import React, { useState } from 'react';

interface SearchComponentProps {
  onSearch: (query: string) => void;
  position: 'center' | 'bottom';
}

const SearchIcon: React.FC<{className?: string}> = ({className}) => (
    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className={className}>
      <path strokeLinecap="round" strokeLinejoin="round" d="M21 21l-5.197-5.197m0 0A7.5 7.5 0 105.196 5.196a7.5 7.5 0 0010.607 10.607z" />
    </svg>
);

const PaperAirplaneIcon: React.FC<{className?: string}> = ({className}) => (
    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className={className}>
        <path strokeLinecap="round" strokeLinejoin="round" d="M6 12L3.269 3.126A59.768 59.768 0 0121.485 12 59.77 59.77 0 013.27 20.876L5.999 12zm0 0h7.5" />
    </svg>
);


export const AddTodoForm: React.FC<SearchComponentProps> = ({ onSearch, position }) => {
  const [query, setQuery] = useState('');

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    const trimmedQuery = query.trim();
    if (trimmedQuery) {
      onSearch(trimmedQuery);
      setQuery('');
    }
  };

  if (position === 'center') {
    return (
      <div className="w-full max-w-3xl mx-auto flex flex-col items-center">
        <form onSubmit={handleSubmit} className="w-full">
            <div className="relative">
                <div className="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                    <SearchIcon className="h-5 w-5 text-gray-400" />
                </div>
                <input
                    type="text"
                    value={query}
                    onChange={(e) => setQuery(e.target.value)}
                    placeholder="e.g., How can I work with openai ?"
                    className="w-full bg-gray-50 border border-gray-200 rounded-full py-4 pl-11 pr-20 text-lg focus:outline-none focus:ring-2 focus:ring-ballerina-teal/50"
                />
                 <button type="submit" className="absolute inset-y-0 right-0 m-2 p-3 rounded-full bg-ballerina-teal text-white flex-shrink-0 hover:opacity-90 transition-opacity disabled:opacity-50" disabled={!query.trim()}>
                    <PaperAirplaneIcon className="w-6 h-6" />
                </button>
            </div>
        </form>
      </div>
    );
  }

  // position === 'bottom'
  return (
    <div className="w-full px-4 pt-2 pb-4 bg-transparent">
        <form onSubmit={handleSubmit} className="max-w-3xl mx-auto">
            <div className="relative">
                <input
                    type="text"
                    value={query}
                    autoFocus
                    onChange={(e) => setQuery(e.target.value)}
                    placeholder="Enter a prompt here..."
                    className="w-full bg-white rounded-full py-3.5 pl-6 pr-16 text-base focus:outline-none focus:ring-2 focus:ring-ballerina-teal/50 shadow-lg border border-gray-200/50"
                />
                <button 
                    type="submit" 
                    className="absolute top-1/2 right-2 -translate-y-1/2 p-2.5 rounded-full bg-ballerina-teal text-white flex-shrink-0 hover:opacity-90 transition-opacity disabled:opacity-50" 
                    disabled={!query.trim()}
                    aria-label="Send prompt"
                >
                    <PaperAirplaneIcon className="w-6 h-6" />
                </button>
            </div>
        </form>
    </div>
  )
};