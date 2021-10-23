import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'dart:math';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends ChangeNotifier {
  @HiveField(0)
  final String title;
  @HiveField(1)
  bool complete = false;
  @HiveField(2)
  int weekly = 1;
  @HiveField(3)
  int id = Random().nextInt(99999999);

  Task({required this.title, required this.weekly});

  void toToggle() {
    complete = !complete;
    notifyListeners();
  }
}
