import 'package:UofT_Foods/StoreUI/StoreCard.dart';
import 'package:flutter/material.dart';
import 'CreditsRoute.dart';
import 'Objects/Filters/Filters.dart';
import 'Objects/Store.dart';
import 'API/cobaltFoodsWrapper.dart';
import 'Objects/StoreFilter.dart';
import 'presentation/t_foods_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
  Widget _BottomDrawer;
  int loadingInt = 0;

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
    _BottomDrawer = BottomDrawerWidget(
        generalFilters: generalFilters, campusFilters: campusFilters);
    int loadingInt = 0;
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
    updateFilteredStores();
  }

  @override
  Widget build(BuildContext context) {
    Widget storeLoader;
    if (loadingInt == 0) {
      storeLoader = Container(width: 0, height: 0);
    } else {
      storeLoader = Column(
        children: <Widget>[
          //loading stuff
          SpinKitFadingCircle(
            itemBuilder: (_, int index) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  color: index.isEven ? Colors.indigo : Colors.blueGrey,
                ),
              );
            },
          ),
        ],
      );
    }
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
              Text("No results found."),
              Container(
                margin: EdgeInsets.all(8),
                child: Text("Tip: Change filters and refresh!"),
              )
            ],
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: _appBarTitle,
        leading: IconButton(
            icon: Icon(
              TFoods.tfoodstologotest,
              size: 24.0,
              color: Colors.white,
            ),
            onPressed: () {
              setState(
                () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CreditsRoute()),
                    ),
              );
            }),
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
              margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              padding: EdgeInsets.symmetric(vertical: 0),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        child: Text("${filteredStores.length} RESULTS"),
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
            storeLoader,
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
    return _BottomDrawer;
  }

  void loadUnfilteredStores() async {
    print("Loading Unfiltered Stores");
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
      });
      updateFilteredStores();
      loadAllStoreImages();
    }
  }

  void updateFilteredStores() {
    setState(() {
      loadingInt -= 1;
    });
    List<Store> tempStores = List();
    print("Length: " + tempStores.length.toString());
    for (Store store in stores) {
      for (CampusFilter filter in campusFilters) {
        if (filter.filter(store)) {
          tempStores.add(store);
          break;
        }
      }
    }
    for (int i = 0; i < generalFilters.length; i++) {
      tempStores = generalFilters[i].applyCounterFilter(tempStores);
    }
    List<Store> tempStores2 = List();
    for (Store store in tempStores) {
      if (isSearchFiltered(store)) {
        tempStores2.add(store);
      }
    }
    setState(() {
      loadingInt += 1;
      filteredStores = tempStores2;
    });
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
}

class BottomDrawerWidget extends StatefulWidget {
  BottomDrawerWidget(
      {@required this.campusFilters, @required this.generalFilters});
  @override
  _BottomDrawerWidgetState createState() => _BottomDrawerWidgetState();
  final List<StoreFilter> campusFilters;
  final List<StoreFilter> generalFilters;
}

class _BottomDrawerWidgetState extends State<BottomDrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "REFINE RESULTS",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Icon(Icons.filter_list, color: Colors.grey[500]),
              ],
            ),
          ),
          Container(
            child: Divider(color: Colors.grey[800]),
          ),
          Center(
            child: Container(
              child: Text(
                "CAMPUS",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Wrap(
            spacing: 8,
            children: getCampusFilters(),
          ),
          Center(
            child: Container(
              child: Text(
                "GENERAL",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Wrap(
            spacing: 8,
            children: getGeneralFilters(),
          )
        ],
      ),
    );
  }

  updateFunction() {
    this.setState(() {});
  }

  List<Widget> getGeneralFilters() {
    List<Widget> widgets = List();
    for (StoreFilter filter in widget.generalFilters) {
      widgets.add(filter.getfilterChip(updateFunction));
    }
    return widgets;
  }

  List<Widget> getCampusFilters() {
    List<Widget> widgets = List();
    for (StoreFilter filter in widget.campusFilters) {
      widgets.add(filter.getfilterChip(updateFunction));
    }
    return widgets;
  }
}
