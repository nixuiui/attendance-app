import 'package:attendance_app/app/modules/attendance/controllers/attendance_controller.dart';
import 'package:attendance_app/app/routes/app_pages.dart';
import 'package:attendance_app/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nx_flutter_ui_starter_pack/nx_flutter_ui_starter_pack.dart';

class AttendanceView extends GetView<AttendanceController> {
  const AttendanceView({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    controller.init();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryDark,
          iconTheme: IconThemeData(
            color: Colors.white
          ),
          elevation: 0,
          title: NxText(
            'Attendance',
            color: Colors.white,
          ),
        ),
        body: ListView(
          children: [
            _buildHeader(),
            _buildLogsToday()
          ],
        ),
      ),
    );
  }

  Widget _buildLogsToday() {
    return ListView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      padding: EdgeInsets.all(16),
      children: [
        NxText.headline5('Logs Today'),
        Obx(() => controller.attendances.isNotEmpty ? ListView.separated(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: controller.attendances.length,
          separatorBuilder: (_, __) => Divider(), 
          itemBuilder: (_, index) => Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                NxText.body1(controller.attendances[index].clock == 'in' ? 'Clock In' : 'Clock Out'),
                NxText.body1(DateFormat('H:m', 'id').format(controller.attendances[index].datetime!)),
              ],
            ),
          ),
        ) : Padding(
          padding: EdgeInsets.symmetric(vertical: 32),
          child: Center(
            child: NxText(
              'No Attendance Today',
              color: Colors.grey,
            )
          ),
        )),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      color: AppColors.primaryDark,
      padding: EdgeInsets.all(16.0),
      child: NxBox(
        color: Colors.white,
        borderRadius: 8,
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            NxText.small1(
              DateFormat('dd-MM-y', 'id').format(DateTime.now()),
              color: Colors.grey,
            ),
            SizedBox(height: 4),
            NxText.headline4(DateFormat('H:m', 'id').format(DateTime.now())),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: NxButton.primary(
                    onPressed: () => Get.toNamed(
                      Routes.attendanceForm,
                      arguments: {
                        'clock': 'in'
                      }
                    ),
                    child: Text('Clock In'),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: NxButton.accent(
                    onPressed: () => Get.toNamed(
                      Routes.attendanceForm,
                      arguments: {
                        'clock': 'out'
                      }
                    ),
                    child: Text('Clock Out'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}