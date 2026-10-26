export interface Message {
  id: string;
  text: string;
  sender: 'user' | 'bot';
  isLoading?: boolean;
}

export interface Package {
  organization: string;
  name: string;
  version: string;
  summary: string;
  keywords: string[];
  icon: string;
  link: string;
}

export interface ChatResponse {
  message: string;
}