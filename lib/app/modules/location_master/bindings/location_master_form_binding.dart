import 'package:get/get.dart';

import '../controllers/location_master_form_controller.dart';

class LocationMasterFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LocationMasterFormController>(
      () => LocationMasterFormController(),
    );
  }
}
