import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const mapZoom = 16.0;

class LocationPickerMap extends StatefulWidget {
  final double? mapHeight;
  final double? currentLat;
  final double? currentLng;
  final Function(LatLng)? onMapIdle;

  const LocationPickerMap({
    this.mapHeight,
    this.currentLat,
    this.currentLng,
    this.onMapIdle,
  });

  @override
  _LocationPickerMapState createState() => _LocationPickerMapState();
}

class _LocationPickerMapState extends State<LocationPickerMap> {
  final _controller = Rx<GoogleMapController?>(null);
  final _currentLocation = Rx<LatLng?>(null);
  final _isFollowing = true.obs;

  // final Set<Marker> _markers = {};
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

  // void addMarker(
  //   LatLng mLatLng, 
  //   String mTitle, 
  //   String mDescription,
  //   {BitmapDescriptor icon}
  // ) {
  //   _markers.add(Marker(
  //     markerId: MarkerId('${mTitle}_${_markers.length}'),
  //     position: mLatLng,
  //     infoWindow: InfoWindow(title: mTitle, snippet: mDescription),
  //     icon: icon,
  //   ));
  // }

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

  void _onCameraMove(CameraPosition position) {
    _currentLocation.value = position.target;
  }

  void _onCameraIdle() {
    if (cameraMoveByHuman && _currentLocation.value != null) {
      widget.onMapIdle?.call(_currentLocation.value!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: widget.mapHeight,
          child: Obx(() => _currentLocation.value != null ? Listener(
            onPointerDown: (e) => cameraMoveByHuman = true,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentLocation.value!,
                zoom: mapZoom,
              ),
              myLocationButtonEnabled: false,
              mapToolbarEnabled: false,
              onMapCreated: (GoogleMapController controller) => _controller.value = controller,
              onCameraMove: _onCameraMove,
              onCameraIdle: _onCameraIdle,
              zoomControlsEnabled: false,
              onTap: (latLng) {
                _isFollowing.value = false;
              },
            ),
          ) : SizedBox.shrink()),
        ),
        SizedBox(
          height: widget.mapHeight,
          child: Align(
            child: Image.asset('assets/marker_location.png', width: 40, height: 40),
          ),
        ),
        // Positioned(
        //   bottom: 40.0,
        //   right: 20.0,
        //   child: FloatingActionButton(
        //     backgroundColor: kTradecorpYellowColor,
        //     onPressed: () => _updateCameraPosition(),
        //     mini: true,
        //     child: const Icon(
        //       Icons.location_searching,
        //       color: kTradecorpRedColor,
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
