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
  static const List<String> campuses = ["UTM", "UTSG", "UTSC"];
  List<Store> stores;
  List<Store> filteredStores;
  List<String> filters;
  int campus = 0;
  CobaltApi api;
  int openFilter;
  int tags;
  String building;
  DateTime date;

  void initState() {
    super.initState();
    api = CobaltApi();
    filters = List();
    filteredStores = List();
    stores = List();
    date = DateTime.now();
    loadUnfilteredStores();
  }

  void loadUnfilteredStores() async {
    List<Store> loadStream = await api.getFoodsJson();
    setState(() {
      stores = loadStream;
      updateFilteredStores();
    });
  }

  void updateFilteredStores() {
    List<Store> tempStores = List();
    stores.forEach((Store store) {
      if (isStoreUnFiltered(store)) {
        tempStores.add(store);
      }
    });
    setState(() {
      filteredStores = tempStores;
    });
  }

  bool isStoreUnFiltered(Store store) {
    if (campus != 0 && store.campus != campuses[campus - 1]) {
      return false;
    }

    return true;
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
                children: buildActiveStoreWidgets(filteredStores),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  List<Widget> buildActiveStoreWidgets(List<Store> stores) {
    List<Widget> storeCards = List();
    for (int i = 0; i < stores.length; i++) {
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
              child:
                  Text("Placeholder"), // TODO: replace with: storeImage,
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
        ),
      );
      storeCards.add(storeCard);
    }
    return storeCards;
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
      onTap: changeCampus,
    );
    return nav;
  }

  void changeCampus(int i) {
    if (i != campus) {
      setState(() {
        campus = i;
      });
    }
    updateFilteredStores();
  }

  List<Widget> buildTagsList(Store store) {
    List<Widget> widgets = List();
    store.tags.forEach((String tag) => widgets.add(Chip(label: Text(tag))));
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
}
