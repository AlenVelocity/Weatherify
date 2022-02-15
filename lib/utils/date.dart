import 'package:date_time_format/date_time_format.dart';

class Date {
  static String now() {
    return DateTimeFormat.format(DateTime.now(), format: 'Y-m-d H:i');
  }

  static String day(int timestamp) {
    return DateTimeFormat.format(
      DateTime.fromMillisecondsSinceEpoch(timestamp * 1000),
      format: 'l',
    );
  }

  static String hourAndMinutes(int timestamp) {
    return DateTimeFormat.format(
      DateTime.fromMillisecondsSinceEpoch(timestamp * 1000),
      format: 'H:i',
    );
  }

  static String date(int timestamp) {
    return DateTimeFormat.format(
      DateTime.fromMillisecondsSinceEpoch(timestamp * 1000),
      format: 'Y-m-d',
    );
  }

  static int hour(int timeStamp) {
    return int.parse(
      DateTimeFormat.format(
        DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000),
        format: 'H',
      ),
    );
  }
}
