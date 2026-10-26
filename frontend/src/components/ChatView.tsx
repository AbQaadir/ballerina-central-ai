import React from 'react';
import { TodoList } from './ChatMessageList';
import { AddTodoForm } from './SearchForm';
import type { Message } from '../types';

interface ChatViewProps {
    messages: Message[];
    onSearch: (query: string) => void;
}

export const ChatView: React.FC<ChatViewProps> = ({ messages, onSearch }) => (
    <>
        <TodoList messages={messages} />
        <div className="w-full mt-auto">
            <AddTodoForm onSearch={onSearch} position={'bottom'} />
        </div>
    </>
);