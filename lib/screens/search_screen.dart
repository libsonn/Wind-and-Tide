import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:marine_weather/classes/place.dart';
import 'package:marine_weather/screens/selected_place_screen.dart';
import 'package:marine_weather/widgets/top_bar.dart';
import '../constants.dart';
import 'package:marine_weather/config.dart' as config;

import 'home_screen.dart';

class SearchScreen extends StatefulWidget {
  static String screenID = '/searchScreen';
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Place place = Place();
  String _enteredAddress = '';

  int latDeg = 0;
  int latMin = 0;
  int latSec = 0;

  int longDeg = 0;
  int longMin = 0;
  int longSec = 0;

  double latitude = 0;
  double longitude = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TopBar(
              leftIcon: Icons.keyboard_backspace,
              centerText: 'Search',
              leftIconOnTap: () {
                Navigator.pushNamed(context, HomeScreen.screenID);
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Search by name:',
                    style: TextStyle(color: kWhiteTextColor, fontSize: 20.0),
                  ),
                  SizedBox(
                    height: 2.0,
                  ),
                  Card(
                    shadowColor: kGreyTextColor,
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
                                  borderSide:
                                      BorderSide(color: kBackgroundColor),
                                ),
                                hintText: _enteredAddress.isEmpty
                                    ? 'Name of place to search'
                                    : _enteredAddress,
                                hintStyle: _enteredAddress.isNotEmpty
                                    ? TextStyle(color: kBackgroundColor)
                                    : TextStyle(),
                              ),
                              onTap: () async {
                                Prediction prediction =
                                    await PlacesAutocomplete.show(
                                  context: context,
                                  apiKey: config.googleApiKey,
                                  language: 'en',
                                  mode: Mode.overlay,
                                );

                                if (prediction != null) {
                                  setState(() {
                                    _enteredAddress = prediction.description;
                                    place.setPlaceDescription(
                                        prediction.description);
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SearchButtonWidget(
                    onPressed: _enteredAddress.isNotEmpty
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SelectedPlaceDetailsScreen(
                                  selectedPlace: place,
                                ),
                              ),
                            );
                          }
                        : null,
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    height: 1.0,
                    width: double.infinity,
                    color: kGreyTextColor,
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    'Search by geographical coordinates:',
                    style: TextStyle(color: kWhiteTextColor, fontSize: 20.0),
                  ),
                  SizedBox(
                    height: 2.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      'Latitude:',
                      style: TextStyle(color: kWhiteTextColor, fontSize: 15.0),
                    ),
                  ),
                  LatitudeLongitudeTextFields(
                    degOnChanged: (String data) {
                      setState(() {
                        latDeg = int.parse(data).round();
                        latitude = Place.calculateLatitudeFromGeo(
                            latDeg, latMin, latSec);
                      });
                    },
                    minOnChanged: (String data) {
                      setState(() {
                        latMin = int.parse(data).round();
                        latitude = Place.calculateLatitudeFromGeo(
                            latDeg, latMin, latSec);
                      });
                    },
                    secOnChanged: (String data) {
                      setState(() {
                        latSec = int.parse(data).round();
                        latitude = Place.calculateLatitudeFromGeo(
                            latDeg, latMin, latSec);
                      });
                    },
                    pickerItem1: 'E',
                    pickerItem2: 'W',
                    onSelectedItem: (item) {},
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      'Longitude:',
                      style: TextStyle(color: kWhiteTextColor, fontSize: 15.0),
                    ),
                  ),
                  LatitudeLongitudeTextFields(
                    degOnChanged: (String data) {
                      setState(() {
                        longDeg = int.parse(data).round();
                        longitude = Place.calculateLatitudeFromGeo(
                            longDeg, longMin, longSec);
                      });
                    },
                    minOnChanged: (String data) {
                      setState(() {
                        longMin = int.parse(data).round();
                        longitude = Place.calculateLatitudeFromGeo(
                            longDeg, longMin, longSec);
                      });
                    },
                    secOnChanged: (String data) {
                      setState(() {
                        longSec = int.parse(data).round();
                        longitude = Place.calculateLatitudeFromGeo(
                            longDeg, longMin, longSec);
                      });
                    },
                    pickerItem1: 'N',
                    pickerItem2: 'S',
                    onSelectedItem: (item) {},
                  ),
                  Center(
                    child: Text(
                      'Entered latitude: ${latitude.toStringAsFixed(4)}',
                      style: TextStyle(color: kWhiteTextColor),
                    ),
                  ),
                  Center(
                    child: Text(
                      'Entered longitude: ${longitude.toStringAsFixed(4)}',
                      style: TextStyle(color: kWhiteTextColor),
                    ),
                  ),
                  SearchButtonWidget(
                    onPressed: () {
                      Place _newPlace = Place();
                      _newPlace.setLatitude(latitude);
                      _newPlace.setLongitude(longitude);

                      Navigator.pushNamed(
                          context, SelectedPlaceDetailsScreen.screenID,
                          arguments: _newPlace);
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class LatitudeLongitudeTextFields extends StatelessWidget {
  LatitudeLongitudeTextFields(
      {@required this.degOnChanged,
      @required this.minOnChanged,
      @required this.secOnChanged,
      @required this.pickerItem1,
      @required this.pickerItem2,
      @required this.onSelectedItem});

  final Function degOnChanged;
  final Function minOnChanged;
  final Function secOnChanged;

  final String pickerItem1;
  final String pickerItem2;
  final Function onSelectedItem;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CoordinatesTextField(
          hintText: 'Degrees',
          onChanged: degOnChanged,
        ),
        CoordinatesTextField(
          hintText: 'Minutes',
          onChanged: minOnChanged,
        ),
        CoordinatesTextField(
          hintText: 'Seconds',
          onChanged: secOnChanged,
        ),
        SizedBox(
          width: 40,
          child: CupertinoPicker(
            looping: true,
            onSelectedItemChanged: onSelectedItem,
            itemExtent: 40,
            children: [
              Text(
                pickerItem1,
                style: TextStyle(fontSize: 40.0, color: kWhiteTextColor),
              ),
              Text(
                pickerItem2,
                style: TextStyle(fontSize: 40.0, color: kWhiteTextColor),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SearchButtonWidget extends StatelessWidget {
  SearchButtonWidget({this.onPressed});

  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3.0),
        child: RaisedButton(
          disabledColor: kGreyTextColor,
          highlightColor: kBrightBlueColor,
          splashColor: kBrightBlueColor,
          elevation: 10.0,
          color: Colors.white,
          textColor: kBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
          ),
          onPressed: onPressed,
          child: Text('Search'),
        ),
      ),
    );
  }
}

class CoordinatesTextField extends StatelessWidget {
  CoordinatesTextField({@required this.hintText, @required this.onChanged});

  final String hintText;
  final Function onChanged;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Card(
        shadowColor: kGreyTextColor,
        elevation: 10.0,
        child: TextField(
          onChanged: onChanged,
          keyboardType: TextInputType.number,
          cursorColor: kBackgroundColor,
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(10.0, 1.0, 10.0, 1.0),
              fillColor: kWhiteTextColor,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: kBackgroundColor),
              ),
              hintText: hintText,
              hintStyle: TextStyle(color: kBackgroundColor)),
        ),
      ),
    );
  }
}
