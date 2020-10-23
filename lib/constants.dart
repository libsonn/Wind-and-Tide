import 'package:flutter/material.dart';

const stormGlassUrl = "https://api.stormglass.io/v2/weather/point";
const openWeatherUrl = "https://api.openweathermap.org/data/2.5/onecall?";

// Shader for text
final Shader kTextColorGradient = LinearGradient(
  colors: <Color>[kTextGradientStartColor, kTextGradientEndColor],
).createShader(Rect.fromLTWH(100.0, 0.0, 200.0, 100.0));

// Gradient for info boxes
const kBoxGradient = LinearGradient(
    colors: <Color>[kBoxGradienStartColor, kBoxGradientEndColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight);
const kBlueGradient = LinearGradient(
    colors: <Color>[kTextGradientStartColor, kTextGradientEndColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight);

// Colors for gradients
const kTextGradientStartColor = Color.fromRGBO(51, 200, 246, 1);
const kTextGradientEndColor = Color.fromRGBO(1, 120, 233, 1);
const kBoxGradienStartColor = Color.fromRGBO(60, 67, 97, 1);
const kBoxGradientEndColor = Color.fromRGBO(102, 114, 149, 1);

// Colors
const kWhiteTextColor = Colors.white;
const kGreyTextColor = Color(0xFFA9B6CA);
const kVeryDarkColor = Color(0xFF0C1024);
const kBackgroundColor = Color.fromRGBO(48, 57, 88, 1);
const kBrightBlueColor = Color(0xFF0D61D7);
const kBrighterBlueColor = Color(0xFF4696D5);
const kDarkBlueColor = Color(0xFF4B5168);
