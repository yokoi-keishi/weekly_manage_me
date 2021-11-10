import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:weekly_manage_me/models/notification_manager.dart';
import 'package:weekly_manage_me/screens/setting_screen.dart';
import 'package:weekly_manage_me/screens/todo_screen.dart';
import 'package:weekly_manage_me/widgets/home_widgets/date_picker_time_line.dart';
import 'package:badges/badges.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';

import 'package:weekly_manage_me/widgets/home_widgets/home_main_screen.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:weekly_manage_me/main.dart';
import 'package:weekly_manage_me/constants.dart';
import 'package:weekly_manage_me/models/task.dart';
import 'package:weekly_manage_me/models/date_manager.dart';

import 'package:weekly_manage_me/models/todo.dart';

import 'add_task_screen.dart';

class HomeScreen extends ConsumerWidget {
  HomeScreen({Key? key}) : super(key: key);

  final DateManager dateManager = DateManager();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    // todos count badge
    List<int> badgeCount = watch(todoProvider)
        .todoBox
        .keys
        .cast<int>()
        .where((element) =>
            watch(todoProvider).todoBox.get(element)!.complete == false)
        .toList();

    // icon badge
    List<int> appIconBadgeCount = [];
    appIconBadgeCount = watch(taskProvider)
        .taskBox
        .keys
        .cast<int>()
        .where((element) =>
            watch(taskProvider).taskBox.get(element)!.weekly ==
            DateTime.now().weekday)
        .toList();
    FlutterAppBadger.updateBadgeCount(appIconBadgeCount.length);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, color: Colors.black),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddTaskScreen()));
        },
      ),
      backgroundColor: watch(dateProvider).changeColor(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: kPadding * 2, vertical: kPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Hello, Keishi',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${watch(dateProvider).sendWeekly()}曜日のタスク',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.settings),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SettingScreen()));
                        },
                      ),
                      Badge(
                        position: BadgePosition.topEnd(top: -3, end: -3),
                        badgeContent: badgeCount.length != 0
                            ? Text(
                                badgeCount.length.toString(),
                                style: TextStyle(color: Colors.white),
                              )
                            : null,
                        showBadge: badgeCount.length != 0 ? true : false,
                        child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TodoScreen()));
                            },
                            icon: Icon(Icons.task)),
                      ),
                    ],
                  )
                ],
              ),
            ),
            datePickerTimeLine(context, watch),
            const HomeMainScreen()
          ],
        ),
      ),
    );
  }
}
