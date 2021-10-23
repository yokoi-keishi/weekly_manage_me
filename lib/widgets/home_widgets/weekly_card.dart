import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weekly_manage_me/main.dart';
import 'package:weekly_manage_me/models/task.dart';
import 'package:weekly_manage_me/models/task_manager.dart';

import 'package:animate_do/animate_do.dart';

class WeeklyCard extends ConsumerWidget {
  const WeeklyCard({Key? key, required this.taskNumber, required this.task})
      : super(key: key);

  final int taskNumber;
  final Task task;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final taskManager = TaskManager();

    return InkWell(
        onTap: () {
          if (watch(settingProvider).isTap) return;
          taskManager.taskStatusChange(taskNumber, task);
        },
        onLongPress: () {
          taskManager.deleteTask(taskNumber);
        },
        child: Card(
          elevation: 0.0,
          color: const Color(0x00000000),
          child: task.complete
              ? _finishedCard('${task.id}')
              : _unFinishedCard('${task.id}'),
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
        const Text(
          'Clear',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),
        ),
        Text(
          title ?? '',
          style: const TextStyle(color: Colors.white70),
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
    child: Stack(
      alignment: AlignmentDirectional.center,
      children: [
        CircleAvatar(radius: 35, child: const Icon(Icons.cast)),
        Positioned(
          bottom: 0,
          child: Text(
            title ?? '',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
  );
}
