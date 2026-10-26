import { AxiosResponse } from "axios";
import { getChatInstance } from "./instance";
import { ChatResponse } from "./types/message";

export async function sendChatMessage(message: string): Promise<string> {
  try {
    const response: AxiosResponse<ChatResponse> = await getChatInstance().post("/chat", {
      message: message
    });
    
    return response.data.message;
  } catch (error) {
    console.error('Failed to send chat message:', error);
    throw new Error(error instanceof Error ? error.message : 'Failed to connect to the server');
  }
}