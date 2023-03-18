import 'package:intl/intl.dart';

class TimeUtils {
  getCurrentDate({String format = 'yyyy-MM-dd HH:mm:ss'}) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat(format).format(now);
    return formattedDate;
  }

  formatTime(int timestamp, {String format = 'yyyy-MM-dd HH:mm:ss'}) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    String formattedDate = DateFormat(format).format(dateTime);
    return formattedDate;
  }
}
