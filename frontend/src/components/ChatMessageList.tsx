import React, { useRef, useEffect } from 'react';
import type { Message } from '../types';
import { TodoItem } from './ChatMessage'; // This is now ChatMessage

interface ChatMessagesProps {
  messages: Message[];
}

export const TodoList: React.FC<ChatMessagesProps> = ({ messages }) => {
  const endOfMessagesRef = useRef<HTMLDivElement | null>(null);

  useEffect(() => {
    endOfMessagesRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [messages]);

  return (
    <div className="flex-grow overflow-y-auto">
      <div className="max-w-3xl mx-auto">
        {messages.map(message => (
          <TodoItem
            key={message.id}
            message={message}
          />
        ))}
      </div>
      <div ref={endOfMessagesRef} />
    </div>
  );
};
