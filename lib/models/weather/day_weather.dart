import 'package:weatherify/models/weather/weather.dart';

class DayWeather {
  Weather? currentWeather;
  Weather? morningWeather;
  Weather? dayWeather;
  Weather? eveningWeather;
  Weather? nightWeather;
  dynamic? windSpeed;
  int? humidity;
  int? pressure;
  String? cityName;
  String? countryCode;
  dynamic minTemp;
  dynamic maxTemp;
  dynamic uv;
  int? timeStamp;

  DayWeather({
    this.currentWeather,
    this.morningWeather,
    this.dayWeather,
    this.eveningWeather,
    this.nightWeather,
    this.windSpeed,
    this.humidity,
    this.pressure,
    this.cityName,
    this.countryCode,
    this.minTemp,
    this.maxTemp,
    this.uv,
    this.timeStamp,
  });
}
