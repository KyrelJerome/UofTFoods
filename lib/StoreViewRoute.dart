import 'package:deer_food/Objects/Hours.dart';
import 'package:deer_food/StoreUI/IsOpenChip.dart';
import 'package:flutter/material.dart';
import 'Objects/Store.dart';

//import 'Objects/Hours.dart';
//import 'API/cobaltFoodsWrapper.dart';
const TIME_TO_HOUR = 3600;

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
        height: 200.0,
        child: storeImage,
      );
    } else {
      imageHolder = Center(
        child: Container(
          margin: EdgeInsets.all(20),
          child: Text("No Images Available"),
        ),
      );
    }
    Widget hourObject = Center(
      child: Text("Hours Not Provided"),
    );
    if (store.hours != null && store.hours.hasHours() != null) {
      List<Widget> hourList = [];
      Hours hours = store.hours;
      hourList.add(IsOpenChip(store: store));
      Hours.weekdays.forEach(
        (day) {
          if (hours.getOpenHour(day) <= 0 && hours.getCloseHour(day) <= 0) {
            hourList.add(Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(day.substring(0, 1).toUpperCase() + day.substring(1),
                    style: Theme.of(context).textTheme.subtitle),
                Text("CLOSED"),
              ],
            ));
          } else {
            hourList.add(Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(day.substring(0, 1).toUpperCase() + day.substring(1),
                    style: Theme.of(context).textTheme.subtitle),
                Text(hours.getOpenHour(day).floor().toString() +
                    " - " +
                    hours.getCloseHour(day).floor().toString()),
              ],
            ));
          }
        },
      );
      hourObject = Column(
        children: hourList,
      );
    }
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: double.infinity,
              child: Stack(
                children: <Widget>[
                  Hero(
                    tag: store.hashCode,
                    child: imageHolder,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: IconButton(
                      iconSize: 32,
                      icon: Opacity(
                        child: Container(
                          color: Colors.white70,
                          child: Icon(Icons.arrow_back),
                        ),
                        opacity: 0.5,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: new Text(
                store.name.toString().trim(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.title,
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 8),
                child: ListView(
                  padding: EdgeInsets.all(0),
                  children: [
                    Text(store.description.trim(),
                        textAlign: TextAlign.center,
                        maxLines: 7,
                        style: Theme.of(context).textTheme.body1),
                    // Divider(),
                    // Text(store.website,
                    //     style: Theme.of(context).textTheme.body1),
                    Divider(),
                    Center(
                      child: Text("Location",
                          style: Theme.of(context).textTheme.subtitle),
                    ),
                    Center(
                      child: Text(store.address,
                          style: Theme.of(context).textTheme.body1),
                    ),
                    Divider(),
                    hourObject,
                    Divider(),
                  ],
                ),
              ),
            ),
            Container(
              child: Center(
                child: Wrap(
                  spacing: 4.0,
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: buildTagsList(store, context),
                ),
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
      for (int i = 0; i < store.tags.length && i < 10 && tagLength < 75; i++) {
        tagLength += store.tags[i].toString().length;
        widgets.add(
          Chip(
            backgroundColor: Theme.of(context).primaryColor,
            label: Text(
              (store.tags[i].toString()),
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      }
    }
    return widgets;
  }
}
