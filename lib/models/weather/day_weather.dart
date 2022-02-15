import 'package:weatherify/models/weather/weather.dart';

class DayWeather {
  Weather currentWeather;
  Weather morningWeather;
  Weather dayWeather;
  Weather eveningWeather;
  Weather nightWeather;
  double windSpeed;
  int humidity;
  int pressure;
  String cityName;
  String countryCode;
  double minTemp;
  double maxTemp;
  double uv;
  int timeStamp;

  DayWeather({
    required this.currentWeather,
    required this.morningWeather,
    required this.dayWeather,
    required this.eveningWeather,
    required this.nightWeather,
    required this.windSpeed,
    required this.humidity,
    required this.pressure,
    required this.cityName,
    required this.countryCode,
    required this.minTemp,
    required this.maxTemp,
    required this.uv,
    required this.timeStamp,
  });
}
