import 'dart:convert';

List<Attendance> attendanceFromJson(String str) => List<Attendance>.from(json.decode(str).map((x) => Attendance.fromJson(x)));

String attendanceToJson(List<Attendance> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Attendance {
    Attendance({
        this.clock,
        this.datetime,
        this.note,
        this.latitude,
        this.longitude,
        this.address,
    });

    String? clock;
    DateTime? datetime;
    String? note;
    double? latitude;
    double? longitude;
    String? address;

    factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
        clock: json["clock"],
        datetime: json["datetime"] != null ? DateTime.parse(json["datetime"]) : null,
        note: json["note"],
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        address: json["address"],
    );

    Map<String, dynamic> toJson() => {
        "clock": clock,
        "datetime": datetime?.toIso8601String(),
        "note": note,
        "latitude": latitude,
        "longitude": longitude,
        "address": address,
    };
}