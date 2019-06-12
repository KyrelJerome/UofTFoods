import 'package:flutter/material.dart';

import 'presentation/t_foods_icons.dart';

class SplashRoute extends StatelessWidget {
  final String title;
  SplashRoute({this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 48, horizontal: 32),
        color: Colors.indigo,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Text(
                "Welcome to",
                style: Theme.of(context).textTheme.display1.copyWith(
                    color: Colors.white,
                    textBaseline: TextBaseline.ideographic),
              ),
            ),
            Spacer(),
            Icon(
              TFoods.tfoodstologotest,
              size: 64.0,
              color: Colors.white,
            ),
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 16),
                child: Text(
                  "UofT Foods",
                  style: Theme.of(context).textTheme.display3.copyWith(
                      color: Colors.white,
                      textBaseline: TextBaseline.ideographic),
                ),
              ),
            ),
            Spacer(),
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
            Spacer(),
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
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
