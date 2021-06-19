import type { App, Request, Response } from "@tinyhttp/app";
import { validationResult, check } from "express-validator";
import { getConnection, getManager } from "typeorm";
import { ATM, Bank } from "../../entity/atm";

const GET_ATMS_VALIDATOR = [
  check("bank", "Must be one of: 'national' | 'piraeus'")
    .isString()
    .isIn(["piraeus", "national"])
    .exists({ checkNull: true }),
  check("address").isString().isLength({ min: 3 }),
  check("limit", "Limit max be between 5 and 15 (inclusive)")
    .isInt({
      min: 5,
      max: 15,
    })
    .default(5)
    .optional({ nullable: true }),
];

export function registerATM_V0(server: App) {
  server.route("/api/v0/atm").post("/list", GET_ATMS_VALIDATOR, getAtms);
}

async function getAtms(req: Request, res: Response) {
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
