import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const mapZoom = 16.0;

class MapView extends StatefulWidget {
  final double? currentLat;
  final double? currentLng;

  const MapView({
    this.currentLat,
    this.currentLng,
  });

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final _controller = Rx<GoogleMapController?>(null);
  final _currentLocation = Rx<LatLng?>(null);
  final _isFollowing = true.obs;

  late LatLngBounds bounds;
  late BitmapDescriptor icon;
  bool cameraMoveByHuman = false;

  @override
  void initState() {
    if (widget.currentLat != null) {
      _currentLocation.value = LatLng(widget.currentLat!, widget.currentLng!);
    }
    _updateCameraPosition();
    super.initState();
  }

  @override
  // ignore: must_call_super
  void didUpdateWidget(Widget oldWidget) {
    cameraMoveByHuman = false;
    if (widget.currentLat != null) {
      _currentLocation.value = LatLng(widget.currentLat!, widget.currentLng!);
    }
    _updateCameraPosition();
  }

  void _updateCameraPosition() {
    if (_controller.value != null && _isFollowing.value) {
      _controller.value!.moveCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: _currentLocation.value!, 
          zoom: mapZoom
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Obx(() => _currentLocation.value != null ? Listener(
          onPointerDown: (e) => cameraMoveByHuman = true,
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentLocation.value!,
              zoom: mapZoom,
            ),
            myLocationButtonEnabled: false,
            mapToolbarEnabled: true,
            onMapCreated: (GoogleMapController controller) => _controller.value = controller,
            zoomControlsEnabled: true,
            onTap: (latLng) {
              _isFollowing.value = false;
            },
          ),
        ) : SizedBox.shrink()),
        Align(
          child: Image.asset('assets/marker_location.png', width: 40, height: 40),
        ),
      ],
    );
  }
}
