import 'package:UofT_Foods/Objects/Store.dart';
import 'package:flutter/material.dart';

class TimeBasedAlert extends StatelessWidget {
  final Store store;

  const TimeBasedAlert({Key key, this.store}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (store.isOpenPerm()) {
      if (store.closesIn() < 30 && store.closesIn() > 0) {
        return Text(
          "Closing soon!",
          style: Theme.of(context)
              .accentTextTheme
              .body2
              .copyWith(color: Colors.redAccent),
        );
      } else if (store.opensIn() < 30 && store.opensIn() > 0) {
        return Text(
          "Opening soon!",
          style: Theme.of(context)
              .accentTextTheme
              .body2
              .copyWith(color: Colors.lightGreenAccent),
        );
      }
    }
    return Container();
  }
}
