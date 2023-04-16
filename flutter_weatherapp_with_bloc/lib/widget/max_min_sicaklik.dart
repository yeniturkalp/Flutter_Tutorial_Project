import 'package:flutter/material.dart';
import 'package:weather_app/models/weather.dart';

class MaxveMinSicaklikWidget extends StatelessWidget {
  ConsolidatedWeather bugununDegerleri;

  MaxveMinSicaklikWidget({this.bugununDegerleri});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "Maksimum : " + bugununDegerleri.maxTemp.floor().toString() + " ℃",
            style: TextStyle(fontSize: 20),
          ),
          Text(
            "Minimum  : " + bugununDegerleri.minTemp.floor().toString() + " ℃",
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
