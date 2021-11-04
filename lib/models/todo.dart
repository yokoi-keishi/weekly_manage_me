import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

part 'todo.g.dart';

@HiveType(typeId: 1)
class Todo extends ChangeNotifier {
  @HiveField(0)
  final String title;
  @HiveField(1)
  bool complete = false;

  Todo({required this.title});

  void toToggle() {
    complete = !complete;
    notifyListeners();
  }
}
