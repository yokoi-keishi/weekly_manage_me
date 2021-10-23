import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weekly_manage_me/main.dart';
import 'package:weekly_manage_me/models/task.dart';
import 'package:weekly_manage_me/models/task_manager.dart';

import '../constants.dart';

class AddTaskScreen extends ConsumerWidget {
  AddTaskScreen({Key? key}) : super(key: key);

  static String id = 'AddTaskScreen';

  final TextEditingController textEditingController = TextEditingController();

  List<WeeklyContainer> weekSelection() {
    List<WeeklyContainer> weekContainers = [];
    weekContainers = week
        .map((e) {
          var index = week.indexOf(e);
          return WeeklyContainer(index + 1, weeklyString: e);
        })
        .cast<WeeklyContainer>()
        .toList();
    return weekContainers;
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: watch(dateProvider).changeColor(),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(kPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${watch(dateProvider).sendWeekly()}曜日のタスクを決めましょう',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Text(
                '選択されている曜日を追加できます',
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: textEditingController,
                decoration: kTextFieldDecoration.copyWith(hintText: '掃除する'),
                onChanged: (value) {
                  watch(taskProvider).changeTaskString(value);
                },
              ),
              const SizedBox(height: 20),
              Row(children: weekSelection()),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Push通知の許可'),
                  Switch(
                    value: context.read(taskProvider).isPushed,
                    onChanged: (value) {
                      watch(taskProvider).changePush(value);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Material(
                elevation: 6.0,
                borderRadius: BorderRadius.circular(20),
                child: MaterialButton(
                  child: const Text('決定'),
                  onPressed: () {
                    if (context.read(taskProvider).taskString == null) return;
                    final taskManager = TaskManager();
                    for (int weekday in watch(taskProvider).selectedWeekList) {
                      taskManager.addTask(Task(
                          title: context.read(taskProvider).taskString!,
                          weekly: weekday));
                    }
                    watch(taskProvider).changePush(false);
                    watch(taskProvider).clearWeekList();
                    Navigator.pop(context);
                    textEditingController.clear();
                  },
                ),
              ),
              const SizedBox(height: 20),
              Divider(
                color: Colors.black54,
              ),
              const SizedBox(height: 20),
              Text('例えば、、、'),
              const SizedBox(height: 20),
              Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SupportTitleButton(
                      textString: '🧹掃除をする',
                      onPressed: () {
                        textEditingController.text = '掃除をする';
                        watch(taskProvider)
                            .changeTaskString(textEditingController.text);
                      },
                    ),
                    SupportTitleButton(
                      textString: '🗑ゴミ捨てをする',
                      onPressed: () {
                        textEditingController.text = 'ゴミ捨てをする';
                        watch(taskProvider)
                            .changeTaskString(textEditingController.text);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SupportTitleButton(
                      textString: '👕洗濯をする',
                      onPressed: () {
                        textEditingController.text = '洗濯をする';
                        watch(taskProvider)
                            .changeTaskString(textEditingController.text);
                      },
                    ),
                    SupportTitleButton(
                      textString: '🍚買い物をする',
                      onPressed: () {
                        textEditingController.text = '買い物をする';
                        watch(taskProvider)
                            .changeTaskString(textEditingController.text);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SupportTitleButton(
                      textString: '✏️勉強をする',
                      onPressed: () {
                        textEditingController.text = '勉強をする';
                        watch(taskProvider)
                            .changeTaskString(textEditingController.text);
                      },
                    ),
                    SupportTitleButton(
                      textString: '👨‍💼仕事をする',
                      onPressed: () {
                        textEditingController.text = '仕事をする';
                        watch(taskProvider)
                            .changeTaskString(textEditingController.text);
                      },
                    ),
                  ],
                ),
              ])
            ],
          ),
        ),
      ),
    );
  }
}

class WeeklyContainer extends ConsumerWidget {
  const WeeklyContainer(this.weeklyCount,
      {Key? key, required this.weeklyString})
      : super(key: key);
  final String weeklyString;
  final int weeklyCount;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Expanded(
      child: InkWell(
          onTap: () {
            print(weeklyCount);
            watch(taskProvider).selectWeeklyTask(weeklyCount);
            print(context.read(taskProvider).sendWeeklyStatus(weeklyCount));
            print(context.read(taskProvider).selectedWeekList);
          },
          child: Card(
            color: watch(taskProvider).sendWeeklyStatus(weeklyCount)
                ? Colors.blue
                : Colors.white,
            elevation: 6.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: Text(weeklyString)),
            ),
          )),
    );
  }
}

class SupportTitleButton extends StatelessWidget {
  const SupportTitleButton({
    Key? key,
    required this.textString,
    required this.onPressed,
  }) : super(key: key);

  final String textString;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6.0,
      borderRadius: BorderRadius.circular(20),
      child: MaterialButton(
        child: Text(textString),
        onPressed: onPressed,
      ),
    );
  }
}
