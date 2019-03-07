import 'package:flutter/material.dart';
import 'Objects/Store.dart';
//import 'Objects/Hours.dart';
import 'API/cobaltFoodsWrapper.dart';

class StoreViewRoute extends StatelessWidget {
  final Store store;
  StoreViewRoute({this.store});
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
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {Navigator.of(context).pop();},
      )),
      body: Container(
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
