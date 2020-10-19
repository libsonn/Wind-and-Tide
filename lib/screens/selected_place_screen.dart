import 'package:flutter/material.dart';
import 'package:marine_weather/classes/place.dart';

class SelectedPlaceDetailsScreen extends StatefulWidget {
  static String screenID = '/selectedPlaceDetails';

  @override
  _SelectedPlaceDetailsScreenState createState() =>
      _SelectedPlaceDetailsScreenState();
}

class _SelectedPlaceDetailsScreenState
    extends State<SelectedPlaceDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final Place _selectedPlace = ModalRoute.of(context).settings.arguments;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
    });

    return Scaffold(
      body: SafeArea(
        child: Container(
          child: GestureDetector(
            child: Text(
              _selectedPlace.getDescription(),
              style: TextStyle(fontSize: 20.0),
            ),
          ),
        ),
      ),
    );
  }
}
