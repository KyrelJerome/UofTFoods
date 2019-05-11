
import 'package:deer_food/Objects/Store.dart';
import 'package:flutter/material.dart';

class IsOpenChip extends StatelessWidget {
  final Store store;

  const IsOpenChip({Key key, this.store}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (store.hours != null && store.hours.hasHours() != null) {
      //print(store.hours.hours.toString());
      if (store.isOpenNow()) {
        return Center(
          child: Chip(
            label: Text("Open"),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
    return Center(
      child: Chip(
        label: Text("Closed"),
        backgroundColor: Colors.red,
      ),
    );
  }
}
