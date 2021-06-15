import { ConnectionOptions } from "typeorm";

export default {
  type: "postgres",
  host: "pg",
  port: 5432,
  username: process.env.PG_USER,
  password: process.env.PG_PASSWORD,
  database: process.env.PG_DB,
  synchronize: true,
  logging: false,
  entities: ["lib/entity/*.js"],
  migrations: ["lib/migration/*.js"],
  subscribers: ["lib/subscriber/*.js"],
} as ConnectionOptions;
