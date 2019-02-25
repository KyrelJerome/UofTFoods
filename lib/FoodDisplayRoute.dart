import 'package:flutter/material.dart';
import 'Objects/Store.dart';
//import 'Objects/Hours.dart';
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
  List<bool> campusFilters = [true, true, true];
  List<String> filters;
  int campus = 0;
  CobaltApi api;
  int openFilter;
  int tags = 1;
  String building;
  DateTime date;

  void initState() {
    //print("Running init state");
    super.initState();
    tags = 0;
    api = CobaltApi();
    filters = List();
    filteredStores = List();
    stores = List();
    date = DateTime.now();
    loadUnfilteredStores();

    print("Ran init state");
  }

  @override
  Widget build(BuildContext context) {
    Widget dataWrapper;
    if (filteredStores != null && filteredStores.length > 0) {
      dataWrapper = Expanded(
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: filteredStores.length,
            itemBuilder: (BuildContext context, int index) {
              return StoreCard(store:filteredStores[index]);
            }),
      );
    } else {
      dataWrapper = Expanded(
        child: Center(
          child: Text("No Results Found"),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            iconSize: 28,
            icon: Icon(Icons.search),
            padding: EdgeInsets.all(4),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            iconSize: 28,
            tooltip: "Page refreshed!",
            padding: EdgeInsets.all(4),
            onPressed: loadUnfilteredStores,
          ),
        ],
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: widget.margin),
              padding: EdgeInsets.symmetric(vertical: 0),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Expanded(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8.0,
                        children: buildFiltersList(),
                      ),
                    ),
                  ),
                  Container(
                    child: Center(
                      child: IconButton(
                        icon: Icon(Icons.filter_list),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 0,
            ),
            dataWrapper,
          ],
        ),
      ),
    );
  }

  void loadUnfilteredStores() async {
    print("loading unfiltered stores");
    List<Store> loadStream = await api.getFoodsJson();
    //Capitalize every first letter of every tag on load, longer load time by 2n where n is the number of tags.
    if (loadStream != null) {
      for (int i = 0; i < loadStream.length; i++) {
        List<dynamic> tags = loadStream[i].tags;
        if (tags != null) {
          for (int j = 0; j < tags.length; j++) {
            if (tags[j] != null && tags[j].toString().length > 0) {
              tags[j] = tags[j].toString().substring(0, 1).toUpperCase() +
                  tags[j].toString().substring(1, tags[j].length);
            }
          }
        }
      }
      setState(() {
        stores = loadStream;
        updateFilteredStores();
      });
      loadUnfilteredStoreImages();
    } else {}
  }

  void updateFilteredStores() {
    List<Store> tempStores = List();
    stores.forEach((Store store) {
      // print(store.id + "added to list");
      if (isStoreUnFiltered(store)) {
        tempStores.add(store);
        print("Store added!");
      }
    });
    setState(() {
      filteredStores = tempStores;
    });
  }

  bool isStoreUnFiltered(Store store) {
    for (int i = 0; i < campuses.length; i++) {
      if (store.campus == campuses[i]) {
        print("Store campus found!");
        return campusFilters[i];
      }
    }
    return false;
  }

  void loadUnfilteredStoreImages() async {
    List<Image> storeImages = List();
    for (int i = 0; i < stores.length; i++) {
      if (stores[i].logoString != null && stores[i].logoString != "") {
        storeImages.add(Image.network(
          stores[i].logoString,
          height: 80,
          width: 80,
          fit: BoxFit.fill,
        ));
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

  void changeCampusFilters(bool isFiltered, int i) {
    setState(() {
      campusFilters[i] = isFiltered;
    });
    updateFilteredStores();
  }

 
  List<Widget> buildFiltersList() {
    List<FilterChip> filters = List();
    for (int i = 0; i < campuses.length; i++) {
      filters.add(
        FilterChip(
          selected: campusFilters[i],
          label: Text(campuses[i]),
          onSelected: (tap) => changeCampusFilters(tap, i),
        ),
      );
    }
    return filters;
  }
}

class StoreDialog extends StatelessWidget {
  final Store store;
  StoreDialog({
    @required this.store,
  });
  @override
  Widget build(BuildContext context) {
    Image storeImage = store.logo;
    Widget imageHolder;
    if (storeImage != null) {
      imageHolder = Ink(
        width: 160.0,
        height: 160.0,
        child: storeImage,
      );
    } else {
      imageHolder = null;
    }
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: new Text(
                store.name.toString(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.title,
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.all(4),
                child: imageHolder,
              ),
            ),
            Center(
              child: Text(store.description,
                  textAlign: TextAlign.center,
                  maxLines: 7,
                  style: Theme.of(context).textTheme.body1),
            ),
            Text("Location", style: Theme.of(context).textTheme.subtitle),
            Text(store.address, style: Theme.of(context).textTheme.body1),
            Divider(),
            Center(
              child: Wrap(
                spacing: 4.0,
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: buildTagsList(store, context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildTagsList(Store store, BuildContext context) {
    List<Widget> widgets = List();
    if (store != null && store.tags != null) {
      int tagLength = 0;
      for (int i = 0; i < store.tags.length && i < 5 && tagLength < 50; i++) {
        tagLength += store.tags[i].toString().length;
        widgets.add(
          Chip(
            label: Text((store.tags[i].toString()),
                style: Theme.of(context).textTheme.caption),
          ),
        );
      }
    }
    return widgets;
  }
}

class StoreCard extends StatefulWidget {
  final Store store;
  StoreCard({@required this.store});

  _StoreCardState createState() => _StoreCardState(store:store);
  
}

class _StoreCardState extends State<StoreCard> {
  Store store;
  _StoreCardState({@required this.store});
  @override
  Widget build(BuildContext context) {
      Image storeImage = store.logo;
      String imageAlert = 'No Image Provided';
      Widget imageHolder;
      if (store != null && store.logoString != null && store.logoString != "") {
        imageAlert = 'Image provided and found';
      }
      if (storeImage != null) {
        imageHolder = Ink(
          width: 80.0,
          height: 80.0,
          child: InkWell(
            onTap: () {},
            child: storeImage,
          ),
        );
      } else {
        imageHolder = Container(
          child: Center(child: Text(imageAlert)),
          width: 80.0,
          height: 80.0,
        );
      }

      Widget storeCard = Container(
          child: InkWell(
        onTap: () => _showStoreDialog(store),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(4),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(child: imageHolder, margin: EdgeInsets.all(4)),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Text(
                          store.name,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.title,
                        ),
                        Text(
                          store.campus ?? "",
                          style: Theme.of(context).textTheme.subtitle,
                        ),
                        Wrap(
                          alignment: WrapAlignment.spaceAround,
                          children: buildTagsList(store),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 0),
          ],
        ),
      ));
      return storeCard;
  }
   List<Widget> buildTagsList(Store store) {
    List<Widget> widgets = List();
    if (store != null && store.tags != null) {
      int tagLength = 0;
      for (int i = 0; i < store.tags.length && i < 4 && tagLength < 23; i++) {
        tagLength += store.tags[i].toString().length;
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Text((store.tags[i].toString()),
                style: Theme.of(context).textTheme.caption),
          ),
        );
      }
    }
    return widgets;
  }

   void _showStoreDialog(Store store) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StoreDialog(store: store);
        });
  }
}
