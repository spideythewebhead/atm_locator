import 'package:app/responses/atms_response.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'http.g.dart';

@RestApi()
abstract class AppClientHttp {
  factory AppClientHttp(Dio dio, {String baseUrl}) = _AppClientHttp;

  @POST("/api/v0/atm/list-by-address")
  Future<AtmsResponse> getAtmsByAddress(@Body() Map<String, dynamic> body);

  @POST("/api/v0/atm/list-by-location")
  Future<AtmsResponse> getAtmsByLocation(@Body() Map<String, dynamic> body);
}
