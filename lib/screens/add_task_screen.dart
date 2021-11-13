import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weekly_manage_me/main.dart';
import 'package:weekly_manage_me/models/notification_manager.dart';
import 'package:weekly_manage_me/models/task.dart';
import 'package:weekly_manage_me/models/task_manager.dart';

import '../constants.dart';

class AddTaskScreen extends ConsumerWidget {
  AddTaskScreen({Key? key}) : super(key: key);

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

  Map cards = {
    0: {'title': '掃除をする', 'icon': const Icon(Icons.cleaning_services_outlined)},
    1: {'title': 'ゴミ捨てをする', 'icon': const Icon(Icons.delete_sweep_outlined)},
    2: {
      'title': '洗濯をする',
      'icon': const Icon(Icons.local_laundry_service_outlined)
    },
    3: {'title': '買い物をする', 'icon': const Icon(Icons.shopping_cart_outlined)},
    4: {'title': '勉強をする', 'icon': const Icon(Icons.school_outlined)},
    5: {'title': 'ヨガをする', 'icon': const Icon(Icons.self_improvement_outlined)},
    6: {'title': 'ジムに行く', 'icon': const Icon(Icons.fitness_center_outlined)},
  };

  void supportTitleButtonMethod(String text, ScopedReader watch) {
    textEditingController.text = text;
    watch(taskProvider).changeTaskString(textEditingController.text);
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: watch(dateProvider).changeColor(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kPadding),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            '週間タスクを決めましょう',
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 20),
          TextField(
            style: kSimpleTextStyle,
            controller: textEditingController,
            decoration: kTextFieldDecoration.copyWith(hintText: '例：掃除をする'),
            onChanged: (value) {
              watch(taskProvider).changeTaskString(value);
            },
          ),
          const SizedBox(height: 20),
          Row(children: weekSelection()),
          const SizedBox(height: 20),
          Material(
            color: Colors.black45,
            elevation: 6.0,
            borderRadius: BorderRadius.circular(10),
            child: MaterialButton(
              minWidth: 250,
              child: const Text(
                '決定',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                if (context.read(taskProvider).taskString == null) {
                  return;
                }
                final taskManager = TaskManager();
                for (int weekday in watch(taskProvider).selectedWeekList) {
                  taskManager.addTask(Task(
                      title: context.read(taskProvider).taskString!,
                      weekly: weekday));
                }
                watch(taskProvider).changePush(false);
                watch(taskProvider).clearWeekList();
                taskManager.iconBadgeUpdateAction();
                Navigator.pop(context);
                textEditingController.clear();
                // notification setting
                final notificationManager = NotificationManager();
                notificationManager.setNotification();
              },
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(kPadding),
            alignment: Alignment.centerLeft,
            child: Text(
              '例えば・・・',
              style: kSimpleTextStyle.copyWith(fontSize: 16),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cards.length,
                  itemBuilder: (context, index) {
                    var card = cards[index];
                    if (card != null) {
                      return SupportTitleCard(
                          icon: card['icon'] as Icon,
                          onPressed: () {
                            supportTitleButtonMethod(
                                card['title'] as String, watch);
                          },
                          textString: card['title'] as String);
                    } else {
                      return Text('no view');
                    }
                  }),
            ),
          ),
        ]),
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
            watch(taskProvider).selectWeeklyTask(weeklyCount);
          },
          child: Card(
            color: watch(taskProvider).sendWeeklyStatus(weeklyCount)
                ? Colors.lightBlue
                : Colors.white,
            elevation: 6.0,
            child: Padding(
              padding: const EdgeInsets.all(kPadding),
              child: Center(
                  child: Text(
                weeklyString,
                style: kSimpleTextStyle.copyWith(
                    color: watch(taskProvider).sendWeeklyStatus(weeklyCount)
                        ? Colors.white
                        : Colors.black54),
              )),
            ),
          )),
    );
  }
}

class SupportTitleCard extends StatelessWidget {
  const SupportTitleCard({
    Key? key,
    required this.icon,
    required this.onPressed,
    required this.textString,
  }) : super(key: key);

  final Icon icon;
  final String textString;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Card(
        child: ListTile(
          leading: icon,
          title: Text(
            textString,
            style: kSimpleTextStyle,
          ),
        ),
      ),
    );
  }
}
