import 'package:flutter/material.dart';
import 'package:weatherify/constants/text_style.dart';

class Desc extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const Desc({
    required this.mainText,
    required this.subText,
  });

  final String mainText;
  final String subText;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(mainText, style: WeatherTextStyle.regularBlack),
        const SizedBox(
          width: 20.0,
        ),
        Text(subText, style: WeatherTextStyle.regularGrey),
      ],
    );
  }
}
