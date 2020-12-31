import 'package:flutter/material.dart';
import 'package:Movie/infrastructure/infrastructure.dart';


extension DateTimeExtensions on DateTime {
  bool isNullOrEmpty() => this == null || year == DefaultValues.dateTimeValue.year;
  DateTime orDefault() => this ?? DefaultValues.dateTimeValue;
  DateTime setTimeOfDay(TimeOfDay time) => DateTime(year, month, day, time.hour, time.minute);
}
