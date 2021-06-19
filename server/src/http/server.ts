import { App } from "@tinyhttp/app";
import { rateLimit } from "@tinyhttp/rate-limit";
import { json } from "body-parser";
import { registerATM_V0 } from "./routes/atm";

export const server = new App({
  settings: {
    xPoweredBy: false,
  },
});

server.use(json());

// limit to 100 requests per 2 minutes
server.use(
  rateLimit({
    max: 100,
    windowMs: 60 * 2000,
  })
);

registerATM_V0(server);
