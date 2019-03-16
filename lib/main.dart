import 'package:flutter/material.dart';
import 'FoodDisplayRoute.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UofT Food',
      theme:
      ThemeData(
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        primarySwatch: Colors.indigo,
        brightness: Brightness.light
      ),
      home: FoodDisplayRoute(title: 'UofT Food'),
      debugShowCheckedModeBanner: false,
    );
  }
}

