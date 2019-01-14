import 'package:flutter/material.dart';
import 'Objects/Store.dart';
import 'Objects/Hours.dart';
import 'API/cobaltFoodsWrapper.dart';
class FoodDisplayRoute extends StatefulWidget {
  FoodDisplayRoute({Key key, this.title}) : super(key: key);
  final double margin = 8;
  final String title;
  @override
  _FoodDisplayRouteState createState() => _FoodDisplayRouteState();
}

class _FoodDisplayRouteState extends State<FoodDisplayRoute> {
  List<Store> stores;
  List<String> filters;
  CobaltApi api;
  int openFilter;
  int tags;
  String building;
  DateTime date;
  void initState() {
    super.initState();
    api = CobaltApi();
    filters = List();
    stores = List();
    date = DateTime.now();
    loadUnfilteredStores();
  }
  void loadUnfilteredStores() async{
    List<Store> loadStream =  await api.getFoodsJson();
    setState(() => (stores = loadStream));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          )
        ],
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(widget.margin),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Text(
                      "Filters:",
                      style: Theme.of(context).textTheme.title,
                    ),
                  ),
                  Container(
                    child: Expanded(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8.0,
                        children: buildFiltersList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 0,
            ),
            Expanded(
              child: ListView(
                children: buildActiveStoreWidgets(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  List<Widget> buildActiveStoreWidgets() {
    List<Widget> storeCards = List();
    for (int i = 0; i < stores.length; i++) {
      Image storeImage;
      Image.network(stores[i].logoString);
      Widget storeCard = Container(
          height: 88,
          width: double.infinity,
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(4),
                width: 80,
                height: 80,
                child:Text("Placeholder"), // TODO: replace with: storeImage,
              ),
              Column(
                children: <Widget>[
                  Text(
                    stores[i].name,
                    style: Theme.of(context).textTheme.title,
                  ),
                  Text(
                    stores[i].id,
                    style: Theme.of(context).textTheme.subtitle,
                  ),
                ],
              ),
            ],
          ));
        storeCards.add(storeCard);
    }
    return storeCards;
  }

  List<Widget> buildFiltersList() {
    return [
      Chip(
        label: Text('Microwave'),
      ),
      Chip(
        label: Text('Pizza'),
      ),
      Chip(
        label: Text('Open'),
      )
    ];
  }

  BottomNavigationBar buildBottomNavigationBar() {
    List<BottomNavigationBarItem> items = List();
    items.add(BottomNavigationBarItem(
      icon: Icon(Icons.all_inclusive),
      title: Text("All"),
    ));
    items.add(BottomNavigationBarItem(
      icon: Icon(Icons.book),
      title: Text("UTM"),
    ));
    items.add(BottomNavigationBarItem(
      icon: Icon(Icons.book),
      title: Text("UTSG"),
    ));
    items.add(BottomNavigationBarItem(
      icon: Icon(Icons.book),
      title: Text("UTSC"),
    ));
    BottomNavigationBar nav = BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: items,
    );
    return nav;
  }
}
