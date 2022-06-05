import 'package:get/get.dart';

import '../../routes/app_pages.dart';
import 'bindings/example_binding.dart';
import 'views/example_view.dart';


final examplePages = [
  GetPage(
    name: Routes.example,
    page: () => ExampleView(),
    binding: ExampleBinding(),
    participatesInRootNavigator: true,
    preventDuplicates: true,
  ),
];