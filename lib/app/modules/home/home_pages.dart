import 'package:get/get.dart';

import '../../routes/app_pages.dart';
import 'bindings/home_binding.dart';
import 'views/home_view.dart';


final homePages = [
  GetPage(
    name: Routes.home,
    page: () => HomeView(),
    binding: HomeBinding(),
    participatesInRootNavigator: true,
    preventDuplicates: true,
  ),
];