import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:weekly_manage_me/main.dart';

DatePicker datePickerTimeLine(BuildContext context, ScopedReader watch) {
  return DatePicker(
    DateTime.now().subtract(const Duration(days: 2)),
    initialSelectedDate: DateTime.now(),
    selectionColor: Colors.black,
    selectedTextColor: Colors.white,
    daysCount: 7,
    onDateChange: (date) {
      watch(dateProvider).changeDate(date);
      print(context.read(dateProvider).selectedDate.weekday);
    },
  );
}
