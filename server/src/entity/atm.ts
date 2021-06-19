import { BaseEntity, Column, Entity, Index, PrimaryColumn } from "typeorm";
import { LatLng } from "../compute-distance-between";

export const enum Bank {
  piraeus = "piraeus",
  national = "national",
  alpha = "alpha",
}

@Entity()
@Index(["id", "bank"], { unique: true })
@Index(["bank"])
export class ATM extends BaseEntity {
  @PrimaryColumn({
    nullable: false,
  })
  id!: string;

  @Column()
  bank!: string;

  @Column()
  name!: string;

  @Column({
    type: "float",
  })
  latitude!: number;

  @Column()
  fullAddress!: string;

  @Column({
    type: "float",
  })
  longitude!: number;

  @Column()
  address!: string;

  @Column()
  postalCode!: string;

  @Column()
  municipality!: string;

  @Column()
  prefecture!: string;

  @Column()
  isOffsite!: boolean;

  @Column()
  hasWifi!: boolean;

  @Column()
  workingHours?: string;

  get fullId() {
    return `${this.bank}_${this.id}`;
  }

  get position(): LatLng {
    return {
      lat: this.latitude,
      lng: this.longitude,
    };
  }
}
