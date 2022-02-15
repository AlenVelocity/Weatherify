import 'package:flutter/material.dart';
import 'package:weatherify/constants/text_style.dart';

class WeatherCard extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const WeatherCard({
    required this.icon,
    required this.hour,
    required this.tempreture,
    required this.cardBackgroundColor,
  });

  final IconData icon;
  final String hour;
  final String tempreture;
  final Color cardBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(7.0),
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
        color: cardBackgroundColor,
      ),
      child: Column(
        children: <Widget>[
          Text(hour, style: WeatherTextStyle.cardHour),
          const SizedBox(
            height: 25.0,
          ),
          Icon(
            icon,
            size: 35.0,
            color: Colors.white,
          ),
          const SizedBox(
            height: 25.0,
          ),
          Text(tempreture, style: WeatherTextStyle.cardHour),
        ],
      ),
    );
  }
}
