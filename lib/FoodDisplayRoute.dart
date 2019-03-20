import 'package:flutter/material.dart';
import 'Objects/Store.dart';
//import 'Objects/Hours.dart';
import 'API/cobaltFoodsWrapper.dart';
import 'StoreViewRoute.dart';

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
  final TextEditingController _filter = new TextEditingController();
  Widget _appBarTitle;
  Icon _searchIcon;
  String _searchText;
  List<bool> campusFilters = [true, true, true];
  List<String> filters = [
    "Open",
    "Microwave",
  ]; // Open // Building //
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
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          updateFilteredStores();
        });
      } else {
        setState(() {
          _searchText = _filter.text;
          updateFilteredStores();
        });
      }
    });
    _searchIcon = Icon(Icons.search);
    _appBarTitle = Center(child: Text(widget.title));
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
              return StoreCard(store: filteredStores[index]);
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
        title: _appBarTitle,
        leading: IconButton(
          icon: _searchIcon,
          iconSize: 28,
          tooltip: "Search",
          padding: EdgeInsets.all(4),
          onPressed: _searchPressed,
        ),
        actions: <Widget>[
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

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: _filter,
          style: TextStyle(color: Colors.white),
          decoration: new InputDecoration(
            hintText: 'Search...',
          ),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text(widget.title);
        // filteredNames = names;
        _filter.clear();
      }
    });
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
    //print("Updating Filtering stores");
    List<Store> tempStores = List();
    stores.forEach((Store store) {
      if (!isStoreFiltered(store)) {
        tempStores.add(store);
      }
    });
    setState(() {
      filteredStores = tempStores;
    });
  }

  bool isStoreFiltered(Store store) {
    for (int i = 0; i < campuses.length; i++) {
      if (store.campus == campuses[i]) {
        if (!campusFilters[i]) {
          // print("Do not add Store: " + store.name + "| At: " + store.campus);
          return true;
        }
      }
    }
    String text = _searchText;
    if (text != null && text != "") {
      text = text.toLowerCase();
      if (store.name.toLowerCase().contains(text) ||
          store.description.toLowerCase().contains(text)) {
        //print(text + " : add Store: " + store.name);
        return false;
      } else {
        //print(text + ": filter store: " + store.name);

        return true;
      }
    }
    //print("(null or empty search)add store: " + store.name);
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
      print(isFiltered.toString() + "Campus : " + i.toString());
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

  _StoreCardState createState() => _StoreCardState(store: store);
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
      imageHolder = ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Hero(
          tag: store.hashCode,
          child: Container(
            child: storeImage,
            width: 80,
            height: 80,
          ),
        ),
      );
    } else {
      imageHolder = Container(
        child: Center(child: Text(imageAlert)),
        width: 80.0,
        height: 80.0,
      );
    }
    Widget hourChip;
    if (store.hours != null && store.hours.hours != null) {
      //print(store.hours.hours.toString());
      dynamic hours = store.hours.hours;
      bool currentDay = hours[weekdays[DateTime.now().weekday]]["closed"];
      if (!currentDay) {
        hourChip = Center(
          child: Chip(label: Text("Open"), backgroundColor: Colors.green[300]),
        );
      } else {
        hourChip = Center(
          child: Chip(
            label: Text("Closed"),
            backgroundColor: Colors.red[300],
          ),
        );
      }
    }
    Widget storeCard = Container(
        child: InkWell(
      onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => StoreViewRoute(store: store)),
          ),
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
                      Center(
                        child: hourChip,
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
}
