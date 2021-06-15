import { exit } from "process";
import { createConnection } from "typeorm";
import { ATM } from "./entity/atm";
import ormconfig from "./ormconfig";

main();
async function main() {
  try {
    await createConnection(ormconfig);
  } catch (e) {
    console.log("postgres connection failed", e);
    exit(1);
  }
}
