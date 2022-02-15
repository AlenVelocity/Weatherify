// ignore_for_file: deprecated_member_use

import 'package:weatherify/Widgets/card.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:weatherify/constants/colors.dart';
import 'package:weatherify/constants/text_style.dart';
import 'package:weatherify/models/weather/weather.dart';
import 'package:weatherify/models/weather/weather_info.dart';
import 'package:weatherify/utils/date.dart';
import 'package:weatherify/views/weekly.dart';
import 'package:weatherify/widgets/desc.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weatherify',
          style: TextStyle(
              fontFamily: 'Khula',
              color: Colors.black,
              fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0.0,
      ),
      body: const DaysWeather(),
      backgroundColor: Colors.white,
      bottomNavigationBar: const BottomNavHome(),
    );
  }
}

class BottomNavHome extends StatelessWidget {
  const BottomNavHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.all(15.0),
          child: Icon(
            FontAwesomeIcons.home,
            size: 20.0,
            color: Colors.black,
          ),
        ),
        const SizedBox(
          width: 10.0,
        ),
        const Text(
          'Home',
          style: WeatherTextStyle.regularBlack,
        ),
        const Expanded(
          child: SizedBox(),
        ),
        FlatButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const Weekly();
            }));
          },
          child: const Icon(
            FontAwesomeIcons.cloudSunRain,
            size: 20.0,
            color: Grey.regular,
          ),
        ),
      ],
    );
  }
}

class DaysWeather extends StatefulWidget {
  const DaysWeather({Key? key}) : super(key: key);

  @override
  _DaysWeatherState createState() => _DaysWeatherState();
}

