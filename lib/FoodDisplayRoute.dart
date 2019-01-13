import 'package:flutter/material.dart';

class FoodDisplayRoute extends StatefulWidget {
  FoodDisplayRoute({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _FoodDisplayRouteState createState() => _FoodDisplayRouteState();
}

class _FoodDisplayRouteState extends State<FoodDisplayRoute> {
  //List<Store> stores;
  void initState() { 
    super.initState();
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: ListView(),
      bottomNavigationBar: BottomNavigationBar(
        items: buildBottomNavigationBar(),
      ),
    );
  }

  List<BottomNavigationBarItem> buildBottomNavigationBar() {
    List<BottomNavigationBarItem> items = List();
    items.add(BottomNavigationBarItem(icon: Icon(Icons.book), title: Text("UTM")));
    items.add(BottomNavigationBarItem(icon: Icon(Icons.book), title: Text("UTSG")));
    items.add(BottomNavigationBarItem(icon: Icon(Icons.book), title: Text("UTSC")));
    //TODO: Replace with campus logos?
    return items;
  }
}