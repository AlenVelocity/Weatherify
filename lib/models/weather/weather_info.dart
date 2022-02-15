import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weatherify/models/local_storage.dart';
import 'package:weatherify/models/location.dart';
import 'package:weatherify/models/weather/day_weather.dart';
import 'package:weatherify/models/weather/weather.dart';
import 'package:weatherify/utils/date.dart';
import 'package:weatherify/utils/request.dart';

import '../../constants/api.dart';

class WeatherData extends ChangeNotifier {
  bool loading = true;
  String? country;
  String? city;
  String? lastUpdate;

  WeatherData() {
    setLastUpdate();
    getLocalData();
    getLocationWeather();
  }

  DayWeather todayWeather = DayWeather(
    currentWeather: Weather(20, 20, 10),
    morningWeather: Weather(20, 20, 10),
    eveningWeather: Weather(20, 20, 10),
    dayWeather: Weather(20, 20, 10),
    nightWeather: Weather(20, 20, 10),
    humidity: 10,
    uv: 10,
    pressure: 5,
    timeStamp: 500021,
  );

  List<DayWeather> weekWeather = [];
  int weeklyIndex = 0;
  void setWeeklyIndex(int index) {
    weeklyIndex = index;
    notifyListeners();
  }

  Future<void> getLocationWeather() async {
    loading = true;
    Location location = Location();
    await location.setCurrentLocation();

    const apiKey = '646a8e323bd2cbd8a971ae2aa496a424';
    final weatherData = await Request.get(
      '$apiBaseUrl/onecall?lat=${location.latitude}&lon=${location.longitude}&exclude=minutely&appid=$apiKey&units=metric',
    );

    final weatherWeek = await Request.get(
        '$apiBaseUrl/forecast?lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey&units=metric');

    // ignore: unnecessary_null_comparison
    if (weatherData != null && weatherWeek != null) {
      setData(jsonDecode(weatherData), jsonDecode(weatherWeek));
      LocalStorage.storeString('weatherData', weatherData);
      LocalStorage.storeString('weatherWeek', weatherWeek);
    }
    final String now = Date.now();
    LocalStorage.storeString('LastUpdate', now);
    lastUpdate = now;
    return;
  }

  void setData(var weatherData, var weatherWeek) {
    country = weatherWeek['city']['country'];
    city = weatherWeek['city']['name'];

    todayWeather.currentWeather?.temp =
        weatherData['current']['temp'].toDouble();
    todayWeather.currentWeather?.cond =
        weatherData['current']['weather'][0]['id'];
    todayWeather.currentWeather?.stamp = weatherData['current']['dt'];

    todayWeather.morningWeather?.temp =
        weatherData['hourly'][3]['temp'].toDouble();
    todayWeather.morningWeather?.cond =
        weatherData['hourly'][3]['weather'][0]['id'];
    todayWeather.morningWeather?.stamp = weatherData['hourly'][3]['dt'];

    todayWeather.dayWeather?.temp = weatherData['hourly'][9]['temp'] + .0;
    todayWeather.dayWeather?.cond =
        weatherData['hourly'][9]['weather'][0]['id'];
    todayWeather.dayWeather?.stamp = weatherData['hourly'][9]['dt'];

    todayWeather.nightWeather?.temp =
        weatherData['hourly'][15]['temp'].toDouble();
    todayWeather.nightWeather?.cond =
        weatherData['hourly'][15]['weather'][0]['id'];
    todayWeather.nightWeather?.stamp = weatherData['hourly'][15]['dt'];

    todayWeather.windSpeed = weatherData['daily'][0]['wind_speed'].toDouble();
    todayWeather.humidity = weatherData['daily'][0]['humidity'];
    todayWeather.pressure = weatherData['daily'][0]['pressure'];
    todayWeather.uv = weatherData['daily'][0]['uvi'];

    int startIndex = 0;
    for (int i = 0; i < 40; i++) {
      if (Date.date(weatherWeek['list'][i]['dt']) ==
          Date.date(weatherData['daily'][1]['dt'])) {
        startIndex = i;
        break;
      }
    }

    weekWeather.clear();

    for (int i = startIndex; i < 40;) {
      weekWeather.add(DayWeather(
        morningWeather: Weather(
            weatherWeek['list'][i + 3]['main']['temp'].toDouble(),
            weatherWeek['list'][i + 3]['weather'][0]['id'],
            weatherWeek['list'][i + 3]['dt']),
        dayWeather: Weather(
            weatherWeek['list'][i + 5]['main']['temp'].toDouble(),
            weatherWeek['list'][i + 5]['weather'][0]['id'],
            weatherWeek['list'][i + 5]['dt']),
        eveningWeather: Weather(
            weatherWeek['list'][i + 7]['main']['temp'].toDouble(),
            weatherWeek['list'][i + 7]['weather'][0]['id'],
            weatherWeek['list'][i + 7]['dt']),
        nightWeather: Weather(
            weatherWeek['list'][i + 8]['main']['temp'].toDouble(),
            weatherWeek['list'][i + 8]['weather'][0]['id'],
            weatherWeek['list'][i + 8]['dt']),
      ));

      i += 8;
      if (i + 8 >= 40) {
        break;
      }
    }

    for (int i = 0; i < weekWeather.length; i++) {
      weekWeather[i].uv = weatherData['daily'][i + 1]['uvi'];
      weekWeather[i].humidity = weatherData['daily'][i + 1]['humidity'];
      weekWeather[i].pressure = weatherData['daily'][i + 1]['pressure'];
      weekWeather[i].windSpeed =
          weatherData['daily'][i + 1]['wind_speed'].toDouble();
      weekWeather[i].currentWeather = Weather(
          weatherData['daily'][i + 1]['temp']['day'].toDouble(),
          weatherData['daily'][i + 1]['weather'][0]['id'],
          weatherData['daily'][i + 1]['dt']);
      weekWeather[i].minTemp =
          weatherData['daily'][i + 1]['temp']['min'].toDouble();
      weekWeather[i].maxTemp =
          weatherData['daily'][i + 1]['temp']['max'].toDouble();
    }

    loading = false;

    notifyListeners();
  }

  void getLocalData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    dynamic weatherData = preferences.get('weatherData');
    dynamic weatherWeek = preferences.get('weatherWeek');
    if (weatherData != null && weatherWeek != null) {
      setData(jsonDecode(weatherData), jsonDecode(weatherWeek));
    }
  }

  void setLastUpdate() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? date = preferences.getString('LastUpdate');
    lastUpdate = date ?? '15/2/2022';
  }
}
