import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app/routes/app_pages.dart';
import 'resources/colors.dart';
import 'services/local_storage_service.dart';

void main() async {
  
  await GetStorage.init();
  initializeDateFormatting();
  
  runApp(
    GetMaterialApp(
      theme: ThemeData(
        fontFamily: 'Poppins',
        primaryColor: AppColors.primary,
        errorColor: AppColors.error, 
        backgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(
            color: AppColors.primary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          iconTheme: IconThemeData(
            color: AppColors.primary,
          ),
          elevation: 1,
        ),
        dividerTheme: DividerThemeData(
          thickness: 0,
          space: 0
        ),
        dividerColor: Colors.grey[400],
      ),
      title: "ERP31",
      initialBinding: BindingsBuilder(
        () {
          Get.put(LocalStorageService());
        },
      ),
      getPages: AppPages.routes,
      initialRoute: AppPages.initial,
    ),
  );
}
