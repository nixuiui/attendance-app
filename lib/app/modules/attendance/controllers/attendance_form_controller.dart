import 'package:attendance_app/app/models/attendance.dart';
import 'package:attendance_app/app/models/location_data.dart';
import 'package:attendance_app/app/models/place_detail.dart';
import 'package:attendance_app/app/modules/attendance/controllers/attendance_controller.dart';
import 'package:attendance_app/app/modules/location_picker/repositories/location_repositories.dart';
import 'package:attendance_app/helpers/location_helper.dart';
import 'package:attendance_app/services/local_storage_service.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AttendanceFormController extends GetxController {
  final TAG = 'AttendanceFormController';
  static AttendanceFormController get to => Get.find();

  final localStorageService = Get.find<LocalStorageService>();

  final currectLocation = Rx<LatLng?>(null);
  final clock = Rx<String?>(null);
  final place = Rx<PlaceDetail?>(null);
  final nearLocation = Rx<LocationData?>(null);

  init() async {
    clock.value = Get.arguments['clock'];
    await setCurrentLocation();
    nearLocation.value = getNearLocation();
    await loadPlaceDetail();
  }

  Future setCurrentLocation() async {
    currectLocation.value = await getCurrentLocation();
  }

  loadPlaceDetail() async {
    place.value = await LocationRepository.loadPlaceDetailByLatLng(
      currectLocation.value?.latitude ?? 0,
      currectLocation.value?.longitude ?? 0,
    );
  }

  saveAttendance() async {
    var attendance = Attendance(
      clock: clock.value,
      datetime: DateTime.now(),
      note: '',
      latitude: currectLocation.value?.latitude,
      longitude: currectLocation.value?.longitude,
      address: place.value?.formattedAddress,
    );
    await localStorageService.addAttendances(attendance);
    AttendanceController.to.updateData();
    Get.back();
  }

  LocationData? getNearLocation() {
    var lat = currectLocation.value?.latitude;
    var lng = currectLocation.value?.longitude;
    var result = localStorageService.locationData;
    var nearLocation = result.firstWhereOrNull((e) {
      var distance = calculateLocationDistance(
        lat1: lat,
        lng1: lng,
        lat2: e.latitude,
        lng2: e.longitude,
      );
      print('distance: ${e.locationName}');
      print('distance: $lat, $lng <==> ${e.latitude}, ${e.longitude}');
      print('distance: $distance -> ${e.locationName} $lat, $lng');
      return distance <= 50;
    });
    print('distance: ${nearLocation?.toJson()}');
    return nearLocation;
  }
  
}
