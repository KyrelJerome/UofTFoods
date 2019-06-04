import 'package:deer_food/Objects/Hours.dart';
import 'package:deer_food/StoreUI/IsOpenChip.dart';
import 'package:deer_food/presentation/t_foods_icons.dart';
import 'package:flutter/material.dart';
import 'Objects/Store.dart';
import 'package:flutter/services.dart';

//import 'Objects/Hours.dart';
//import 'API/cobaltFoodsWrapper.dart';
const TIME_TO_HOUR = 3600;

class CreditsRoute extends StatelessWidget {
  final Store store;
  CreditsRoute({this.store});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: InkWell(
          child: Center(
            child: Column(
              children: <Widget>[
                Text("We are in no way ")
                Icon(
                  TFoods.tfoodstologotest,
                  size: 80.0,
                  color: Colors.indigo,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
