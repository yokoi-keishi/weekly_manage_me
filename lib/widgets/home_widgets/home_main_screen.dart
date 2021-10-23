import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weekly_manage_me/models/task.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weekly_manage_me/widgets/home_widgets/task_grid_view.dart';

import 'package:weekly_manage_me/main.dart';

class HomeMainScreen extends ConsumerWidget {
  const HomeMainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    Box<Task> taskBox = Hive.box<Task>('task');

    return Expanded(
      child: SingleChildScrollView(
        child: ValueListenableBuilder(
          valueListenable: taskBox.listenable(),
          builder: (context, Box<Task> tasks, _) {
            List<int>? keys;

            // keys = tasks.keys.cast<int>().toList();
            keys = tasks.keys
                .cast<int>()
                .where((key) =>
                    tasks.get(key)!.weekly ==
                    watch(dateProvider).selectedDate.weekday)
                .toList();

            return taskGridView(keys, tasks);
          },
        ),
      ),
    );
  }
}
