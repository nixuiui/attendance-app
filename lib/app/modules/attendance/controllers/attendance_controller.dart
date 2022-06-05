import 'dart:developer';

import 'package:attendance_app/app/models/attendance.dart';
import 'package:attendance_app/services/local_storage_service.dart';
import 'package:get/get.dart';

class AttendanceController extends GetxController {
  final TAG = 'AttendanceController';
  static AttendanceController get to => Get.find();

  final localStorageService = Get.find<LocalStorageService>();

  final attendances = RxList<Attendance>([]);

  init() async {
    updateData();
  }

  updateData() {
    var data = localStorageService.attendances;
    attendances.value = data.where((e) {
      var now = DateTime.now();
      return  e.datetime?.year == now.year &&
              e.datetime?.month == now.month &&
              e.datetime?.day == now.day;
    }).toList();
    log('$TAG::updateData()');
  }
  
}
