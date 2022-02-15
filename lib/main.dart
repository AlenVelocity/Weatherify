import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherify/models/weather/weather_info.dart';
import 'package:weatherify/views/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WeatherData();
    return ChangeNotifierProvider(
      create: (context) => WeatherData(),
      child: MaterialApp(
        home: const Home(),
        theme: ThemeData(fontFamily: 'Khula'),
      ),
    );
  }
}
