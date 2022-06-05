import 'package:attendance_app/app/modules/location_master/controllers/location_master_form_controller.dart';
import 'package:attendance_app/app/widgets/map_view.dart';
import 'package:attendance_app/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
              ..selection = TextSelection.collapsed(offset: controller.locationName.value?.length ?? 0),
          onChanged: (val) {
            controller.locationName.value = val;
            controller.isValid();
          },
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
        LatLng? initialPosition = controller.locationLatLng.value == null 
            ? null 
            : LatLng(
                controller.locationLatLng.value!.latitude, 
                controller.locationLatLng.value!.longitude
              );
        var result = await Get.to(() => LocationPickerView(
          initialPosition: initialPosition,
          useCurrentLocation: initialPosition == null,
        ));
        print('result: $result');
        if(result != null) {
          final place = result as PlaceDetail;
          controller.updateLocationInfo(place);
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
            if(controller.locationAddress.value != null) {
              return NxBox(
                color: AppColors.background,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: Get.width,
                      height: 200,
                      child: MapView(
                        currentLat: controller.locationLatLng.value?.latitude,
                        currentLng: controller.locationLatLng.value?.longitude,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          NxText.body1(controller.locationAddress.value ?? ''),
                          SizedBox(height: 8),
                          NxText.small1(
                            '${controller.locationLatLng.value?.latitude}, ${controller.locationLatLng.value?.longitude}',
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
      child: Obx(() => NxButton.primary(
        onPressed: controller.isFormValid.value ? () => controller.saveLocation() : null,
        child: NxText('Save Location', color: Colors.white),
      )),
    );
  }
}