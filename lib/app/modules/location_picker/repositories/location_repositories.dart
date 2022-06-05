import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../models/auto_complete_prediction.dart';
import '../../../models/place_detail.dart';

class LocationRepository {
  static final dio = Dio();

  static Future<List<AutoCompletePrediction>> loadAutoCompletePlaces(
    String input
  ) async {
    try {
      List<AutoCompletePrediction> result = [];
      final Dio dio = Dio();
      final url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=AIzaSyDGd41yxKVjMu9Zz6yGjJE-LGFX5wZFtDs&language=id&region=ID';
      final response = await dio.get(url);
      if (
        response.data['predictions'] != null &&
        ((response.data['predictions'] as List<dynamic>).isNotEmpty)
      ) {
        result = autoCompletePredictionFromJson(
          jsonEncode(response.data['predictions'])
        );
      }
      return result;
    } catch (error) {
      rethrow;
    }
  }

  static Future<PlaceDetail> loadPlaceDetailByPlaceId(String placeId) async {
    try {
      late PlaceDetail result;
      final Dio dio = Dio();
      final url = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&language=id&region=ID&key=AIzaSyDGd41yxKVjMu9Zz6yGjJE-LGFX5wZFtDs';
      final response = await dio.get(url);
      if (response.data['result'] != null) {
        result = placeDetailFromJson(jsonEncode(response.data['result']));
      }
      return result;
    } catch (error) {
      rethrow;
    }
  }

  static Future<PlaceDetail> loadPlaceDetailByLatLng(
    double lat,
    double lng,
  ) async {
    try {
      late PlaceDetail result;
      final Dio dio = Dio();
      final url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&language=id&region=ID&key=AIzaSyDGd41yxKVjMu9Zz6yGjJE-LGFX5wZFtDs';
      print(url);
      final response = await dio.get(url);
      if (response.data['results'] != null) {
        result = placeDetailFromJson(jsonEncode(response.data['results'][0]));
      }
      return result;
    } catch (error) {
      rethrow;
    }
  }
}
