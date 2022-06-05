import 'package:get/get.dart';

import '../controllers/location_master_controller.dart';

class LocationMasterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LocationMasterController>(
      () => LocationMasterController(),
    );
  }
}
