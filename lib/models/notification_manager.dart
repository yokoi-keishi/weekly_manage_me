import 'dart:ui';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:weekly_manage_me/models/date_manager.dart';
import 'package:weekly_manage_me/models/task_manager.dart';
import 'task.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../main.dart';

class NotificationManager {
  final Box<Task> taskBox = Hive.box<Task>('task');

  late AppLifecycleState _notification;
  AppLifecycleState get notification => _notification;

  Future<void> init() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: null);

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Tokyo'));

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void setNotification() async {
    // notification all cancel
    await flutterLocalNotificationsPlugin.cancelAll();

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const IOSNotificationDetails iOSPlatformChannelSpecifics =
        IOSNotificationDetails(
            // sound: 'example.mp3',
            presentAlert: true,
            presentBadge: true,
            presentSound: true);
    NotificationDetails platformChannelSpecifics = const NotificationDetails(
      iOS: iOSPlatformChannelSpecifics,
      android: androidPlatformChannelSpecifics,
    );

    var time = const Time(21, 56, 0);

    for (var task in taskBox.values) {
      var dateManager = DateManager();
      var notificationWeekly = dateManager.notificationWeekly(task.weekly);
      await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
          task.id,
          'app title',
          task.title,
          notificationWeekly,
          time,
          platformChannelSpecifics);
      print('${task.title}の通知を設定しました。UUIDは${task.id}です');
    }
  }
}

// print(tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)));

// await flutterLocalNotificationsPlugin.zonedSchedule(
//     12346,
//     "通知",
//     "これが表示されたということはスケジュール通知成功だよ",
//     tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
//     platformChannelSpecifics,
//     androidAllowWhileIdle: true,
//     uiLocalNotificationDateInterpretation:
//         UILocalNotificationDateInterpretation.absoluteTime);
