declare global {
  namespace NodeJS {
    interface ProcessEnv {
      NODE_ENV: "development" | "production";
      NODE_PORT: string;
    }
  }
}

export {};
