import axios from "axios";

export const getChatInstance = () => {
  // Check if window.configs is available, with fallback (following Choreo documentation)
  const apiUrl = (window as any)?.configs?.apiUrl ? (window as any).configs.apiUrl : "/";
  
  console.log('API Base URL:', apiUrl); // For debugging
  
  return axios.create({ 
    baseURL: apiUrl,
    headers: {
      'Content-Type': 'application/json'
    },
    timeout: 30000 // 30 seconds timeout
  });
};