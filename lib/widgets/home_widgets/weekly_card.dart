import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weekly_manage_me/main.dart';
import 'package:weekly_manage_me/models/notification_manager.dart';
import 'package:weekly_manage_me/models/task.dart';
import 'package:weekly_manage_me/models/task_manager.dart';
import 'package:audioplayers/audioplayers.dart';

class WeeklyCard extends ConsumerWidget {
  const WeeklyCard({Key? key, required this.taskNumber, required this.task})
      : super(key: key);

  final int taskNumber;
  final Task task;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final taskManager = TaskManager();
    final player = AudioCache();

    return InkWell(
        onTap: () {
          if (watch(settingProvider).isTap) return;
          task.complete ? null : player.play('crrect_answer.mp3');
          taskManager.taskStatusChange(taskNumber, task);
        },
        onLongPress: () {
          taskManager.deleteTask(taskNumber);
          // notification setting
          final notificationManager = NotificationManager();
          notificationManager.setNotification();
        },
        child: Card(
          elevation: 0.0,
          color: const Color(0x00000000),
          child: task.complete
              ? _finishedCard(task.title)
              : _unFinishedCard(task.title),
        ));
  }
}

_finishedCard(String? title) {
  return Container(
    decoration: BoxDecoration(
      color: Color(0xFF006666),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('clear'),
        Text(
          title ?? '',
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

_unFinishedCard(String? title) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Center(
      child: Text(
        title ?? '',
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    ),
  );
}
