import 'package:deer_food/StoreUI/StoreCard.dart';
import 'package:flutter/material.dart';
import 'Objects/Filters/Filters.dart';
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
  List<StoreFilter> generalFilters;
  List<StoreFilter> campusFilters;
  List<Store> stores;
  List<Store> filteredStores;
  final TextEditingController _searchFilter = new TextEditingController();
  Widget _appBarTitle;
  Icon _searchIcon;
  String _searchText;
  CobaltApi api;
  void initState() {
    super.initState();
    api = CobaltApi();
    filteredStores = List();
    stores = List();
    initFilters();
    loadUnfilteredStores();
    _appBarTitle = Center(
      child: Text(
        widget.title,
      ),
    );
  }

  void initFilters() {
    generalFilters = List();
    campusFilters = List();
    dynamic utm = CampusFilter(
      filterAction,
      "University of Toronto Mississauga",
      "UTM",
      true,
    );
    dynamic utsg = CampusFilter(
      filterAction,
      "University of Toronto St. George",
      "UTSG",
      true,
    );
    dynamic utsc = CampusFilter(
      filterAction,
      "University of Toronto Scarborough",
      "UTSC",
      true,
    );
    dynamic open = OpenFilter(
      filterAction,
      false,
    );
    dynamic closed = ClosedFilter(
      filterAction,
      false,
    );
    campusFilters.add(utm);
    campusFilters.add(utsg);
    campusFilters.add(utsc);
    generalFilters.add(open);
    generalFilters.add(closed);
    _searchFilter.addListener(() {
      if (_searchFilter.text.isEmpty) {
        setState(() {
          _searchText = "";
          updateFilteredStores();
        });
      } else {
        setState(() {
          _searchText = _searchFilter.text;
          updateFilteredStores();
        });
      }
    });
    _searchIcon = Icon(Icons.search);
  }

  void filterAction(bool value) {
    setState(() {
      updateFilteredStores();
    });
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("No Results Found!"),
            ],
          ),
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
            tooltip: "Search",
            onPressed: _searchPressed,
          ),
          IconButton(
            icon: Icon(Icons.refresh),
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
                        child: Text("${filteredStores.length} Results"),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.filter_list),
                    onPressed: () {
                      _settingModalBottomSheet(context);
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

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) => buildFilterBottomSheet());
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          cursorColor: Colors.white,
          controller: _searchFilter,
          style: TextStyle(color: Colors.white),
          decoration: new InputDecoration(
            fillColor: Colors.white,
            hintText: 'Search...',
            hintStyle: TextStyle(color: Colors.white),
          ),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text(widget.title);
        _searchFilter.clear();
      }
    });
  }

  Widget buildFilterBottomSheet() {
    Widget filterContainer = Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
              margin: EdgeInsets.symmetric(horizontal: 16), child: Divider()),
          Center(
            child: Text("Campuses"),
          ),
          Wrap(
            spacing: 4,
            children: getCampusFilters(),
          ),
          Center(
            child: Text("General"),
          ),
          Wrap(
            spacing: 4,
            children: getGeneralFilters(),
          )
        ],
      ),
    );
    return filterContainer;
  }

  List<Widget> getGeneralFilters() {
    List<Widget> widgets = List();
    for (StoreFilter filter in generalFilters) {
      widgets.add(filter.filterChip);
    }
    return widgets;
  }

  List<Widget> getCampusFilters() {
    List<Widget> widgets = List();
    for (StoreFilter filter in campusFilters) {
      widgets.add(filter.filterChip);
    }
    return widgets;
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
    print("Length: " + tempStores.length.toString());
    for (Store store in stores) {
      for (CampusFilter filter in campusFilters) {
        if (filter.filter(store)) {
          //print(filter.shortName + " :Added Store");
          tempStores.add(store);
          break;
        }
      }
    }
    print("Length: " + tempStores.length.toString());
    for (int i = 0; i < generalFilters.length; i++) {
      print("Applying Filter: " + generalFilters[i].shortName);
      tempStores = generalFilters[i].applyCounterFilter(tempStores);
      print("Length: " + tempStores.length.toString());
    }

    List<Store> tempStores2 = List();
    for (Store store in tempStores) {
      if (isSearchFiltered(store)) {
        tempStores2.add(store);
      }
    }
    filteredStores = tempStores2;
  }

  bool isSearchFiltered(Store store) {
    String text = _searchText;
    if (text != null && text != "") {
      text = text.toLowerCase();
      if (store.name.toLowerCase().contains(text) ||
          store.description.toLowerCase().contains(text)) {
        return true;
      } else {
        return false;
      }
    }
    return true;
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

  List<FilterChip> buildFiltersList() {
    List<FilterChip> widgets = List();
    generalFilters.forEach((StoreFilter filter) {
      widgets.add(filter.filterChip);
    });
    campusFilters.forEach((StoreFilter filter) {
      widgets.add(filter.filterChip);
    });
    return widgets;
  }
}