class _DaysWeatherState extends State<DaysWeather> {
  void _checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No Internet connection',
            style: WeatherTextStyle.smallGrey.copyWith(color: Colors.white),
          ),
        ),
      );
    }
  }

  void _checkGPS() async {
    bool gpsOn = await Geolocator.isLocationServiceEnabled();
    if (!gpsOn) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please Turn On Location Services',
            style: WeatherTextStyle.smallGrey.copyWith(color: Colors.white),
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _checkConnection();
    _checkGPS();
  }

  @override
  Widget build(BuildContext context) {
    RefreshController _refreshController =
        RefreshController(initialRefresh: false);

    void _onRefresh() async {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'No Internet connection',
              style: WeatherTextStyle.smallGrey.copyWith(color: Colors.white),
            ),
          ),
        );
        _refreshController.refreshFailed();
      } else {
        await Provider.of<WeatherData>(context, listen: false)
            .getLocationWeather();
        _refreshController.refreshCompleted();
      }
      bool gpsOn = await Geolocator.isLocationServiceEnabled();
      if (!gpsOn) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Please Turn On Location Services and Try Again',
              style: WeatherTextStyle.smallGrey.copyWith(color: Colors.white),
            ),
          ),
        );
      }
    }

    return Provider.of<WeatherData>(context).loading
        ? const Center(
            child: CircularProgressIndicator(
            backgroundColor: Colors.blue,
          ))
        : SmartRefresher(
            controller: _refreshController,
            onRefresh: _onRefresh,
            header: const WaterDropHeader(),
            physics: const BouncingScrollPhysics(),
            child: ListView(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.all(15),
              children: <Widget>[
                Icon(
                    Weather.getIcon(
                        Provider.of<WeatherData>(context)
                            .todayWeather
                            .currentWeather
                            ?.cond as int,
                        Weather.isNight(Date.hour(
                            Provider.of<WeatherData>(context)
                                .todayWeather
                                .currentWeather
                                ?.stamp as int))),
                    size: 60.0,
                    color: Weather.getTimeColor(
                        Provider.of<WeatherData>(context)
                            .todayWeather
                            .currentWeather
                            ?.stamp as int)),
                const SizedBox(
                  height: 10.0,
                  width: double.infinity,
                ),
                Text(
                    '${Provider.of<WeatherData>(context).todayWeather.currentWeather?.temp.round()}°',
                    textAlign: TextAlign.center,
                    style: WeatherTextStyle.title),
                Text(
                    '${Provider.of<WeatherData>(context).city}, ${Provider.of<WeatherData>(context).country}',
                    textAlign: TextAlign.center,
                    style: WeatherTextStyle.subTitle),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: WeatherCard(
                        tempreture:
                            '${Provider.of<WeatherData>(context).todayWeather.morningWeather?.temp.round()}°',
                        hour: Date.hourAndMinutes(
                            Provider.of<WeatherData>(context)
                                .todayWeather
                                .morningWeather
                                ?.stamp as int),
                        cardBackgroundColor: Weather.getTimeColor(Date.hour(
                            Provider.of<WeatherData>(context)
                                .todayWeather
                                .morningWeather
                                ?.stamp as int)),
                        icon: Weather.getIcon(
                            Provider.of<WeatherData>(context)
                                .todayWeather
                                .currentWeather
                                ?.cond as int,
                            Weather.isNight(Date.hour(
                                Provider.of<WeatherData>(context)
                                    .todayWeather
                                    .morningWeather
                                    ?.stamp as int))),
                      ),
                    ),
                    Expanded(
                      child: WeatherCard(
                        tempreture:
                            '${Provider.of<WeatherData>(context).todayWeather.dayWeather?.temp.round()}°',
                        hour: Date.hourAndMinutes(
                            Provider.of<WeatherData>(context)
                                .todayWeather
                                .dayWeather
                                ?.stamp as int),
                        cardBackgroundColor: Weather.getTimeColor(Date.hour(
                            Provider.of<WeatherData>(context)
                                .todayWeather
                                .dayWeather
                                ?.stamp as int)),
                        icon: Weather.getIcon(
                            Provider.of<WeatherData>(context)
                                .todayWeather
                                .dayWeather
                                ?.cond as int,
                            Weather.isNight(Date.hour(
                                Provider.of<WeatherData>(context)
                                    .todayWeather
                                    .dayWeather
                                    ?.stamp as int))),
                      ),
                    ),
                    Expanded(
                      child: WeatherCard(
                        tempreture:
                            '${Provider.of<WeatherData>(context).todayWeather.nightWeather?.temp.round()}°',
                        hour: Date.hourAndMinutes(
                            Provider.of<WeatherData>(context)
                                .todayWeather
                                .nightWeather
                                ?.stamp as int),
                        cardBackgroundColor: Weather.getTimeColor(Date.hour(
                            Provider.of<WeatherData>(context)
                                .todayWeather
                                .nightWeather
                                ?.stamp as int)),
                        icon: Weather.getIcon(
                            Provider.of<WeatherData>(context)
                                .todayWeather
                                .nightWeather
                                ?.cond as int,
                            Weather.isNight(Date.hour(
                                Provider.of<WeatherData>(context)
                                    .todayWeather
                                    .nightWeather
                                    ?.stamp as int))),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const Text('Additional Info', style: WeatherTextStyle.subTitle),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Desc(
                          mainText: 'Wind:',
                          subText:
                              '${Provider.of<WeatherData>(context).todayWeather.windSpeed} km/h',
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Desc(
                          mainText: 'Humidity:',
                          subText:
                              '${Provider.of<WeatherData>(context).todayWeather.humidity} %',
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Desc(
                          mainText: 'Pressure:',
                          subText:
                              '${Provider.of<WeatherData>(context).todayWeather.pressure} hPa',
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Desc(
                          mainText: 'UV:',
                          subText:
                              '${Provider.of<WeatherData>(context).todayWeather.uv}',
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Text(
                  'Last update ${Provider.of<WeatherData>(context).lastUpdate}',
                  style: WeatherTextStyle.smallGrey,
                  textAlign: TextAlign.center,
                )
              ],
            ),
          );
  }
}
