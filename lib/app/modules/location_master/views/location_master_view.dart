import 'package:attendance_app/app/modules/location_master/controllers/location_master_controller.dart';
import 'package:attendance_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nx_flutter_ui_starter_pack/nx_flutter_ui_starter_pack.dart';

class LocationMasterView extends GetView<LocationMasterController> {
  const LocationMasterView({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    controller.init();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Location Master'),
          elevation: 0,
        ),
        body: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.updateData,
                child: ListView(
                  children: [
                    _buildLocationList(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: NxButton.primary(
                onPressed: () => Get.toNamed(Routes.locationMasterForm),
                child: NxText('Add Location', color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLocationList() {
    return Obx(() => controller.locationMasterData.isNotEmpty ? ListView.separated(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: controller.locationMasterData.length,
      padding: EdgeInsets.all(16),
      separatorBuilder: (_, __) => SizedBox(height: 16), 
      itemBuilder: (_, index) => NxBox(
        padding: EdgeInsets.all(16),
        borderRadius: 8,
        borderColor: Colors.grey[200],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NxText.lead1(controller.locationMasterData[index].locationName ?? ''),
            NxText.body1(controller.locationMasterData[index].address ?? ''),
            SizedBox(height: 4),
            NxText.small1(
              '${controller.locationMasterData[index].latitude}, ${controller.locationMasterData[index].longitude}',
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.toNamed(
                      Routes.locationMasterForm,
                      arguments: {
                        'index': index
                      }
                    );
                  },
                  child: NxText(
                    'EDIT',
                    color: Colors.grey,
                    fontWeight: FontWeight.w700,
                  )
                ),
                SizedBox(width: 16),
                GestureDetector(
                  onTap: () => controller.deleteData(index),
                  child: NxText(
                    'DELETE',
                    color: Colors.grey,
                    fontWeight: FontWeight.w700,
                  )
                ),
              ],
            ),
          ],
        ),
      ), 
    ) : Padding(
      padding: EdgeInsets.all(32.0),
      child: Center(
        child: NxText(
          'NO LOCATION DATA',
          fontSize: 14,
          color: Colors.grey,
        )
      ),
    ));
  }
}