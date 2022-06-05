import 'package:attendance_app/app/modules/location_master/controllers/location_master_form_controller.dart';
import 'package:attendance_app/app/widgets/map_view.dart';
import 'package:attendance_app/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nx_flutter_ui_starter_pack/nx_flutter_ui_starter_pack.dart';

import '../../../models/place_detail.dart';
import '../../location_picker/views/location_picker_view.dart';

class LocationMasterFormView extends GetView<LocationMasterFormController> {
  const LocationMasterFormView({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    controller.init();

    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text('Location Form'),
            elevation: 0,
          ),
          body: Column(
            children: [
              Expanded(
                child: _buildForm(),
              ),
              _buildButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Obx(() => NxTextFieldBox(
          textHint: 'Location Name',
          backgroundColor: Colors.grey.withOpacity(0.1),
          borderColor: Colors.transparent,
          fontSize: 14,
          padding: 12,
          controller: TextEditingController()
              ..text = controller.locationName.value ?? ''
              ..selection = TextSelection.collapsed(offset: controller.locationName.value?.length ?? 0)
        )),
        SizedBox(height: 16),
        _buildLocationPicker(),
      ],
    );
  }

  Widget _buildLocationPicker() {
    return NxBox(
      borderColor: Colors.grey[200],
      borderRadius: 8,
      onPressed: () async {
        var result = await Get.to(() => LocationPickerView());
        print('result: $result');
        if(result != null) {
          controller.location.value = result as PlaceDetail;
          controller.locationName.value = controller.location.value?.name ?? '';
        }
      },
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.place, color: Colors.grey),
                    SizedBox(width: 8),
                    NxText(
                      'Pick Location',
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                ),
                Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
          Obx(() {
            if(controller.location.value != null) {
              return NxBox(
                color: AppColors.background,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: Get.width,
                      height: 200,
                      child: MapView(
                        currentLat: controller.location.value?.geometry?.location?.lat,
                        currentLng: controller.location.value?.geometry?.location?.lng,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          NxText.body1(controller.location.value?.formattedAddress ?? ''),
                          SizedBox(height: 8),
                          NxText.small1(
                            '${controller.location.value?.geometry?.location?.lat}, ${controller.location.value?.geometry?.location?.lng}',
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return SizedBox.shrink();
            }
          })
        ],
      ),
    );
  }

  Widget _buildButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: NxButton.primary(
        onPressed: controller.saveLocation,
        child: NxText('Save Location', color: Colors.white),
      ),
    );
  }
}