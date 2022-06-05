import 'dart:convert';

List<LocationData> locationDataFromJson(String str) => List<LocationData>.from(json.decode(str).map((x) => LocationData.fromJson(x)));

String locationDataToJson(List<LocationData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LocationData {
    LocationData({
        this.locationName,
        this.latitude,
        this.longitude,
        this.address,
    });

    String? locationName;
    double? latitude;
    double? longitude;
    String? address;

    factory LocationData.fromJson(Map<String, dynamic> json) => LocationData(
        locationName: json["location_name"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        address: json["address"],
    );

    Map<String, dynamic> toJson() => {
        "location_name": locationName,
        "latitude": latitude,
        "longitude": longitude,
        "address": address,
    };
}
