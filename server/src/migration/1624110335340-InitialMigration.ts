import { MigrationInterface, QueryRunner } from "typeorm";

export class InitialMigration1624110335340 implements MigrationInterface {
  name = "InitialMigration1624110335340";

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(
      `CREATE TABLE "atm" ("id" character varying NOT NULL, "bank" character varying NOT NULL, "name" character varying NOT NULL, "latitude" double precision NOT NULL, "fullAddress" character varying NOT NULL, "longitude" double precision NOT NULL, "address" character varying NOT NULL, "postalCode" character varying NOT NULL, "municipality" character varying NOT NULL, "prefecture" character varying NOT NULL, "isOffsite" boolean NOT NULL, "hasWifi" boolean NOT NULL, "workingHours" character varying NOT NULL, CONSTRAINT "PK_1af4b3f6ac2967d793fcec916a6" PRIMARY KEY ("id"))`
    );

    await queryRunner.query(
      `CREATE INDEX "IDX_2a7732ffeba22ea10602fcfa17" ON "atm" ("bank")`
    );
    await queryRunner.query(
      `CREATE UNIQUE INDEX "IDX_0f5d16b6a144bbdd4d2fa2fd47" ON "atm" ("id", "bank")`
    );
    await queryRunner.query(
      `CREATE INDEX "IDX_FULL_ADDRESS_TSVECTOR" ON "atm" USING GIN (to_tsvector('greek', "fullAddress")) `
    );
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`DROP INDEX "IDX_0f5d16b6a144bbdd4d2fa2fd47"`);
    await queryRunner.query(`DROP INDEX "IDX_2a7732ffeba22ea10602fcfa17"`);
    await queryRunner.query(`DROP INDEX "IDX_FULL_ADDRESS_TSVECTOR"`);

    await queryRunner.query(`DROP TABLE "atm"`);
  }
}
