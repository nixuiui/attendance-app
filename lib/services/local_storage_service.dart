import 'package:attendance_app/app/models/attendance.dart';
import 'package:attendance_app/app/models/location_data.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../app/models/place_detail.dart';

class LocalStorageKeys {
  static const String locationData = 'location_data';
  static const String placeHistory = 'place_history';
  static const String attendances = 'attendances';
}

class LocalStorageService extends GetxService{
  static LocalStorageService get to => Get.find();

  late GetStorage box;

  LocalStorageService() : box = GetStorage();
  
  List<LocationData> get locationData {
    final locationData = box.read<String>(LocalStorageKeys.locationData);
    if(locationData != null) {
      return locationDataFromJson(locationData);
    }
    return [];
  }

  Future setLocationData(List<LocationData>? data) async {
    await box.write(LocalStorageKeys.locationData, locationDataToJson(data ?? []));
  }
  
  Future addLocationData(LocationData data) async {
    var baseData = locationData;
    baseData.insert(0, data);
    await box.write(LocalStorageKeys.locationData, locationDataToJson(baseData));
  }
  
  List<Attendance> get attendances {
    final attendances = box.read<String>(LocalStorageKeys.attendances);
    if(attendances != null) {
      return attendanceFromJson(attendances);
    }
    return [];
  }

  Future setAttendance(List<Attendance>? data) async {
    await box.write(LocalStorageKeys.attendances, attendanceToJson(data ?? []));
  }
  
  Future addAttendances(Attendance data) async {
    var baseData = attendances;
    baseData.insert(0, data);
    await box.write(LocalStorageKeys.attendances, attendanceToJson(baseData));
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
