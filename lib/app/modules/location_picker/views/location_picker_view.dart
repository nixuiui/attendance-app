import 'dart:developer';

import 'package:attendance_app/helpers/location_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nx_flutter_ui_starter_pack/nx_loading_spinner.dart';

import '../../../../services/local_storage_service.dart';
import '../../../models/auto_complete_prediction.dart';
import '../../../models/place_detail.dart';
import '../repositories/location_repositories.dart';
import '../widgets/bottom_sheet_location_picker.dart';
import '../widgets/location_picker_map.dart';

class LocationPickerView extends StatefulWidget {

  final LatLng? initialPosition;
  final bool? useCurrentLocation;

  const LocationPickerView({ 
    Key? key,
    this.initialPosition,
    this.useCurrentLocation
  }) : super(key: key);

  @override
  State<LocationPickerView> createState() => _LocationPickerViewState();
}

class _LocationPickerViewState extends State<LocationPickerView> {

  final _localStorage = Get.find<LocalStorageService>();
  final initialPosition = Rx<LatLng?>(null);
  final useCurrentLocation = false.obs;
  final placeHistories = RxList<PlaceDetail>([]);
  final placeDetail = Rx<PlaceDetail?>(null);
  final search = ''.obs;
  final currectLocation = Rx<LatLng?>(null);
  final placeList = RxList<AutoCompletePrediction>([]);
  final isLoadPlaceDetail = false.obs;
  final isBottomSheetFullScreen = false.obs;
  final focusNode = FocusNode();
  final searchController = TextEditingController();
  final isLoading = false.obs;

  @override
  void initState() {
    initialPosition.value = widget.initialPosition;
    setCurrentLocation();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        isBottomSheetFullScreen.value = true;
        placeDetail.value = null;
      }
    });
    super.initState();
  }

  Future setCurrentLocation() async {
    log(initialPosition.value?.latitude.toString() ?? '');

    if (initialPosition.value != null) {
      currectLocation.value = initialPosition.value;
    } else {
      currectLocation.value = await getCurrentLocation();
    }
    print('setCurrentLocation: ${currectLocation.value}');
  }

  void closeBottomSheet() {
    isBottomSheetFullScreen.value = false;
    focusNode.unfocus();
  }

  void navigateBack() {
    if (placeDetail.value != null) {
      resetPlaceSelected();
    } else {
      Get.back();
    }
  }

  void resetPlaceSelected() {
    placeDetail.value = null;
  }

  Future loadAutoCompletePlace(String input) async {
    search.value = input;
    resetPlaceSelected();
    isLoading.value = true;
    placeList.value = await LocationRepository.loadAutoCompletePlaces(input);
    isLoading.value = false;
  }

  Future setPlaceSelected(String placeId) async {
    placeDetail.value = null;
    isLoadPlaceDetail.value = true;
    isBottomSheetFullScreen.value = false;
    focusNode.unfocus();
    placeDetail.value = await LocationRepository.loadPlaceDetailByPlaceId(placeId);
    currectLocation.value = LatLng(
      placeDetail.value?.geometry?.location?.lat ?? 0.0,
      placeDetail.value?.geometry?.location?.lng ?? 0,
    );
    isLoadPlaceDetail.value = false;
  }

  Future mapMoved(
    double lat,
    double lng,
  ) async {
    currectLocation.value = LatLng(lat, lng);
    placeDetail.value = null;
    isLoadPlaceDetail.value = true;
    placeDetail.value = await LocationRepository.loadPlaceDetailByLatLng(lat, lng);
    isLoadPlaceDetail.value = false;
  }

  void selectLocation() {
    savePlaceSelectedToBox();
    print('result: back');
    print('result: back ${placeDetail.value?.toJson()}');
    Get.back(result: placeDetail.value);
  }

  void savePlaceSelectedToBox() {
    placeHistories.removeWhere((element) => element.placeId == placeDetail.value?.placeId);
    if(placeDetail.value != null) {
      placeHistories.insert(0, placeDetail.value!);
      _localStorage.setPlaceHistory(placeHistories);
    }
  }

  void removePlaceSelectedFromBox(String placeId) {
    placeHistories.removeWhere((element) => element.placeId == placeId);
    _localStorage.setPlaceHistory(placeHistories);
  }

  @override
  Widget build(BuildContext context) {
    const btmmShtHeight = 300.0;
    const btmShtRndEdgeHeight = 20.0;
    final scrHeight = MediaQuery.of(context).size.height;
    final mapHeight = scrHeight - btmmShtHeight + btmShtRndEdgeHeight;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Stack(
          children: [
            Obx(() => currectLocation.value != null ? LocationPickerMap(
              mapHeight: mapHeight,
              currentLat: currectLocation.value?.latitude,
              currentLng: currectLocation.value?.longitude,
              onMapIdle: (loc) => mapMoved(loc.latitude, loc.longitude)
            ) : Center(child: NxLoadingSpinner())),
            _buildBottomSheetAction(),
            Align(
              alignment: Alignment.bottomCenter,
              // ignore: sized_box_for_whitespace
              child: Obx(() => BottomSheetLocationPicker(
                controller: searchController
                  ..text = search.value
                  ..selection = TextSelection.collapsed(
                    offset: search.value != '' ? search.value.length : 0
                  ),
                height: (isBottomSheetFullScreen.value) ? scrHeight : btmmShtHeight,
                focusNode: focusNode,
                isLoading: isLoading.value,
                closeSheet: closeBottomSheet,
                isBottomSheetFullScreen: isBottomSheetFullScreen.value,
                isPlaceDetailLoading: isLoadPlaceDetail.value,
                placeHistories: placeHistories,
                placeList: placeList,
                placeDetail: placeDetail.value,
                deleteHistory: removePlaceSelectedFromBox,
                onSearch: loadAutoCompletePlace,
                onPlaceSelected: setPlaceSelected,
                onLocationSelected: selectLocation
              )),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheetAction() {
    return Align(
      alignment: Alignment.bottomCenter,
      // ignore: sized_box_for_whitespace
      child: Container(
        height: 380,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                FloatingActionButton(
                  mini: true,
                  onPressed: navigateBack,
                  backgroundColor: Colors.white,
                  elevation: 2,
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
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