import 'package:flutter/material.dart';
import 'Objects/Store.dart';
//import 'Objects/Hours.dart';
import 'API/cobaltFoodsWrapper.dart';

const weekdays = [
  "monday",
  "tuesday",
  "wednesday",
  "thursday",
  "friday",
  "saturday",
  "sunday"
];

class StoreViewRoute extends StatelessWidget {
  final Store store;
  StoreViewRoute({this.store});
  @override
  Widget build(BuildContext context) {
    Image storeImage = store.logo;
    Widget imageHolder;
    if (storeImage != null) {
      imageHolder = Container(
        width: double.infinity,
        height: 180.0,
        child: storeImage,
      );
    } else {
      imageHolder = null;
    }
    Widget hourObject = Text("hours");
    if (store.hours != null && store.hours.hours != null) {
      print(store.hours.hours.toString());
      List<Widget> hourList = [];
      dynamic hours = store.hours.hours;
      bool currentDay = hours[weekdays[DateTime.now().weekday]]["closed"];
      if (!currentDay) {
        hourList.add(
          Center(
            child: Chip(label: Text("Open"), backgroundColor: Colors.green),
          ),
        );
      } else {
        hourList.add(
          Center(
            child: Chip(label:Text("Closed"), backgroundColor: Colors.red,),
          ),
        );
      }
      weekdays.forEach(
        (f) {
          hourList.add(Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(f.substring(0, 1).toUpperCase() + f.substring(1),
                  style: Theme.of(context).textTheme.subtitle),
              Text((hours[f]["open"] / 3600).floor().toString() +
                  " - " +
                  (hours[f]["close"] / 3600).floor().toString()),
            ],
          ));
        },
      );
      hourObject = Column(
        children: hourList,
      );
    }
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Container(
                  child: Hero(
                    tag: store.hashCode,
                    child: imageHolder,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: double.infinity,
                margin: EdgeInsets.all(8.0),
                child: ListView(
                  //  mainAxisSize: MainAxisSize.min,
                  //  crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: new Text(
                          store.name.toString().trim(),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.title,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 4),
                        child: Text(store.description.trim(),
                            textAlign: TextAlign.center,
                            maxLines: 7,
                            style: Theme.of(context).textTheme.body1),
                      ),
                      Divider(),
                      Text("Location",
                          style: Theme.of(context).textTheme.subtitle),
                      Text(store.address,
                          style: Theme.of(context).textTheme.body1),
                      Divider(),
                      hourObject,
                      Divider(),
                      Center(
                        child: Wrap(
                          spacing: 4.0,
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: buildTagsList(store, context),
                        ),
                      ),
                    ]),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        ],
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
