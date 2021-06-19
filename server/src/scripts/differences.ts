import { ATM } from "../entity/atm";

/*
  finds the new and removed atms
  based on their full id
*/
export function differencesBetweenATMS(
  fetchedAtms: ATM[],
  dbAtms: ATM[]
): {
  added: ATM[];
  removed: ATM[];
} {
  const added: ATM[] = [];
  const removed: ATM[] = [];

  /// finds the `new` atms
  for (const atm of fetchedAtms) {
    let i: number;

    for (i = 0; i < dbAtms.length; ++i) {
      if (atm.fullId === dbAtms[i].fullId) {
        break;
      }
    }

    if (i === dbAtms.length) {
      added.push(atm);
    }
  }

  /// finds the `deleted` atms
  for (const atm of dbAtms) {
    let i: number;

    for (i = 0; i < fetchedAtms.length; ++i) {
      if (atm.fullId === fetchedAtms[i].fullId) {
        break;
      }
    }

    if (i === fetchedAtms.length) {
      removed.push(atm);
    }
  }

  return {
    added,
    removed,
  };
}
