import 'dart:convert' show json;
import 'package:flutter/material.dart';

class  Hours{
  //TODO add make formatting system, setters, getters, and whatever is required for "open, etc".
  Map<String, Map<String,int>> hours;
  
  Hours({
    @required this.hours,
  });

  factory Hours.fromJson(Map<String, dynamic> parsedJson){
   /*parsedJson.forEach((String day, dynamic)
    {
      Map<String, int> temp = json.decode(parsedJson[day]);
    }
   );*/
   return Hours(hours: parsedJson);
  }
  _getStartDateTimeJson(){

  }
  _getEndDateTimeJson(){

  }
  _getDayJson(){

  }
  getStartDateTime(){
    //return
  }
  getEndDateTime(){

  }
}