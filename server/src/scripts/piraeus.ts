import { ATM, Bank } from "../entity/atm";
import fetch from "node-fetch";
import { differencesBetweenATMS } from "./differences";

export const Piraeus = {
  execute,
};

const piraeusEndpoint =
  "https://api.rapidlink.piraeusbank.gr/piraeusbank/production/v1.2/info/pointsOfPresence";

interface PiraeusATM {
  Name: string;
  Longitude: number;
  Latitude: number;
  Prefecture: string;
  Municipality: string;
  Address: string;
  PostalCode: string;
  Telephone: string;
  WorkingHours: string;
  Id: number;
  Status: string;
}

// returns an object with 2 arrays containing
// added: new additions not found in the db
// removed: db entries not found in the fetched atms
async function execute(): Promise<ReturnType<typeof differencesBetweenATMS>> {
  const [queryResult, requestResult] = await Promise.allSettled([
    ATM.find({
      where: {
        bank: Bank.piraeus,
      },
    }),
    fetchATMSFromApi(),
  ]);

  if (
    queryResult.status === "rejected" ||
    requestResult.status === "rejected"
  ) {
    return {
      added: [],
      removed: [],
    };
  }

  return differencesBetweenATMS(requestResult.value, queryResult.value);
}

// fetches the atms from piraeus api
// then normalizes the data from the api to our application atm model
function fetchATMSFromApi(): Promise<ATM[] | never[]> {
  return fetch(piraeusEndpoint, {
    headers: {
      accept: "application/json",
      "x-ibm-client-id": process.env.PIRAEUS_CLIENT_ID as string,
    },
    method: "GET",
  })
    .then((response) => {
      if (response.ok) return response.json();

      throw response;
    })
    .then((data: { POPs: PiraeusATM[] }) => {
      const normalizedATMS: ATM[] = data.POPs.map((atm) => {
        const statuses = (atm.Status ?? "").split(",");

        const mapped = new ATM();

        mapped.id = `${atm.Id}`;
        mapped.latitude = atm.Latitude;
        mapped.longitude = atm.Longitude;
        mapped.name = atm.Name;
        mapped.bank = Bank.piraeus;
        mapped.prefecture = atm.Prefecture;
        mapped.municipality = atm.Municipality;
        mapped.address = atm.Address;
        mapped.postalCode = atm.PostalCode;
        mapped.fullAddress =
          `${atm.Address} ${atm.Municipality} ${atm.PostalCode} ${atm.Prefecture}`.replace(
            /\s{2,}/g,
            " "
          );
        mapped.hasWifi = statuses.includes("FreeWiFiATM");
        mapped.isOffsite = statuses.includes("Offsite");
        mapped.workingHours = statuses.includes("AllHoursAccess")
          ? "24_7"
          : "working_hours";

        return mapped;
      });

      return normalizedATMS;
    })
    .catch((e) => {
      console.error(e);
      return [];
    });
}
