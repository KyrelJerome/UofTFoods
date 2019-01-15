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

  void loadUnfilteredStores() async {
    List<Store> loadStream = await api.getFoodsJson();
    setState(() => (stores = loadStream));
    loadUnfilteredStoreImages();
  }

  void loadUnfilteredStoreImages() async {
    List<Image> storeImages = List();
    for (int i = 0; i < stores.length; i++) {
      if (stores[i].logoString != null && stores[i].logoString != "") {
        storeImages.add(Image.network(stores[i].logoString, height:80, width: 80, fit: BoxFit.fill));
      } else {
        storeImages.add(null);
      }
    }
    setState(() {
      for (int i = 0; i < stores.length; i++) {
        stores[i].logo = storeImages[i];
      }
    });
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

                  Center(
                    child: IconButton(
                      icon: Icon(Icons.filter_list),
                      onPressed: ()=>{},
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
    if (storeCards.length > 1) {
      storeCards.add(buildStoreCard(stores[0]));
    }
    for (int i = 1; i < stores.length; i++) {
      storeCards.add(Divider());
      storeCards.add(buildStoreCard(stores[i]));
    }
    return storeCards;
  }

  Widget buildStoreCard(Store store) {
    Image storeImage = store.logo;
    String imageAlert = 'No image provided';
    if (store != null && store.logoString != null && store.logoString != "") {
      imageAlert = 'Image provided and found';
    }

    Widget storeCard = Container(
        margin: EdgeInsets.all(8),
        height: 88,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(4),
              width: 80,
              height: 80,
              child: (storeImage ??
                  Text(imageAlert)), // TODO: replace with: storeImage,
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  Text(
                    store.name,
                    style: Theme.of(context).textTheme.title,
                  ),
                  Text(
                    store.campus,
                    style: Theme.of(context).textTheme.subtitle,
                  ),
                ],
              ),
            ),
          ],
        ));
    return storeCard;
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
