import { ConnectionOptions } from "typeorm";

const dev = {
  type: "postgres",
  host: "pg",
  port: 5432,
  username: process.env.PG_USER,
  password: process.env.PG_PASSWORD,
  database: process.env.PG_DB,
  synchronize: false,
  logging: false,
  entities: ["lib/entity/*.js"],
  migrations: ["lib/migration/*.js"],
  subscribers: ["lib/subscriber/*.js"],
} as ConnectionOptions;

const prod = {
  type: "postgres",
  host: "pg",
  port: 5432,
  username: process.env.PG_USER,
  password: process.env.PG_PASSWORD,
  database: process.env.PG_DB,
  synchronize: false,
  logging: false,
  entities: ["lib/entity/*.js"],
  migrations: ["lib/migration/*.js"],
  subscribers: ["lib/subscriber/*.js"],
} as ConnectionOptions;

export default {
  ...(process.env.NODE_ENV === "development" ? dev : prod),
};
