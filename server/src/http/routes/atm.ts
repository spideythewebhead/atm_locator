import type { App, Request, Response } from "@tinyhttp/app";
import { validationResult, check } from "express-validator";
import { computeDistanceBetween, LatLng } from "../../compute-distance-between";
import { ATM, Bank } from "../../entity/atm";

const getAtmsByAdressValidator = [
  check("bank", "Must be one of: 'national' | 'piraeus'")
    .isString()
    .isIn(["piraeus", "national"])
    .exists({ checkNull: true }),
  check("address").isString().isLength({ min: 3 }),
  check("limit", "Limit must be between 5 and 15 (inclusive)")
    .isInt({
      min: 5,
      max: 15,
    })
    .default(5)
    .optional({ nullable: true }),
];

const getAtmsByLocationValidator = [
  check("bank", "Must be one of: 'national' | 'piraeus'")
    .isString()
    .isIn(["piraeus", "national"])
    .exists({ checkNull: true }),
  check("location.lat").isFloat({ lt: 90.0, gt: -90.0 }),
  check("location.lng").isFloat({ lt: 180.0, gt: -180.0 }),
  check("radius").isInt({ min: 1, max: 30 }),
];

export function registerATM_V0(server: App) {
  server
    .route("/api/v0/atm")
    .post("/list-by-address", getAtmsByAdressValidator, getAtmsByAddress)
    .post("/list-by-location", getAtmsByLocationValidator, getAtmsByLocation);
}

async function getAtmsByAddress(req: Request, res: Response) {
  const body: {
    bank: Bank;
    address: string;
    limit: number;
  } = req.body;

  body.limit ??= 5;

  const errors = validationResult(req);

  if (!errors.isEmpty()) {
    res.send({
      ok: false,
      errors: errors.mapped(),
    });
    return;
  }

  try {
    const atms = await ATM.createQueryBuilder("atm")
      .select("atm.fullAddress")
      .addSelect("atm.latitude")
      .addSelect("atm.longitude")
      .addSelect("atm.workingHours")
      .addSelect("atm.hasWifi")
      .addSelect("atm.isOffsite")
      .where(`atm.bank = :bank`, { bank: body.bank })
      .where(
        `to_tsvector('greek', "atm"."fullAddress") @@ to_tsquery('greek', :query)`,
        {
          // replaces more than 2 whitespaces to 1
          // gets each part and replaces with part:*
          // joins with AND for seach
          query: body.address
            .replace(/\s{2,}/g, " ")
            .split(" ")
            .map((part) => `${part}:*`)
            .join(" & "),
        }
      )
      .take(body.limit)
      .getMany();

    return res.send({
      ok: true,
      data: atms,
    });
  } catch (e) {
    console.log(e);
  }

  res.send({ ok: false });
}

async function getAtmsByLocation(req: Request, res: Response) {
  const body: {
    bank: Bank;
    location: LatLng;
    radius: number;
  } = req.body;

  const errors = validationResult(req);

  if (!errors.isEmpty()) {
    res.send({
      ok: false,
      errors: errors.mapped(),
    });
    return;
  }

  try {
    let atms = await ATM.createQueryBuilder("atm")
      .select("atm.fullAddress")
      .addSelect("atm.latitude")
      .addSelect("atm.longitude")
      .addSelect("atm.workingHours")
      .addSelect("atm.hasWifi")
      .addSelect("atm.isOffsite")
      .where(`atm.bank = :bank`, { bank: body.bank })
      .getMany();

    atms = atms.filter(
      (atm) =>
        computeDistanceBetween(atm.position, body.location) <= body.radius
    );

    return res.send({
      ok: true,
      data: atms,
    });
  } catch (e) {
    console.log(e);
  }

  res.send({ ok: false });
}
