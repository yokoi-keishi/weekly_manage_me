import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'todo.dart';

class TodoManager extends ChangeNotifier {
  final Box<Todo> todoBox = Hive.box<Todo>('todo');

  Todo? getTodo(int index) {
    return todoBox.getAt(index);
  }

  void addTodo(Todo todo) async {
    await todoBox.add(todo);
    notifyListeners();
  }

  void deleteTodo(int todoNumber) async {
    await todoBox.delete(todoNumber);
    notifyListeners();
  }

  void changeTodoState(int todoNumber, Todo todo) async {
    todo.toToggle();
    await todoBox.putAt(todoNumber, todo);
    notifyListeners();
  }
}
