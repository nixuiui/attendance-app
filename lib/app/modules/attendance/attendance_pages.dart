import 'package:attendance_app/app/modules/attendance/bindings/attendance_binding.dart';
import 'package:attendance_app/app/modules/attendance/bindings/attendance_form_binding.dart';
import 'package:attendance_app/app/modules/attendance/views/attendance_form_view.dart';
import 'package:attendance_app/app/modules/attendance/views/attendance_view.dart';
import 'package:get/get.dart';

import '../../routes/app_pages.dart';

final attendancePages = [
  GetPage(
    name: Routes.attendance,
    page: () => AttendanceView(),
    binding: AttendanceBinding(),
    participatesInRootNavigator: true,
    preventDuplicates: true,
  ),
  GetPage(
    name: Routes.attendanceForm,
    page: () => AttendanceFormView(),
    binding: AttendanceFormBinding(),
    participatesInRootNavigator: true,
    preventDuplicates: true,
  ),
];