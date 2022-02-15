import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:weatherify/constants/colors.dart';
import 'package:weatherify/constants/text_style.dart';
import 'package:weatherify/models/weather/weather.dart';
import 'package:weatherify/models/weather/weather_info.dart';
import 'package:weatherify/utils/date.dart';
import 'package:weatherify/widgets/desc.dart';

class Weekly extends StatefulWidget {
  const Weekly({Key? key}) : super(key: key);

  @override
  _WeeklyScreenState createState() => _WeeklyScreenState();
}

class _WeeklyScreenState extends State<Weekly> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void deactivate() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weekly Chart',
          style: TextStyle(
              fontFamily: 'Khula',
              color: Colors.black,
              fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0.0,
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: const BottomNavigation(),
      body: const WeeklyWeather(),
    );
  }
}

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int selectedIndex = 0;

  List<BottomNavigationBarItem> getBottomItems() {
    WeatherData weatherData = Provider.of<WeatherData>(context);

    List<BottomNavigationBarItem> list = [];
    for (int i = 0; i < weatherData.weekWeather.length; i++) {
      list.add(BottomNavigationBarItem(
        icon: Icon(
          Weather.getIcon(
              weatherData.weekWeather[i].currentWeather?.cond as int, false),
        ),
        label: Date.day(weatherData.weekWeather[i].currentWeather?.stamp as int)
            .substring(0, 3),
        /* title: Padding(
            padding: const EdgeInsets.only(bottom: 5.0, top: 10.0),
            child: Text(Date.day(
                    weatherData.weekWeather[i].currentWeather?.stamp as int)
                .substring(0, 2)),
          )); */
      ));
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherData>(
      builder: (context, weatherData, child) {
        return getBottomItems().isEmpty
            ? const Center(
                child: CircularProgressIndicator(
                backgroundColor: Colors.blueGrey,
              ))
            : BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                items: getBottomItems(),
                backgroundColor: Colors.white,
                currentIndex: selectedIndex,
                selectedItemColor: const Color(0xFF48567B),
                unselectedItemColor: Grey.translucent,
                showUnselectedLabels: true,
                elevation: 0,
                iconSize: 20.0,
                selectedLabelStyle: const TextStyle(
                    fontFamily: 'Khula', fontWeight: FontWeight.w600),
                unselectedLabelStyle: const TextStyle(
                    fontFamily: 'Khula', fontWeight: FontWeight.w600),
                onTap: (index) {
                  setState(() {
                    selectedIndex = index;
                    Provider.of<WeatherData>(context, listen: false)
                        .setWeeklyIndex(index);
                  });
                });
      },
    );
  }
}

class WeeklyWeather extends StatelessWidget {
  const WeeklyWeather({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherData>(
      builder: (context2, weatherData, child) {
        return Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(
                    Weather.getIcon(
                        weatherData.weekWeather[weatherData.weeklyIndex]
                            .currentWeather?.cond as int,
                        false),
                    size: 30.0,
                    color: Grey.regular,
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  Text(
                    Date.day(weatherData.weekWeather[weatherData.weeklyIndex]
                        .currentWeather?.stamp as int),
                    style: WeatherTextStyle.mediumRegularBlack,
                  ),
                  const Expanded(
                    child: SizedBox(),
                  ),
                  Text(
                    '${weatherData.weekWeather[weatherData.weeklyIndex].maxTemp?.round()}°',
                    style: WeatherTextStyle.mediumRegularBlack,
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    '${weatherData.weekWeather[weatherData.weeklyIndex].minTemp?.round()}°',
                    style: WeatherTextStyle.mediumRegularBlack,
                  )
                ],
              ),
              const SizedBox(
                height: 40.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Desc(
                        mainText: 'Wind',
                        subText:
                            '${weatherData.weekWeather[weatherData.weeklyIndex].windSpeed?.toStringAsFixed(0)} m/h',
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Desc(
                        mainText: 'Humidity',
                        subText:
                            '${weatherData.weekWeather[weatherData.weeklyIndex].humidity} %',
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Desc(
                        mainText: 'Pressure',
                        subText:
                            '${weatherData.weekWeather[weatherData.weeklyIndex].pressure} hPa',
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Desc(
                        mainText: 'UV',
                        subText:
                            '${weatherData.weekWeather[weatherData.weeklyIndex].uv}',
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 60.0,
              ),
              ListWeeklyDetails(
                hour: '9',
                condition: Weather.getCondition(weatherData
                    .weekWeather[weatherData.weeklyIndex]
                    .morningWeather
                    ?.cond as int),
                tempreture:
                    '${weatherData.weekWeather[weatherData.weeklyIndex].morningWeather?.temp.round()}°',
              ),
              const SizedBox(
                height: 20.0,
              ),
              ListWeeklyDetails(
                hour: '15',
                condition: Weather.getCondition(weatherData
                    .weekWeather[weatherData.weeklyIndex]
                    .dayWeather
                    ?.cond as int),
                tempreture:
                    '${weatherData.weekWeather[weatherData.weeklyIndex].dayWeather?.temp.round()}°',
              ),
              const SizedBox(
                height: 20.0,
              ),
              ListWeeklyDetails(
                hour: '21',
                condition: Weather.getCondition(weatherData
                    .weekWeather[weatherData.weeklyIndex]
                    .eveningWeather
                    ?.cond as int),
                tempreture:
                    '${weatherData.weekWeather[weatherData.weeklyIndex].eveningWeather?.temp.round()}°',
              ),
              const SizedBox(
                height: 20.0,
              ),
              ListWeeklyDetails(
                hour: '0',
                condition: Weather.getCondition(weatherData
                    .weekWeather[weatherData.weeklyIndex]
                    .nightWeather
                    ?.cond as int),
                tempreture:
                    '${weatherData.weekWeather[weatherData.weeklyIndex].nightWeather?.temp.round()}°',
              ),
              const SizedBox(
                height: 20.0,
              )
            ],
          ),
        );
      },
    );
  }
}

class ListWeeklyDetails extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const ListWeeklyDetails({
    required this.hour,
    required this.condition,
    required this.tempreture,
  });

  final String hour;
  final String condition;
  final String tempreture;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          hour,
          style: WeatherTextStyle.cardHour.copyWith(color: Colors.black),
        ),
        const SizedBox(
          width: 30.0,
        ),
        Text(
          condition,
          style: WeatherTextStyle.regularBlack,
        ),
        const Expanded(
          child: SizedBox(),
        ),
        Text(
          tempreture,
          style: WeatherTextStyle.mediumRegularBlack,
        )
      ],
    );
  }
}
