import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Weather {
  double temp;
  int cond;
  int stamp;

  Weather(this.temp, this.cond, this.stamp);

  /// I hate this
  static IconData getIcon(final int condition, bool night) {
    if (night) {
      if (condition < 300) {
        return FontAwesomeIcons.bolt;
      } else if (condition < 400) {
        return FontAwesomeIcons.cloudSunRain;
      } else if (condition < 600) {
        return FontAwesomeIcons.cloudShowersHeavy;
      } else if (condition < 700) {
        return FontAwesomeIcons.solidSnowflake;
      } else if (condition < 800) {
        return FontAwesomeIcons.smog;
      } else if (condition == 800) {
        return FontAwesomeIcons.solidMoon;
      } else if (condition <= 804) {
        return FontAwesomeIcons.cloud;
      } else {
        return FontAwesomeIcons.info;
      }
    } else {
      if (condition < 300) {
        return FontAwesomeIcons.bolt;
      } else if (condition < 400) {
        return FontAwesomeIcons.cloudMoonRain;
      } else if (condition < 600) {
        return FontAwesomeIcons.cloudShowersHeavy;
      } else if (condition < 700) {
        return FontAwesomeIcons.solidSnowflake;
      } else if (condition < 800) {
        return FontAwesomeIcons.smog;
      } else if (condition == 800) {
        return FontAwesomeIcons.solidSun;
      } else if (condition <= 804) {
        return FontAwesomeIcons.cloud;
      } else {
        return FontAwesomeIcons.info;
      }
    }
  }

  static String getCondition(final int condition) {
    if (condition < 300) {
      return 'thunder';
    } else if (condition < 400) {
      return 'Rain';
    } else if (condition < 600) {
      return 'Rainy';
    } else if (condition < 700) {
      return 'Snow';
    } else if (condition < 800) {
      return 'Smog';
    } else if (condition == 800) {
      return 'Clear';
    } else if (condition <= 804) {
      return 'Cloudy';
    } else {
      return 'Error';
    }
  }

  static bool isNight(final int hour) {
    if (hour < 6) {
      return true;
    } else if (hour < 18) {
      return false;
    } else {
      return true;
    }
  }
}
