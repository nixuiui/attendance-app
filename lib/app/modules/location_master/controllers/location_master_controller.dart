import 'package:attendance_app/app/models/location_data.dart';
import 'package:get/get.dart';

import '../../../../services/local_storage_service.dart';

class LocationMasterController extends GetxController {
  final TAG = "LocationMasterController";
  static LocationMasterController get to => Get.find();

  final locationStorageService = Get.find<LocalStorageService>();
  final locationMasterData = RxList<LocationData>([]);

  init() async {
    locationMasterData.value = await locationStorageService.locationData ?? [];
    print('$TAG::init()');
  }
  
}
