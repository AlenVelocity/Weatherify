import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static Future<void> storeDouble(String key, double value) async {
    SharedPreferences perf = await SharedPreferences.getInstance();
    perf.setDouble(key, value);
  }

  static Future<void> storeString(String key, String value) async {
    SharedPreferences perf = await SharedPreferences.getInstance();
    perf.setString(key, value);
  }

  // T or null
  static Future<dynamic> get(String key) async {
    SharedPreferences perf = await SharedPreferences.getInstance();
    return perf.get(key);
  }
}
