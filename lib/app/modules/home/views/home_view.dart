import 'package:attendance_app/app/modules/home/controllers/home_controller.dart';
import 'package:attendance_app/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nx_flutter_ui_starter_pack/nx_flutter_ui_starter_pack.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          centerTitle: true,
          title: NxText.headline4('Attendance App'),
        ),
        body: ListView(
          padding: EdgeInsets.all(16),
          children: [
            NxBox(
              borderRadius: 8,
              padding: EdgeInsets.all(16),
              color: AppColors.primaryDark,
              child: Column(
                children: [
                  Icon(
                    Icons.place, 
                    color: AppColors.primary,
                    size: 40,
                  ),
                  SizedBox(height: 16),
                  NxText(
                    'LOCATION MASTER',
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            NxBox(
              borderRadius: 8,
              padding: EdgeInsets.all(16),
              color: AppColors.secondaryDark,
              child: Column(
                children: [
                  Icon(
                    Icons.checklist, 
                    color: AppColors.secondary,
                    size: 40,
                  ),
                  SizedBox(height: 16),
                  NxText(
                    'ATTENDANCE',
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}