import { BaseEntity, Column, Entity, Index, PrimaryColumn } from "typeorm";

enum StatusCondition {
  yes,
  no,
  unknown,
}

enum Bank {
  piraeus,
  national,
  alpha,
}

@Entity()
@Index(["id", "bank"], { unique: true })
@Index(["bank"])
export class ATM extends BaseEntity {
  @PrimaryColumn({
    nullable: false,
  })
  id!: string;

  @Column({
    type: "enum",
    enum: Bank,
  })
  bank!: Bank;

  @Column()
  name!: string;

  @Column()
  latitude!: number;

  @Column()
  longitude!: number;

  @Column()
  address!: string;

  @Column()
  postalCode!: string;

  @Column()
  municipality!: string;

  @Column()
  prefecture!: string;

  @Column({
    type: "enum",
    enum: StatusCondition,
    default: StatusCondition.unknown,
  })
  isOffsite!: boolean;

  @Column({
    type: "enum",
    enum: StatusCondition,
    default: StatusCondition.unknown,
  })
  hasWifi!: boolean;

  @Column()
  workingHours?: string;
}
