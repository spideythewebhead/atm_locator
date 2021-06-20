import 'package:app/http.dart';
import 'package:app/models/atm.dart';
import 'package:app/responses/atms_response.dart';
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

  void dispose() {
    _atmsController.close();
  }
}
