import 'package:deer_food/presentation/t_foods_icons.dart';
import 'package:flutter/material.dart';
import 'Objects/Store.dart';
import 'package:launch_review/launch_review.dart';

//import 'Objects/Hours.dart';
//import 'API/cobaltFoodsWrapper.dart';
const TIME_TO_HOUR = 3600;

class CreditsRoute extends StatelessWidget {
  final Store store;
  CreditsRoute({this.store});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: Text("About UofT Foods"),
      // ),
      body: Container(
        color: Colors.indigo,
        padding: EdgeInsets.all(8),
        height: double.infinity,
        width: double.infinity,
        child: InkWell(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Icon(
                      TFoods.tfoodstologotest,
                      size: 80.0,
                      color: Colors.indigo[900],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Powered by "),
                    Container(
                      margin: EdgeInsets.all(8),
                      child: FlutterLogo(
                        size: 80,
                      ),
                    ),
                  ],
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      // Text("Suggestion?"),
                      RaisedButton(
                        child: Text("Leave a Review!"),
                        onPressed: () {
                          LaunchReview.launch();
                        },
                      )
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Center(
                      child: Text(
                        "Disclaimer",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(16),
                      child: Text(
                        " We are not affiliated, associated, authorized, endorsed by, or in any way officially connected with University of Toronto, or any of its subsidiaries or its affiliates. The official University of Toronto website can be found at https://www.utoronto.ca/ . The name “University of Toronto” as well as related names, marks, emblems and images are registered trademarks of University of Toronto. ",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
