import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class SplashController extends GetxController {
  static SplashController get to => Get.find();

  final version = ''.obs;

  init() async {
    await Future.delayed(Duration(seconds: 2));
    Get.offNamed(Routes.example);
  }

}
