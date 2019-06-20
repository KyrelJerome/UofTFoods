import 'package:flutter/material.dart';
import 'SplashRoute.dart';

void main() => runApp(MyApp());
const String AppName = "UofT Foods";

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UofT Foods',
      theme:
          ThemeData(primarySwatch: Colors.indigo, brightness: Brightness.light),
      home: SplashRoute(title: 'UofT Foods'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashLoader extends StatefulWidget {
  @override
  _SplashLoaderState createState() => _SplashLoaderState();
}

class _SplashLoaderState extends State<SplashLoader> {

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
