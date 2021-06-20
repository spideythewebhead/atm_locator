import 'package:app/models/atm.dart';
import 'package:json_annotation/json_annotation.dart';

part 'atms_response.g.dart';

@JsonSerializable()
class AtmsResponse {
  final bool ok;
  final List<ATM>? data;
  final String? error;

  AtmsResponse({
    required this.ok,
    this.data,
    this.error,
  });

  factory AtmsResponse.fromJson(Map<String, dynamic> json) => _$AtmsResponseFromJson(json);

  // Map<String, dynamic> toJson() => _$AtmsResponseToJson(this);
}
