import 'package:shared_preferences/shared_preferences.dart';

Future<void> store(String key, double value) async {
  SharedPreferences perf = await SharedPreferences.getInstance();
  perf.setDouble(key, value);
}

Future<T> get<T>(String key) async {
  SharedPreferences perf = await SharedPreferences.getInstance();
  return perf.get(key) as T;
}
