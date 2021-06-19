import { ATM } from "../entity/atm";
import { Piraeus } from "./piraeus";
import { createConnection } from "typeorm";
import ormconfig from "../ormconfig";

async function main() {
  await createConnection(ormconfig);

  const piraeusResult = await Piraeus.execute();

  try {
    if (piraeusResult.removed.length !== 0) {
      await ATM.remove(piraeusResult.removed);
    }

    if (piraeusResult.added.length !== 0) {
      await ATM.insert(piraeusResult.added);
    }
  } catch (e) {
    console.log(e);
  }
}

main();
