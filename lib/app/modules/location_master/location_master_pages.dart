import 'package:get/get.dart';

import '../../routes/app_pages.dart';
import 'bindings/location_master_form_binding.dart';
import 'bindings/location_master_binding.dart';
import 'views/location_master_form_view.dart';
import 'views/location_master_view.dart';


final locationMasterPages = [
  GetPage(
    name: Routes.locationMaster,
    page: () => LocationMasterView(),
    binding: LocationMasterBinding(),
    participatesInRootNavigator: true,
    preventDuplicates: true,
  ),
  GetPage(
    name: Routes.locationMasterForm,
    page: () => LocationMasterFormView(),
    binding: LocationMasterFormBinding(),
    participatesInRootNavigator: true,
    preventDuplicates: true,
  ),
];