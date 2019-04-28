import 'package:flutter/material.dart';
import 'Hours.dart';
//import 'dart:convert' show json;

const TIME_TO_HOUR = 3600;
const weekdays = [
  "monday",
  "tuesday",
  "wednesday",
  "thursday",
  "friday",
  "saturday",
  "sunday"
];
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
  String description;
  List<dynamic> tags;
  Hours hours;
  double lat;
  double lng;

  Store({
    @required this.description,
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
    @required this.hours,
    @required this.tags,
  });
  factory Store.fromJson(Map<String, dynamic> parsedJson) {
    return Store(
      description: parsedJson['description'],
      id: parsedJson['id'],
      buildingID: parsedJson['building_id'],
      name: parsedJson['name'],
      tags: parsedJson['tags'],
      logoString: parsedJson['image'],
      shortName: parsedJson['short_name'],
      campus: parsedJson['campus'],
      lat: parsedJson['lat'],
      lng: parsedJson['lng'],
      address: parsedJson['address'],
      website: parsedJson['website'],
      hours: Hours(hours: parsedJson['hours']),
    );
  }
  static String getDay(){
    return weekdays[DateTime.now().weekday - 1];
  }
  bool isOpen(){
     return hours.hours[getDay()]["closed"] == 0;
  }
  bool isOpenNow(){
    dynamic storeHours = this.hours.hours;
    num open = storeHours[getDay()]["open"] / TIME_TO_HOUR;
    num close = storeHours[getDay()]["open"] / TIME_TO_HOUR;
    bool output = open <= DateTime.now().hour && close >= DateTime.now().hour;
    return output;
  }
}
