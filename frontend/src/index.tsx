import React, { useState } from 'react';
import { Header } from './components/Header';
import { Footer } from './components/Footer';
import { LandingPage } from './components/LandingPage';
import { ChatView } from './components/ChatView';
import { sendChatMessage } from './api/chat';
import type { Message } from './types';

const App: React.FC = () => {
    const [isChatting, setIsChatting] = useState(false);
    const [messages, setMessages] = useState<Message[]>([]);

    const handleSearch = async (query: string) => {
        if (!isChatting) setIsChatting(true);

        const userMessage: Message = { id: `user-${Date.now()}`, text: query, sender: 'user' };
        setMessages(prev => [...prev, userMessage]);

        const botMessageId = `bot-${Date.now()}`;
        const loadingMessage: Message = { 
            id: botMessageId, 
            text: 'TYPING_INDICATOR', 
            sender: 'bot',
            isLoading: true
        };

        // Add loading message
        setMessages(prev => [...prev, loadingMessage]);

        try {
            const response = await sendChatMessage(query);
            
            // Replace loading message with actual response
            setMessages(prev => prev.map(m => 
                m.id === botMessageId ? { 
                    ...m, 
                    text: response, 
                    isLoading: false 
                } : m
            ));
        } catch (error) {
            // Replace loading message with error
            setMessages(prev => prev.map(m => 
                m.id === botMessageId ? { 
                    ...m, 
                    text: `Error: ${error instanceof Error ? error.message : 'Unknown error'}`, 
                    isLoading: false 
                } : m
            ));
        }
    };

    return (
        <div className="h-screen w-screen flex flex-col font-sans bg-white">
            <Header />
            
            <main className="flex-grow flex flex-col overflow-hidden relative">
                {!isChatting ? (
                    <LandingPage onSearch={handleSearch} />
                ) : (
                    <ChatView messages={messages} onSearch={handleSearch} />
                )}
            </main>

            <Footer />
        </div>
    );
};

export default App;