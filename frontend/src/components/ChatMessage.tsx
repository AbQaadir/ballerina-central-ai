import React from 'react';
import ReactMarkdown from 'react-markdown';
import remarkGfm from 'remark-gfm';
import type { Message, Package } from '../types';
import { PackageCard } from './PackageCard';

interface ChatMessageProps {
  message: Message;
}

const UserIcon: React.FC = () => (
    <div className="w-8 h-8 rounded-full bg-gray-200 flex items-center justify-center font-bold text-sm text-gray-600 flex-shrink-0">
        U
    </div>
);

const BotIcon: React.FC = () => (
    <img
        src="https://avatars.githubusercontent.com/u/34733518?s=200&v=4"
        alt="Ballerina Central Avatar"
        className="w-8 h-8 rounded-full flex-shrink-0"
    />
);

const TypingIndicator = () => (
    <div className="flex items-center gap-1.5 py-2">
        <div className="w-2 h-2 bg-gray-400 rounded-full animate-bounce [animation-delay:-0.3s]"></div>
        <div className="w-2 h-2 bg-gray-400 rounded-full animate-bounce [animation-delay:-0.15s]"></div>
        <div className="w-2 h-2 bg-gray-400 rounded-full animate-bounce"></div>
    </div>
);

const BotMessageRenderer: React.FC<{ content: string; isLoading?: boolean }> = ({ 
    content, 
    isLoading 
}) => {
    if (content === 'TYPING_INDICATOR' || isLoading) {
        return <TypingIndicator />;
    }

    // Regex to split the string by the package divs, keeping the divs in the result
    const parts = content.split(/(<div class="ballerina-package".*?><\/div>)/s);

    return (
        <>
            {parts.map((part, index) => {
                if (part.startsWith('<div class="ballerina-package"')) {
                    // It's a package div, extract the JSON from the data-package attribute
                    const match = part.match(/data-package='(.*?)'/s);
                    if (match && match[1]) {
                        try {
                            const packageData: Package = JSON.parse(match[1]);
                            return <PackageCard key={index} packageData={packageData} />;
                        } catch (error) {
                            console.error("Failed to parse package JSON:", error);
                            // Gracefully fail by rendering nothing for this malformed part
                            return null;
                        }
                    }
                    return null;
                } else if (part.trim()) {
                    // It's a markdown/text part, render it using react-markdown
                    return (
                        <div key={index} className="prose prose-sm max-w-none break-words overflow-hidden">
                            <ReactMarkdown 
                                remarkPlugins={[remarkGfm]} 
                                components={{
                                    code: ({ node, className, children, ...props }: any) => {
                                        const inline = !className?.includes('language-');
                                        if (inline) {
                                            return (
                                                <code 
                                                    className="bg-gray-100 text-ballerina-teal px-2 py-1 rounded text-sm font-mono break-words"
                                                    {...props}
                                                >
                                                    {children}
                                                </code>
                                            );
                                        }
                                        return (
                                            <pre className="bg-gray-50 border border-gray-200 rounded-lg p-4 overflow-x-auto my-4">
                                                <code className="text-gray-800 text-sm font-mono block whitespace-pre">
                                                    {children}
                                                </code>
                                            </pre>
                                        );
                                    },
                                    p: ({ children }) => (
                                        <p className="text-gray-700 mb-3 break-words">{children}</p>
                                    ),
                                    h1: ({ children }) => (
                                        <h1 className="text-gray-800 text-xl font-bold mb-4 break-words">{children}</h1>
                                    ),
                                    h2: ({ children }) => (
                                        <h2 className="text-gray-800 text-lg font-bold mb-3 break-words">{children}</h2>
                                    ),
                                    h3: ({ children }) => (
                                        <h3 className="text-gray-800 text-base font-bold mb-2 break-words">{children}</h3>
                                    ),
                                    a: ({ children, href }) => (
                                        <a href={href} className="text-ballerina-teal hover:opacity-80 break-words" target="_blank" rel="noopener noreferrer">
                                            {children}
                                        </a>
                                    ),
                                    li: ({ children }) => (
                                        <li className="text-gray-700 break-words">{children}</li>
                                    ),
                                    strong: ({ children }) => (
                                        <strong className="text-gray-900 font-semibold">{children}</strong>
                                    ),
                                }}
                                children={part.trim()} 
                            />
                        </div>
                    );
                }
                return null;
            })}
        </>
    );
};

export const TodoItem: React.FC<ChatMessageProps> = ({ message }) => {
    const isUser = message.sender === 'user';

    return (
        <div className={`flex items-start gap-4 p-4 md:p-6 ${!isUser && 'bg-gray-50'}`}>
            {isUser ? <UserIcon /> : <BotIcon />}
            <div className="flex-grow pt-0.5">
                <p className="font-semibold text-gray-900 mb-2">
                    {isUser ? 'You' : 'Ballerina Central'}
                </p>
                <div className="space-y-4">
                   {isUser 
                        ? <div className="text-gray-700 whitespace-pre-wrap">{message.text}</div>
                        : <BotMessageRenderer 
                            content={message.text} 
                            isLoading={message.isLoading}
                          />
                   }
                </div>
            </div>
        </div>
    );
};
