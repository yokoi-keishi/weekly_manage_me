import 'package:flutter/material.dart';
import 'package:weekly_manage_me/models/task.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:weekly_manage_me/widgets/home_widgets/weekly_card.dart';

GridView taskGridView(List<int> keys, Box<Task> tasks) {
  return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: keys.length,
      shrinkWrap: true,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemBuilder: (context, index) {
        int key = keys[index];
        Task? task = tasks.get(key);
        return WeeklyCard(taskNumber: key, task: task!);
      });
}
