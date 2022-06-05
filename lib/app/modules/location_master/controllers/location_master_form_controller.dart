import 'dart:developer';

import 'package:attendance_app/app/models/location_data.dart';
import 'package:attendance_app/app/modules/location_master/controllers/location_master_controller.dart';
import 'package:get/get.dart';

import '../../../../services/local_storage_service.dart';
import '../../../models/place_detail.dart';

class LocationMasterFormController extends GetxController {
  final TAG = "LocationMasterFormController";
  static LocationMasterFormController get to => Get.find();

  final locationStorageService = Get.find<LocalStorageService>();
  final locationName = Rx<String?>(null);
  final location = Rx<PlaceDetail?>(null);

  init() async {
    log('$TAG::init()');
  }

  Future saveLocation() async {
    try {
      var locationData = LocationData(
        locationName: locationName.value,
        address: location.value?.formattedAddress ?? '',
        latitude: location.value?.geometry?.location?.lat,
        longitude: location.value?.geometry?.location?.lng,
      );
      await locationStorageService.addLocationData(locationData);
      LocationMasterController.to.updateData();
      Get.back();
    } catch (e) {
      log('$TAG::saveLocation()->exception: $e');
    }
  }
  
}
