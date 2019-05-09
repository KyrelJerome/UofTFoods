import 'package:flutter/material.dart';
import 'Hours.dart';
//import 'dart:convert' show json;

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
  /*Builds a Store object using the data from cobalt API*/
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
  bool isOpenPerm(){
     return hours.hours[Hours.getDay()]["closed"] == 0;
  }
  double opensIn() {
    return Hours.currTimeMinutes() - hours.getOpenMinute(Hours.getDay());
  }
  double closesIn() {
    return Hours.currTimeMinutes() - hours.getOpenMinute(Hours.getDay());
  }
  bool isOpenNow(){
    double currTime = Hours.currTimeHours();
    dynamic storeHours = this.hours.hours;
    num open = storeHours.getOpenHour(Hours.getDay());
    num close = storeHours.getCloseHour(Hours.getDay());
    bool output = open <= currTime && close >= currTime;
    return output;
  } 
}
