import 'dart:convert';

PlaceDetail placeDetailFromJson(String str) => PlaceDetail.fromJson(json.decode(str) as Map<String, dynamic>);

String placeDetailToJson(PlaceDetail data) => json.encode(data.toJson());

List<PlaceDetail> placeDetailsFromJson(String str) => List<PlaceDetail>.from(json.decode(str).map((x) => PlaceDetail.fromJson(x as Map<String, dynamic>))as Iterable);

String placeDetailsToJson(List<PlaceDetail> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PlaceDetail {
  PlaceDetail({
    this.addressComponents,
    this.adrAddress,
    this.formattedAddress,
    this.geometry,
    this.icon,
    this.name,
    this.placeId,
    this.reference,
    this.types,
    this.url,
    this.utcOffset,
  });

  List<AddressComponent>? addressComponents;
  String? adrAddress;
  String? formattedAddress;
  Geometry? geometry;
  String? icon;
  String? name;
  String? placeId;
  String? reference;
  List<String>? types;
  String? url;
  int? utcOffset;

  factory PlaceDetail.fromJson(Map<String, dynamic> json) => PlaceDetail(
    addressComponents: json['address_components'] != null ? List<AddressComponent>.from(
      json['address_components'].map(
        (x) => AddressComponent.fromJson(x)
      )
    ) : null,
    adrAddress: json['adr_address'],
    formattedAddress: json['formatted_address'],
    geometry: json['geometry'] != null
        ? Geometry.fromJson(json['geometry'])
        : null,
    icon: json['icon'],
    name: json['name'],
    placeId: json['place_id'],
    reference: json['reference'],
    types: List<String>.from(json['types'].map((x) => x)),
    url: json['url'],
    utcOffset: json['utc_offset'],
  );

  Map<String, dynamic> toJson() => {
        'address_components': addressComponents != null
            ? List<dynamic>.from(addressComponents!.map((x) => x.toJson()))
            : null,
        'adr_address': adrAddress,
        'formatted_address': formattedAddress,
        'geometry': geometry?.toJson(),
        'icon': icon,
        'name': name,
        'place_id': placeId,
        'reference': reference,
        'types': types != null 
            ? List<dynamic>.from(types!.map((x) => x))
            : null,
        'url': url,
        'utc_offset': utcOffset,
      };
}

class AddressComponent {
  AddressComponent({
    this.longName,
    this.shortName,
    this.types,
  });

  String? longName;
  String? shortName;
  List<String>? types;

  factory AddressComponent.fromJson(Map<String, dynamic> json) => AddressComponent(
    longName: json['long_name'],
    shortName: json['short_name'],
    types: List<String>.from(json['types'].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    'long_name': longName,
    'short_name': shortName,
    'types': types != null 
        ? List<dynamic>.from(types!.map((x) => x))
        : null,
  };
}

class Geometry {
  Geometry({
    this.location,
    this.viewport,
  });

  PlaceLocation? location;
  Viewport? viewport;

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
  location: json['location'] != null
      ? PlaceLocation.fromJson(json['location'])
      : null,
  viewport: json['viewport'] != null
      ? Viewport.fromJson(json['viewport'])
      : null,
  );

  Map<String, dynamic> toJson() => {
        'location': location?.toJson(),
        'viewport': viewport?.toJson(),
      };
}

class PlaceLocation {
  PlaceLocation({
    this.lat,
    this.lng,
  });

  double? lat;
  double? lng;

  factory PlaceLocation.fromJson(Map<String, dynamic> json) => PlaceLocation(
        lat: json['lat'] as double,
        lng: json['lng'] as double,
      );

  Map<String, dynamic> toJson() => {
        'lat': lat,
        'lng': lng,
      };
}

class Viewport {
  Viewport({
    this.northeast,
    this.southwest,
  });

  PlaceLocation? northeast;
  PlaceLocation? southwest;

  factory Viewport.fromJson(Map<String, dynamic> json) => Viewport(
        northeast: json['northeast'] != null
            ? PlaceLocation.fromJson(json['northeast'] as Map<String, dynamic>)
            : null,
        southwest: json['southwest'] != null
            ? PlaceLocation.fromJson(json['southwest'] as Map<String, dynamic>)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'northeast': northeast?.toJson(),
        'southwest': southwest?.toJson(),
      };
}
