import 'package:app/env_config.dart';
import 'package:app/models/atm.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'http.g.dart';

@RestApi(baseUrl: '${EnvConfig.baseUrl}/api')
abstract class AppClientHttp {
  factory AppClientHttp(Dio dio, {String baseUrl}) = _AppClientHttp;

  @POST("/v0/atm/list-by-address")
  Future<List<ATM>> getAtmsByAddress(@Body() Map<String, dynamic> body);

  @POST("/v0/atm/list-by-location")
  Future<List<ATM>> getAtmsByLocation(@Body() Map<String, dynamic> body);
}
