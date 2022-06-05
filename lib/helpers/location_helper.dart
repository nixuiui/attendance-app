import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

Future<LatLng> getCurrentLocation() async {
    final location = Location();

    late bool _serviceEnabled;
    late PermissionStatus _permissionGranted;
    late LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return const LatLng(-6.1753871, 106.8249641);
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return const LatLng(-6.1753871, 106.8249641);
      }
    }

    _locationData = await location.getLocation();
    return LatLng(
      _locationData.latitude ?? 0.0, 
      _locationData.longitude ?? 0.0
    );
  }

  double calculateLocationDistance({
    lat1, 
    lng1, 
    lat2, 
    lng2
  }){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 + 
          c(lat1 * p) * c(lat2 * p) * 
          (1 - c((lng2 - lng1) * p))/2;
    return 12742 * asin(sqrt(a));
  }