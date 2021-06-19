import { exit } from "process";
import { createConnection } from "typeorm";
import { server } from "./http/server";
import ormConfig from "./ormconfig";

main();
async function main() {
  try {
    await createConnection(ormConfig);

    server.listen(Number.parseInt(process.env.NODE_PORT), () =>
      console.log("RUNNING ATM LOCATOR SERVER")
    );
  } catch (e) {
    console.log("postgres connection failed", e);
    exit(1);
  }
}
