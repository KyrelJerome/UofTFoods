import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deer Food',
      theme: ThemeData(
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        primarySwatch: Colors.blue[800],
      ),
      home: FoodDisplayRoute(title: 'University of Toronto Foods'),
    );
  }
}

class FoodDisplayRoute extends StatefulWidget {
  FoodDisplayRoute({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _FoodDisplayRouteState createState() => _FoodDisplayRouteState();
}

class _FoodDisplayRouteState extends State<FoodDisplayRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(),
      bottomNavigationBar: BottomNavigationBar(
        items: buildBottomNavigationBar(),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  List<BottomNavigationBarItem> buildBottomNavigationBar() {
    List<BottomNavigationBarItem> items = List();
    items.add(BottomNavigationBarItem(icon: Text("UTM")));
    items.add(BottomNavigationBarItem(icon: Text("UTSG")));
    items.add(BottomNavigationBarItem(icon: Text("UTSC")));
    //TODO: Replace with campus logos?
    return items;
  }
}
