import 'package:flutter/material.dart';

class  Hours{
  dynamic hours;

  Hours({
    @required this.hours,
  });

  factory Hours.fromJson(Map<String, dynamic> parsedJson){
   return Hours(hours: parsedJson);
  }
}