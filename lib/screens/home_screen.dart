import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:marine_weather/constants.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 90.0,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [kBrighterBlueColor, kBackgroundColor],
              ),
            ),
            child: Center(
              child: Text(
                'Wind and Tide',
                style: TextStyle(fontSize: 30.0, color: Colors.white),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Places:',
                  style: TextStyle(color: kTextColor, fontSize: 30.0),
                ),
                SizedBox(
                  height: 2.0,
                ),
                Card(
                  shadowColor: kGreyColor,
                  elevation: 10.0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: kBackgroundColor,
                        ),
                        SizedBox(width: 8.0),
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.text,
                            cursorColor: kBackgroundColor,
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: kBackgroundColor),
                              ),
                              hintText: 'Name of place to search',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3.0),
                    child: RaisedButton(
                      highlightColor: kBrightBlueColor,
                      splashColor: kBrightBlueColor,
                      elevation: 10.0,
                      color: Colors.white,
                      textColor: kBackgroundColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      onPressed: () {
                        //TODO Open next screen with searching results
                      },
                      child: Text('Search'),
                    ),
                  ),
                ),
                SizedBox(
                  height: 2.0,
                ),
                Text(
                  'My localization:',
                  style: TextStyle(color: kTextColor, fontSize: 30.0),
                ),
                GestureDetector(
                  child: ListTile(
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                    ),
                    leading: Icon(
                      Icons.location_on,
                      color: kBackgroundColor,
                      size: 40,
                    ),
                    title: Text(
                      'My localization',
                      style: TextStyle(fontSize: 20),
                    ),
                    subtitle: Text('54°30\' 18°35\''),
                    trailing: Column(
                      children: [
                        Expanded(
                          child: Icon(
                            Icons.wb_sunny,
                            color: Colors.yellow,
                            size: 40,
                          ),
                        ),
                        Text('25°C'),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 2.0,
                ),
                Text(
                  'Favourites:',
                  style: TextStyle(color: kTextColor, fontSize: 30.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
