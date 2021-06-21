import 'package:app/http.dart';
import 'package:app/models/atm.dart';
import 'package:app/responses/atms_response.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:dio/dio.dart';

class MainBloc {
  final AppClientHttp _http;

  final _atmsController = BehaviorSubject<List<ATM>>();
  Stream<List<ATM>> get atmsStream => _atmsController;

  MainBloc(this._http);

  Future<AtmsResponse> searchWithAddress(String address) async {
    try {
      final response = await _http.getAtmsByAddress({
        'bank': 'piraeus',
        'address': address,
        'limit': 15,
      });

      return response;
    } on DioError catch (ex) {}

    return AtmsResponse(ok: false);
  }

  Future<bool> searchWithLocation(LatLng location, double radius) async {
    try {
      print('$location $radius');
      final response = await _http.getAtmsByLocation({
        'bank': 'piraeus',
        'location': {
          'lat': location.latitude,
          'lng': location.longitude,
        },
        'radius': radius.toInt(),
      });

      if (response.ok && response.data != null) {
        _atmsController.value = response.data!;
      }

      return response.ok;
    } on DioError catch (ex) {
      print(ex);
    }

    return false;
  }

  void publishAtms(List<ATM> atms) {
    _atmsController.value = [...atms];
  }

  void dispose() {
    _atmsController.close();
  }
}
