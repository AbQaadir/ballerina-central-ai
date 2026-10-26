import React from "react";
import ReactDOM from "react-dom/client";
import App from "./index";
import "./App.css";
import "./index.css";

interface Config {
  choreoApiUrl: string;
}

declare global {
  interface Window {
    config: Config;
  }
}

ReactDOM.createRoot(document.getElementById("root") as HTMLElement).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);