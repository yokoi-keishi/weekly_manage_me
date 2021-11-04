import 'package:flutter/material.dart';
import 'package:weekly_manage_me/models/date_manager.dart';
import 'package:weekly_manage_me/models/navigation_manager.dart';
import 'package:weekly_manage_me/models/task.dart';
import 'package:weekly_manage_me/models/task_manager.dart';
import 'package:weekly_manage_me/models/todo.dart';
import 'package:weekly_manage_me/screens/home_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'models/notification_manager.dart';
import 'models/setting_manager.dart';
import 'models/todo_manager.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  await Hive.openBox<Task>('task');
  Hive.registerAdapter(TodoAdapter());
  await Hive.openBox<Todo>('todo');

  WidgetsFlutterBinding.ensureInitialized();
  NotificationManager().init();

  runApp(const ProviderScope(child: MyApp()));
}

final taskProvider = ChangeNotifierProvider((ref) => TaskManager());
final todoProvider = ChangeNotifierProvider((ref) => TodoManager());
final dateProvider = ChangeNotifierProvider((ref) => DateManager());
final navigationProvider = ChangeNotifierProvider((ref) => NavigationManager());
final settingProvider = ChangeNotifierProvider((ref) => SettingManager());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

// initialRoute: HomeScreen.id,
// routes: {
// HomeScreen.id: (context) => HomeScreen(),
// AddTaskScreen.id: (context) => AddTaskScreen(),
// SettingScreen.id: (context) => SettingScreen(),
// TodoScreen.id: (context) => TodoScreen(),
// },
