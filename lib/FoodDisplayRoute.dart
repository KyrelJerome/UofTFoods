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
              margin: EdgeInsets.symmetric(horizontal: widget.margin),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Text(
                      "Filters:",
                      style: Theme.of(context).textTheme.body1,
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
                      onPressed: loadUnfilteredStores,
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
      //bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  void loadUnfilteredStores() async {
    print("loading unfiltered stores");
    List<Store> loadStream = await api.getFoodsJson();
    //Capitalize every first letter of every tag on load, longer load time by 2n where n is the number of tags.
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
  }

  void updateFilteredStores() {
    List<Store> tempStores = List();
    stores.forEach((Store store) {
      // print(store.id + "added to list");
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
      // print("Filtered store:" + store.id);
      return false;
    }
    //while(int i = 0; i ++; i <)
    return true;
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

  List<Widget> buildActiveStoreWidgets(List<Store> stores) {
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
      imageHolder = Text(imageAlert);
    }

    Widget storeCard = Container(
        margin: EdgeInsets.all(4),
        width: double.infinity,
        child:InkWell(
          onTap: ()=>{},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: imageHolder,
                padding:EdgeInsets.all(4)
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text(
                      store.name,
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
        ));
    return storeCard;
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
      currentIndex: campus,
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
    //TODO: set a maximum character limit on tags and clean up tag presentation.
    List<Widget> widgets = List();
    //print("Building tags list");
    if (store != null && store.tags != null) {
      int tagLength = 0;
      for(int i = 0; i< store.tags.length && i < 4;  i ++){
        tagLength = store.tags[i].toString().length;
        widgets.add(
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Text((store.tags[i].toString()),
                  style: Theme.of(context).textTheme.caption
                  ),
            ),
          );
      }
      //store.tags.forEach((dynamic tag) => );
      //print(tags);
    }
    return widgets; //.sublist(0);
  }

  List<Widget> buildFiltersList() {
    return [
      FilterChip(
        label: Text('UTM'),
      ),
      FilterChip(
        label: Text('UTSG'),
      ),
      
      FilterChip(
        label: Text('UTSC'),
      ),
      FilterChip(
        label: Text('Open'),
      )
    ];
  }
  //Filter settings

}
