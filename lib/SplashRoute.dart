import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'FoodDisplayRoute.dart';
import 'presentation/t_foods_icons.dart';

class SplashRoute extends StatefulWidget {
  final String title;
  SplashRoute({this.title});

  @override
  _SplashRouteState createState() => _SplashRouteState();
}

class _SplashRouteState extends State<SplashRoute> {
  SharedPreferences prefs;
  void initState() {
    super.initState();
    checkSplash();
  }
  void checkSplash() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('hasOpened') == true) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FoodDisplayRoute(title: widget.title)),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      return Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.only(bottom: 32, top: 48, left: 32, right: 32),
          color: Colors.indigo,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Icon(
                    TFoods.tfoodstologotest,
                    size: 100.0,
                    color: Colors.indigo[100],
                  ),
                  Column(
                    children: <Widget>[
                      Center(
                        child: Text(
                          "Welcome To",
                          style: Theme.of(context).textTheme.display1.copyWith(
                              //fontStyle: FontStyle.italic,
                              color: Colors.white,
                              textBaseline: TextBaseline.ideographic),
                        ),
                      ),
                      Center(
                        child: Container(
                          child: Text(
                            "UofT Foods",
                            style: Theme.of(context)
                                .textTheme
                                .display3
                                .copyWith(
                                    color: Colors.white,
                                    textBaseline: TextBaseline.ideographic),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(right: 8),
                                      child: Icon(Icons.fastfood,
                                          color: Colors.white54),
                                    ),
                                    Text(
                                      "Search Foods on Campus",
                                      style: Theme.of(context)
                                          .textTheme
                                          .button
                                          .copyWith(
                                              fontSize: 20,
                                              color: Colors.white70),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(right: 8),
                                      child: Icon(Icons.store,
                                          color: Colors.white54),
                                    ),
                                    Text(
                                      "Filter By Campus",
                                      style: Theme.of(context)
                                          .textTheme
                                          .button
                                          .copyWith(
                                              fontSize: 20,
                                              color: Colors.white70),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(right: 8),
                                      child: Icon(Icons.timer,
                                          color: Colors.white54),
                                    ),
                                    Text(
                                      "See Store Hours",
                                      style: Theme.of(context)
                                          .textTheme
                                          .button
                                          .copyWith(
                                              fontSize: 20,
                                              color: Colors.white70),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(right: 8),
                                      child: Icon(Icons.location_on,
                                          color: Colors.white54),
                                    ),
                                    Text(
                                      "See Store Location",
                                      style: Theme.of(context)
                                          .textTheme
                                          .button
                                          .copyWith(
                                              fontSize: 20,
                                              color: Colors.white70),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              RaisedButton(
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Text(
                        "Continue",
                        style: Theme.of(context)
                            .textTheme
                            .button
                            .copyWith(fontSize: 20),
                      ),
                    ),
                    Center(
                      child: Icon(Icons.arrow_forward),
                    ),
                  ],
                ),
                onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              FoodDisplayRoute(title: this.widget.title)),
                    ),
              ),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.only(bottom: 32, top: 48, left: 32, right: 32),
        color: Colors.indigo,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Center(
              child: Text(
                "Welcome To",
                style: Theme.of(context).textTheme.display1.copyWith(
                    //fontStyle: FontStyle.italic,
                    color: Colors.white,
                    textBaseline: TextBaseline.ideographic),
              ),
            ),
            Icon(
              TFoods.tfoodstologotest,
              size: 64.0,
              color: Colors.white,
            ),
            Center(
              child: Container(
                child: Text(
                  "UofT Foods",
                  style: Theme.of(context).textTheme.display3.copyWith(
                      color: Colors.white,
                      textBaseline: TextBaseline.ideographic),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right: 8),
                        child: Icon(Icons.fastfood, color: Colors.white54),
                      ),
                      Text(
                        "Search Foods on Campus",
                        style: Theme.of(context)
                            .textTheme
                            .button
                            .copyWith(fontSize: 20, color: Colors.white70),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right: 8),
                        child: Icon(Icons.store, color: Colors.white54),
                      ),
                      Text(
                        "Filter By Campus",
                        style: Theme.of(context)
                            .textTheme
                            .button
                            .copyWith(fontSize: 20, color: Colors.white70),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right: 8),
                        child: Icon(Icons.timer, color: Colors.white54),
                      ),
                      Text(
                        "See Store Hours",
                        style: Theme.of(context)
                            .textTheme
                            .button
                            .copyWith(fontSize: 20, color: Colors.white70),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right: 8),
                        child: Icon(Icons.location_on, color: Colors.white54),
                      ),
                      Text(
                        "See Store Location",
                        style: Theme.of(context)
                            .textTheme
                            .button
                            .copyWith(fontSize: 20, color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            RaisedButton(
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Text(
                      "Continue",
                      style: Theme.of(context)
                          .textTheme
                          .button
                          .copyWith(fontSize: 20),
                    ),
                  ),
                  Center(
                    child: Icon(Icons.arrow_forward),
                  ),
                ],
              ),
              onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            FoodDisplayRoute(title: this.widget.title)),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
