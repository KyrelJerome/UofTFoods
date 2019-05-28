import 'package:deer_food/Objects/Store.dart';
import 'package:flutter/material.dart';

class IsOpenChip extends StatelessWidget {
  final Store store;

  const IsOpenChip({Key key, this.store}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (store.hours != null && store.hours.hasHours() != null) {
      if (store.isOpenNow()) {
        double closesIn = store.closesIn();
        if (closesIn < 60) {
          return Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Center(
                child: Chip(
                  label: Text("Open", style: TextStyle(color: Colors.white)),
                  backgroundColor: Colors.green,
                ),
              )
            ],
          );
        } else {
          return Center(
            child: Chip(
              label: Text("Open", style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    }
    return Center(
      child: Chip(
        label: Text("Closed", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ),
    );
  }
}
