import 'package:intl/intl.dart';

class Formatter {
  static String timeToString(DateTime value) {
    return DateFormat.Hm().format(value);
  }

  static String dateToString(DateTime value) {
    return DateFormat.yMd().format(value);
  }

  static String dateTimeToString(DateTime value) {
    return DateFormat.yMd().add_Hm().format(value);
  }

  static String doubleToString(double value, {int decimalPlaces = 2}) {
    return (value ?? 0).toStringAsFixed(decimalPlaces);
  }

  // qty digits ?
  static String qtyToString(double value) {
    return NumberFormat('###.##').format(value ?? 0);
  }

  // money digits ?
  static String moneyToString(double value) {
    return NumberFormat('##0.00').format(value ?? 0);
  }

  static DateFormat dateFormat() {
    return DateFormat.yMd();
  }

  static DateFormat timeFormat() {
    return DateFormat.Hm();
  }

  static DateFormat dateTimeFormat() {
    return DateFormat.yMd().add_Hm();
  }
}
