import 'package:flutter/material.dart';

class Hours {
  static const TIME_TO_HOUR = 3600;
  static const TIME_TO_MINUTE = 60;
  static const weekdays = [
    "monday",
    "tuesday",
    "wednesday",
    "thursday",
    "friday",
    "saturday",
    "sunday"
  ];

  dynamic hours;

  Hours({
    @required this.hours,
  });

  factory Hours.fromJson(Map<String, dynamic> parsedJson) {
    return Hours(hours: parsedJson);
  }

  static String getDay() {
    return weekdays[DateTime.now().weekday - 1];
  }

  static double currTimeHours() {
    return DateTime.now().hour + DateTime.now().minute / 60;
  }

  static int currTimeMinutes() {
    return DateTime.now().minute;
  }

  double getOpenHour(String day) {
    return hours[day]["open"] / TIME_TO_HOUR;
  }

  double getOpenMinute(String day) {
    return hours[day]["open"] / TIME_TO_MINUTE;
  }

  double getCloseHour(String day) {
    return hours[day]["close"] / TIME_TO_HOUR;
  }

  double getCloseMinute(String day) {
    return hours[day]["close"] / TIME_TO_MINUTE;
  }
}
