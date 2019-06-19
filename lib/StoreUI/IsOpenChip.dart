import 'package:UofT_Foods/Objects/Store.dart';
import 'package:flutter/material.dart';

class IsOpenChip extends StatelessWidget {
  final Store store;

  const IsOpenChip({Key key, this.store}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (store.hours != null && store.hours.hasHours()) {
      if (!store.isOpenNow()) {
        return Center(
          child: Chip(
            label: Text("Closed", style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.red,
          ),
        );
      }
      return Center(
        child: Chip(
          label: Text("Open", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.green,
        ),
      );
    }
      return Container(width: 0.0, height:0.0);
  }
}
