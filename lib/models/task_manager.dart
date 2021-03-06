import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:weekly_manage_me/models/task.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';

class TaskManager extends ChangeNotifier {
  final Box<Task> taskBox = Hive.box<Task>('task');
  String? _taskString;
  String? get taskString => _taskString;
  DateTime _selectedTime = DateTime.now();
  DateTime get selectedTime => _selectedTime;

  List<int> _selectedWeekList = [];
  List<int> get selectedWeekList => _selectedWeekList;
  bool _isSundayTapped = false;
  bool get isSundayTapped => _isSundayTapped;
  bool _isMondayTapped = false;
  bool get isMondayTapped => _isMondayTapped;
  bool _isTuesdayTapped = false;
  bool get isTuesdayTapped => _isTuesdayTapped;
  bool _isWednesdayTapped = false;
  bool get isWednesdayTapped => _isWednesdayTapped;
  bool _isThursdayTapped = false;
  bool get isThursdayTapped => _isThursdayTapped;
  bool _isFridayTapped = false;
  bool get isFridayTapped => _isFridayTapped;
  bool _isSaturdayTapped = false;
  bool get isSaturdayTapped => _isSaturdayTapped;

  void iconBadgeUpdateAction() {
    // icon badge
    List<int> appIconBadgeCount = [];
    appIconBadgeCount = taskBox.keys
        .cast<int>()
        .where((element) =>
            taskBox.get(element)!.weekly == DateTime.now().weekday &&
            taskBox.get(element)!.complete == false)
        .toList();
    FlutterAppBadger.updateBadgeCount(appIconBadgeCount.length);
  }

  Task? getTask(int index) {
    return taskBox.getAt(index);
  }

  void addTask(Task task) async {
    await taskBox.add(task);
    notifyListeners();
  }

  void deleteTask(int taskNumber) async {
    await taskBox.delete(taskNumber);
    notifyListeners();
  }

  void taskStatusChange(int taskNumber, Task task) async {
    task.toToggle();
    await taskBox.put(taskNumber, task);
    notifyListeners();
  }

  void allTaskStateCheck(BuildContext context, Task task) {
    var todayTaskList = taskBox.keys.cast<int>().where(
        (element) => taskBox.get(element)!.weekly == DateTime.now().weekday);
    var completedTaskList = taskBox.keys.cast<int>().where((element) =>
        taskBox.get(element)!.complete == true &&
        taskBox.get(element)!.weekly == DateTime.now().weekday);

    print('todayTaskCount: $todayTaskList');
    print('completedTaskCount: $completedTaskList');

    if (todayTaskList.length == completedTaskList.length) {
      if (task.weekly == DateTime.now().weekday) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.SUCCES,
          animType: AnimType.SCALE,
          title: '????Congratulations????',
          desc: '??????????????????????????????????????????????????????',
          btnOkOnPress: () {},
        ).show();
      }
    }
  }

  // reset task complete
  void resetCompleteTask() {
    var numbers = taskBox.keys.cast<int>().toList();

    for (var number in numbers) {
      if (taskBox.get(number)!.weekly == DateTime.now().weekday) {
        continue;
      }
      var task = taskBox.get(number);
      resetTaskStatus(number, task!);
    }
  }

  void resetTaskStatus(int taskNumber, Task task) async {
    task.complete = false;
    await taskBox.put(taskNumber, task);
    notifyListeners();
  }

  void changeDateToTime(DateTime time) {
    _selectedTime = time;
    notifyListeners();
  }

  void selectWeeklyTask(int selectedWeek) {
    switch (selectedWeek) {
      case 1:
        _isMondayTapped = !_isMondayTapped;
        if (_isMondayTapped) {
          _selectedWeekList.add(selectedWeek);
        } else {
          _selectedWeekList.remove(selectedWeek);
        }
        notifyListeners();
        break;

      case 2:
        _isTuesdayTapped = !_isTuesdayTapped;
        if (_isTuesdayTapped) {
          _selectedWeekList.add(selectedWeek);
        } else {
          _selectedWeekList.remove(selectedWeek);
        }
        notifyListeners();
        break;

      case 3:
        _isWednesdayTapped = !_isWednesdayTapped;
        if (_isWednesdayTapped) {
          _selectedWeekList.add(selectedWeek);
        } else {
          _selectedWeekList.remove(selectedWeek);
        }
        notifyListeners();
        break;

      case 4:
        _isThursdayTapped = !_isThursdayTapped;
        if (_isThursdayTapped) {
          _selectedWeekList.add(selectedWeek);
        } else {
          _selectedWeekList.remove(selectedWeek);
        }
        notifyListeners();
        break;

      case 5:
        _isFridayTapped = !_isFridayTapped;
        if (_isFridayTapped) {
          _selectedWeekList.add(selectedWeek);
        } else {
          _selectedWeekList.remove(selectedWeek);
        }
        notifyListeners();
        break;

      case 6:
        _isSaturdayTapped = !_isSaturdayTapped;
        if (_isSaturdayTapped) {
          _selectedWeekList.add(selectedWeek);
        } else {
          _selectedWeekList.remove(selectedWeek);
        }
        notifyListeners();
        break;

      case 7:
        _isSundayTapped = !_isSundayTapped;
        if (_isSundayTapped) {
          _selectedWeekList.add(selectedWeek);
        } else {
          _selectedWeekList.remove(selectedWeek);
        }
        notifyListeners();
        break;

      default:
        break;
    }
  }

  void clearWeekList() {
    _selectedWeekList.clear();
    _isSundayTapped = false;
    _isMondayTapped = false;
    _isTuesdayTapped = false;
    _isWednesdayTapped = false;
    _isThursdayTapped = false;
    _isFridayTapped = false;
    _isSaturdayTapped = false;
    notifyListeners();
  }

  bool sendWeeklyStatus(int selectedWeek) {
    switch (selectedWeek) {
      case 1:
        return _isMondayTapped;
      case 2:
        return _isTuesdayTapped;
      case 3:
        return _isWednesdayTapped;
      case 4:
        return _isThursdayTapped;
      case 5:
        return _isFridayTapped;
      case 6:
        return _isSaturdayTapped;
      case 7:
        return _isSundayTapped;
      default:
        return _isSundayTapped;
    }
  }
}
