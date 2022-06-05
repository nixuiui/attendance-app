import 'package:attendance_app/app/models/location_data.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../app/models/place_detail.dart';

class LocalStorageKeys {
  static const String locationData = 'location_data';
  static const String placeHistory = 'place_history';
}

class LocalStorageService extends GetxService{
  static LocalStorageService get to => Get.find();

  late GetStorage box;

  LocalStorageService() : box = GetStorage();
  
  List<LocationData>? get locationData {
    final locationData = box.read<String>(LocalStorageKeys.locationData);
    if(locationData != null) {
      return locationDataFromJson(locationData);
    }
    return null;
  }

  Future setLocationData(List<LocationData>? data) async {
    await box.write(LocalStorageKeys.locationData, locationDataToJson(data ?? []));
  }
  
  Future addLocationData(LocationData data) async {
    var baseData = locationData ?? [];
    baseData.add(data);
    await box.write(LocalStorageKeys.locationData, locationDataToJson(baseData));
  }

  List<PlaceDetail>? get placeHistory {
    final placeHistory = box.read<String>(LocalStorageKeys.placeHistory);
    if(placeHistory != null) {
      return placeDetailsFromJson(placeHistory);
    }
    return null;
  }

  Future setPlaceHistory(List<PlaceDetail>? data) async {
    await box.write(LocalStorageKeys.placeHistory, placeDetailsToJson(data ?? []));
  }

}
