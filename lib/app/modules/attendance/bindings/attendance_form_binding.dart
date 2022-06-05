import 'package:get/get.dart';

import '../controllers/attendance_form_controller.dart';

class AttendanceFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AttendanceFormController>(
      () => AttendanceFormController(),
    );
  }
}
