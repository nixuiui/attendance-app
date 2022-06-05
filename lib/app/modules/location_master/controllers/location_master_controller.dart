import 'dart:developer';

import 'package:attendance_app/app/models/location_data.dart';
import 'package:get/get.dart';

import '../../../../services/local_storage_service.dart';

class LocationMasterController extends GetxController {
  final TAG = "LocationMasterController";
  static LocationMasterController get to => Get.find();

  final locationStorageService = Get.find<LocalStorageService>();
  final locationMasterData = RxList<LocationData>([]);

  init() async {
    locationMasterData.value = locationStorageService.locationData;
    log('$TAG::init()');
  }

  Future updateData() async {
    locationMasterData.value = locationStorageService.locationData;
    log('$TAG::updateData() -> ${locationMasterData.length}');
  }
  
  Future deleteData(index) async {
    locationMasterData.removeAt(index);
    await locationStorageService.setLocationData(locationMasterData);
    log('$TAG::updateData() -> ${locationMasterData.length}');
  }
  
}
