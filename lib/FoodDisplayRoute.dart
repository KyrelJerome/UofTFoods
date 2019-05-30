import 'package:deer_food/StoreUI/StoreCard.dart';
import 'package:flutter/material.dart';
import 'Objects/Store.dart';
import 'API/cobaltFoodsWrapper.dart';
import 'Objects/StoreFilter.dart';
import 'presentation/t_foods_icons.dart';

class FoodDisplayRoute extends StatefulWidget {
  FoodDisplayRoute({Key key, this.title}) : super(key: key);
  final double margin = 8;
  final String title;
  @override
  _FoodDisplayRouteState createState() => _FoodDisplayRouteState();
}

enum filterType { OPEN, CLOSED, MICROWAVE, UTM, UTSG, UTSC }

class _FoodDisplayRouteState extends State<FoodDisplayRoute> {
  static const List<String> campuses = ["UTM", "UTSG", "UTSC"];
  Map<filterType, int> filterStates;
  //Filters have States, Clauses, and Actions
  Map<filterType, List> filterData = {
    filterType.OPEN: [
      "Open",
    ],
    filterType.CLOSED: [
      "Closed",
    ],
    filterType.UTM: ["UTM"],
    filterType.UTSG: ["UTSG"],
    filterType.UTSC: ["UTSC"]
  };
  List<StoreFilter> filters;
  List<List<Store>> campusStores = List();
  List<Store> stores;
  List<Store> filteredStores;
  final TextEditingController _filter = new TextEditingController();
  Widget _appBarTitle;
  Icon _searchIcon;
  String _searchText;
  List<bool> campusFilters = [true, true, true];
  //Filters, // 0 = disabled 1 = enabled
  int campus = 0;
  CobaltApi api;
  int openFilter;
  String building;
  DateTime date;

  void initState() {
    super.initState();
    api = CobaltApi();
    filterStates = {
      filterType.OPEN: 0,
      filterType.CLOSED: 0,
      filterType.MICROWAVE: 0
    };
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
    _appBarTitle = Center(
      child: Text(
        widget.title,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget storeListWrapper;
    if (filteredStores != null && filteredStores.length > 0) {
      storeListWrapper = Expanded(
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: filteredStores.length,
            itemBuilder: (BuildContext context, int index) {
              return StoreCard(store: filteredStores[index]);
            }),
      );
    } else {
      storeListWrapper = Expanded(
        child: Center(
          child: Text("No Results Found"),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: _appBarTitle,
        leading: Icon(
          TFoods.tfoodstologotest,
          size: 24.0,
          color: Colors.white,
        ),
        actions: <Widget>[
          IconButton(
            icon: _searchIcon,
            //iconSize: 28,
            tooltip: "Search",
            onPressed: _searchPressed,
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            //iconSize: 28,
            tooltip: "Page refreshed!",
            onPressed: loadUnfilteredStores,
          ),
        ],
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 0),
              padding: EdgeInsets.symmetric(vertical: 0),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        child: Wrap(
                          alignment: WrapAlignment.start,
                          spacing: 8.0,
                          children: buildFiltersList(),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.filter_list),
                    onPressed: () {
                      //TODO: Add Filtering Interface
                    },
                  ),
                ],
              ),
            ),
            Divider(
              height: 0,
            ),
            storeListWrapper,
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
      loadAllStoreImages();
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
    if (filterStates[filterType.OPEN] == 1 && !store.isOpenNow()) {
      return true;
    }
    if (filterStates[filterType.CLOSED] == 1 && store.isOpenNow()) {
      return false;
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

  void loadAllStoreImages() async {
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

  void changeFilterState() {
    setState(() {});
    updateFilteredStores();
  }

  void changeCampusFilters(bool isFiltered, int i) {
    setState(() {
      campusFilters[i] = isFiltered;
      print(isFiltered.toString() + "Campus : " + i.toString());
    });
    updateFilteredStores();
  }

  List<Widget> buildFiltersList2() {
    List widgets = List();
    filters.forEach((StoreFilter filter) {
      widgets.add(filter.filterChip);
    });
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
