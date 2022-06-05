import 'dart:developer';

import 'package:attendance_app/app/models/location_data.dart';
import 'package:attendance_app/app/models/place_detail.dart';
import 'package:attendance_app/app/modules/location_master/controllers/location_master_controller.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../services/local_storage_service.dart';

class LocationMasterFormController extends GetxController {
  final TAG = "LocationMasterFormController";
  static LocationMasterFormController get to => Get.find();

  final locationStorageService = Get.find<LocalStorageService>();
  final locationName = Rx<String?>(null);
  final locationLatLng = Rx<LatLng?>(null);
  final locationAddress = Rx<String?>(null);

  var index = -1;
  final isUpdate = RxBool(false);
  final isFormValid = RxBool(false);

  init() async {
    if(Get.arguments != null) {
      index = Get.arguments['index'];
      var locData = locationStorageService.locationData;
      if(locData.isNotEmpty) {
        isUpdate.value = true;
        locationName.value = locData[index].locationName;
        locationAddress.value = locData[index].address;
        locationLatLng.value = LatLng(
          locData[index].latitude ?? 0, 
          locData[index].longitude ?? 0
        );
      }
    }
    log('$TAG::init()');
  }

  updateLocationInfo(PlaceDetail place) {
    locationName.value = place.name ?? 'Undefined Location';
    locationAddress.value = place.formattedAddress;
    locationLatLng.value = LatLng(
      place.geometry!.location!.lat!, 
      place.geometry!.location!.lat!
    );
    isValid();
  }

  isValid() {
    isFormValid.value = true;
    
    if(locationName.value == null || locationName.value == '') {
      log('1');
      isFormValid.value = false;
    }
    
    if(locationLatLng.value == null) {
      log('2');
      isFormValid.value = false;
    }
    
    if(locationAddress.value == null) {
      log('3');
      isFormValid.value = false;
    }

  }

  Future saveLocation() async {
    try {
      var locationData = LocationData(
        locationName: locationName.value,
        address: locationAddress.value,
        latitude: locationLatLng.value?.latitude,
        longitude: locationLatLng.value?.longitude,
      );
      if(isUpdate.value) {
        var locData = locationStorageService.locationData;
        locData[index] = locationData;
        await locationStorageService.setLocationData(locData);
      } else {
        await locationStorageService.addLocationData(locationData);
      }
      LocationMasterController.to.updateData();
      Get.back();
    } catch (e) {
      log('$TAG::saveLocation()->exception: $e');
    }
  }
  
}
