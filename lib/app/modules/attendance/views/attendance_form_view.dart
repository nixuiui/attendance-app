import 'package:attendance_app/app/modules/attendance/controllers/attendance_form_controller.dart';
import 'package:attendance_app/app/widgets/map_view.dart';
import 'package:attendance_app/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nx_flutter_ui_starter_pack/nx_flutter_ui_starter_pack.dart';

class AttendanceFormView extends GetView<AttendanceFormController> {
  const AttendanceFormView({ Key? key }) : super(key: key);

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
        body: Column(
          children: [
            Expanded(
              child: _buildContent(),
            ),
            _buildButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return ListView(
      children: [
        SizedBox(
          width: Get.width,
          height: 200,
          child: Obx(() => controller.currectLocation.value != null ? MapView(
            currentLat: controller.currectLocation.value?.latitude,
            currentLng: controller.currectLocation.value?.longitude,
          ) : NxLoadingSpinner()),
        ),
        Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.schedule,
                    size: 16,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 8),
                  NxText.body2(DateFormat('y-MM-dd H:m', 'id').format(DateTime.now())),
                ],
              ),
              SizedBox(height: 16),
              Obx(() => NxText.body1(controller.place.value?.formattedAddress ?? '')),
              SizedBox(height: 4),
              Obx(() => controller.place.value != null ? NxText.small1(
                '${controller.place.value?.geometry?.location?.lat}, ${controller.place.value?.geometry?.location?.lng}',
                color: Colors.grey,
              ) : SizedBox.shrink()),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Obx(() => NxBox(
            padding: const EdgeInsets.all(16.0),
            margin: EdgeInsets.only(bottom: 16),
            borderRadius: 8,
            color: controller.nearLocation.value != null 
                ? AppColors.secondary.withOpacity(0.4)
                : Colors.red.withOpacity(0.1),
            child: Row(
              children: [
                controller.nearLocation.value != null 
                    ? Icon(
                        Icons.check_circle,
                        color: Colors.grey,
                        size: 16,
                      )
                    : Icon(
                        Icons.cancel,
                        color: Colors.red.withOpacity(0.5),
                        size: 16,
                      ),
                SizedBox(width: 8),
                NxText(
                  controller.nearLocation.value != null 
                      ? 'Your location near by ${controller.nearLocation.value?.locationName}'
                      : 'Your location is out off location',
                  color: controller.nearLocation.value != null ? Colors.grey : Colors.red.withOpacity(0.5)
                ),
              ],
            ),
          )),
          Obx(() => NxButton.primary(
            onPressed: controller.nearLocation.value != null ? () => controller.saveAttendance() : null,
            child: NxText('CLOCK ${controller.clock.value?.toUpperCase()}', color: Colors.white),
          )),
        ],
      ),
    );
  }
}