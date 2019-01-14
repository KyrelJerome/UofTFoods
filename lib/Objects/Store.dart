import 'package:flutter/material.dart';
import 'Hours.dart';
  
class Store {
  String id;
  String buildingID;
  Image logo;
  String logoString;
  String name;
  String shortName;
  String campus;
  String website;
  String address;

  List<String> tags;
  Hours hours;
  double lat;
  double lng;

  Store({
    @required this.id,
    @required this.buildingID,
    @required this.logoString,
    @required this.name,
    @required this.shortName,
    @required this.campus,
    @required this.lat,
    @required this.lng,
    @required this.website,
    @required this.address,
  });

  factory Store.fromJson(Map<String, String> parsedJson) {
    return Store(
      id: parsedJson['id'],
      buildingID: parsedJson['building_id'],
      name: parsedJson['name'],
      logoString: parsedJson['logo'],
      shortName: parsedJson['short_name'],
      campus: parsedJson['campus'],
      lat: double.parse(parsedJson['lat']),
      lng: double.parse(parsedJson['lng']),
      address: parsedJson['address'],
      website: parsedJson['website'],
    );
  }
}
