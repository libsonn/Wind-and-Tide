import 'package:flutter/material.dart';
import 'package:marine_weather/classes/place.dart';
import 'package:marine_weather/constants.dart';

class PlaceTile extends StatelessWidget {
  PlaceTile({this.place, this.onTap});

  final Place place;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 200.0,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: kBoxGradient,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Icon(
                            Icons.wb_sunny,
                            color: Colors.white,
                            size: 35.0,
                          ),
                          SizedBox(
                            height: 35.0,
                          ),
                        ],
                      ),
                      Text(
                        '${place.getTemperature().floor()}°c',
                        style: TextStyle(
                          foreground: Paint()..shader = kTextColorGradient,
                          fontSize: 70.0,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'weather description',
                    style: TextStyle(color: kGreyTextColor, fontSize: 13),
                  )
                ],
              ),
              SizedBox(
                height: 40.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    '${place.getDescription()}',
                    style: TextStyle(
                      fontSize: 10.0,
                      color: kGreyTextColor,
                    ),
                  ),
                  Container(
                    height: 10.0,
                    width: 1.0,
                    color: kGreyTextColor,
                  ),
                  Text(
                    '${place.getLatitudeDeg().abs()}° ${place.getLatitudeMin()}\' ${place.getLatitudeSec()}\'\'${place.getLatHemisphere()[0]}  ${place.getLongitudeDeg().abs()}° ${place.getLongitudeMin()}\' ${place.getLongitudeSec()}\'\'${place.getLongHemisphere()[0]}',
                    style: TextStyle(fontSize: 10, color: kGreyTextColor),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
