import 'package:flutter/foundation.dart';
import 'package:weekly_manage_me/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class DateManager extends ChangeNotifier {
  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;

  void changeDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  Color changeColor() {
    switch (_selectedDate.weekday) {
      case 1:
        return mondayColor;
      case 2:
        return tuesdayColor;
      case 3:
        return wednesdayColor;
      case 4:
        return thursdayColor;
      case 5:
        return fridayColor;
      case 6:
        return saturdayColor;
      case 7:
        return sundayColor;
      default:
        return mondayColor;
    }
  }

  String sendWeekly() {
    switch (_selectedDate.weekday) {
      case 1:
        return '月';
      case 2:
        return '火';
      case 3:
        return '水';
      case 4:
        return '木';
      case 5:
        return '金';
      case 6:
        return '土';
      case 7:
        return '日';
      default:
        return '月';
    }
  }

  Day notificationWeekly(int sentWeekly) {
    switch (sentWeekly) {
      case 1:
        return Day.monday;
      case 2:
        return Day.tuesday;
      case 3:
        return Day.wednesday;
      case 4:
        return Day.thursday;
      case 5:
        return Day.friday;
      case 6:
        return Day.saturday;
      case 7:
        return Day.sunday;
      default:
        return Day.monday;
    }
  }
}
