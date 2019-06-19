import 'package:deer_food/presentation/t_foods_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
      body: Container(
        color: Colors.indigo,
        padding: EdgeInsets.only(
          bottom: 8,
          top: 32,
          left: 8,
          right: 8,
        ),
        height: double.infinity,
        width: double.infinity,
        child: InkWell(
          child: Center(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Icon(
                            TFoods.tfoodstologotest,
                            size: 100.0,
                            color: Colors.indigo[100],
                          ),
                          Text(
                            "Powered by ",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(8),
                            child: FlutterLogo(
                              size: 100,
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal:32),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Center(
                                child: Text(
                                  "Disclaimer",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.indigo[100],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(8),
                                child: Text(
                                  " We are not affiliated, associated, authorized, endorsed by, or in any way officially connected with The University of Toronto, or any of its subsidiaries or its affiliates. The official The University of Toronto website can be found at https://www.utoronto.ca/ . The name “The University of Toronto” as well as related names, marks, emblems and images are registered trademarks of The University of Toronto. ",
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                  maxLines: 8,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.indigo[100],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Container(
                                //margin: EdgeInsets.all(16),
                                child: Text(
                                  "All data presented is updated periodically from the Cobalt API, we are not liable for innaccuracies, but try to keep data accurate.",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.indigo[100],
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                RaisedButton(
                  child: Text("Got a Suggestion? Leave a Review!"),
                  onPressed: () {
                    LaunchReview.launch();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
