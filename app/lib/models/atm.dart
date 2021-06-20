import 'package:json_annotation/json_annotation.dart';

part 'atm.g.dart';

@JsonSerializable()
class ATM {
  final String bank;
  final String name;
  final String fullAddress;

  final double latitude;
  final double longitude;

  final bool isOffsite;
  final bool hasWifi;

  final String workingHours;

  ATM(
    this.bank,
    this.name,
    this.fullAddress,
    this.latitude,
    this.longitude,
    this.isOffsite,
    this.hasWifi,
    this.workingHours,
  );

  factory ATM.fromJson(Map<String, dynamic> json) => _$ATMFromJson(json);

  Map<String, dynamic> toJson() => _$ATMToJson(this);
}
