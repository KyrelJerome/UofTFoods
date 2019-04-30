import 'package:deer_food/Objects/Store.dart';
import 'package:deer_food/StoreUI/IsOpenChip.dart';
import 'package:deer_food/StoreViewRoute.dart';
import 'package:flutter/material.dart';

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
      imageHolder = Hero(
        tag: store.hashCode,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            child: storeImage,
            width: 80,
            height: 80,
          ),
        ),
      );
    } else {
      imageHolder = ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          alignment: Alignment.center,
          child: Center(child: Text(imageAlert)),
          width: 80.0,
          height: 80.0,
        ),
      );
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
                        child: IsOpenChip(
                          store: store,
                        ),
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
