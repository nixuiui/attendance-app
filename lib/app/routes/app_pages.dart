import 'package:attendance_app/app/modules/_/example_pages.dart';
import 'package:attendance_app/app/modules/home/home_pages.dart';
import 'package:attendance_app/app/modules/location_master/location_master_pages.dart';

import '../modules/splash/splash_pages.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.splash;

  static final routes = [
    ...examplePages,
    ...splashPages,
    ...homePages,
    ...locationMasterPages,
  ];
}
