import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:weekly_manage_me/models/att_model.dart';
import 'package:weekly_manage_me/models/task_manager.dart';
import 'package:weekly_manage_me/screens/todo_screen.dart';
import 'package:weekly_manage_me/widgets/home_widgets/date_picker_time_line.dart';
import 'package:badges/badges.dart';

import 'package:weekly_manage_me/widgets/home_widgets/home_main_screen.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:weekly_manage_me/main.dart';
import 'package:weekly_manage_me/constants.dart';
import 'package:weekly_manage_me/models/date_manager.dart';

import 'add_task_screen.dart';

class HomeScreen extends ConsumerWidget {
  HomeScreen({Key? key}) : super(key: key);

  final DateManager dateManager = DateManager();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    // att 対応
    WidgetsBinding.instance?.addPostFrameCallback((_) => AttModel.initPlugin());

    // todos count badge
    var taskManager = TaskManager();
    taskManager.iconBadgeUpdateAction();

    List<TargetFocus> targets = [];
    GlobalKey addTaskButton = GlobalKey();
    GlobalKey todoButton = GlobalKey();
    GlobalKey appTitle = GlobalKey();

    void initTargets() {
      targets.clear();
      targets.add(
        TargetFocus(
          identify: "addTaskButton",
          keyTarget: addTaskButton,
          alignSkip: Alignment.bottomLeft,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              builder: (context, controller) {
                return Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.thumb_up_off_alt_rounded,
                        color: Colors.orangeAccent.shade100,
                        size: 100,
                      ),
                      const SizedBox(height: 10),
                      kTutorialLargeTextWidget("習慣にするタスクを追加"),
                      const SizedBox(height: 10),
                      kTutorialSmallTextWidget("ボタンを押すと習慣追加画面へ移ります。"),
                      kTutorialSmallTextWidget("題名と曜日だけでOKです。"),
                      kTutorialSmallTextWidget("習慣は長押しで削除できます。"),
                      kTutorialSmallTextWidget("全ての習慣は自動で通知がONになります。"),
                      kTutorialSmallTextWidget("忘れないように通知がくるので便利です！"),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      );

      targets.add(
        TargetFocus(
          identify: "todoButton",
          keyTarget: todoButton,
          alignSkip: Alignment.bottomLeft,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              builder: (context, controller) {
                return Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.note_alt_outlined,
                        color: Colors.lightBlue.shade100,
                        size: 100,
                      ),
                      const SizedBox(height: 10),
                      kTutorialLargeTextWidget("一度きりのタスクを追加"),
                      const SizedBox(height: 10),
                      kTutorialSmallTextWidget("ボタンを押すとタスク追加画面へ移ります。"),
                      kTutorialSmallTextWidget("右下のボタンでタスクを追加できます。"),
                      kTutorialSmallTextWidget("題名だけでOKです。"),
                      kTutorialSmallTextWidget("チェックつけてシンプルに状況も確認できます。"),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      );

      targets.add(
        TargetFocus(
          identify: "appTitle",
          keyTarget: appTitle,
          alignSkip: Alignment.bottomLeft,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              builder: (context, controller) {
                return Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 50),
                      star5IconsContainer(),
                      const SizedBox(height: 10),
                      kTutorialLargeTextWidget("「メモるん」レビューで活性化"),
                      const SizedBox(height: 10),
                      kTutorialSmallTextWidget("レビューは開発者への支援になります。"),
                      kTutorialSmallTextWidget("アイデアや要望があれば、"),
                      kTutorialSmallTextWidget('レビューでコメントお願いします。'),
                      kTutorialSmallTextWidget("そして気に入れば周りに広めてください！"),
                      kTutorialSmallTextWidget('随時機能のアップデートしていきます。'),
                      const SizedBox(height: 10),
                      kTutorialSmallTextWidget('アプリは毎日開いて習慣活動してみてください'),
                      const SizedBox(height: 10),
                      kTutorialSmallTextWidget("それでは良い習慣活動を"),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      );
    }

    void showTutorial() {
      initTargets();
      TutorialCoachMark(
        context,
        targets: targets,
        colorShadow: Colors.red,
        textSkip: "SKIP",
        paddingFocus: 10,
        opacityShadow: 0.8,
        onFinish: () {
          print("finish");
        },
        onClickTarget: (target) {
          print('onClickTarget: $target');
        },
        onSkip: () {
          print("skip");
        },
        onClickOverlay: (target) {
          print('onClickOverlay: $target');
        },
      ).show();
    }

    void checkTutorial() async {
      SharedPreferences pref = await SharedPreferences.getInstance();
      if (pref.getBool('isAlreadyFirstLaunch') != true) {
        showTutorial();
      }
      await pref.setBool('isAlreadyFirstLaunch', true);
    }

    checkTutorial();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        key: addTaskButton,
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
                      Text(
                        'Memorun',
                        key: appTitle,
                        style: kAppTitleTextStyle,
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
                      // IconButton(
                      //   icon: const Icon(Icons.settings),
                      //   onPressed: () {
                      //     Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (context) => SettingScreen()));
                      //   },
                      // ),
                      Badge(
                        padding: const EdgeInsets.all(kPadding / 1.5),
                        position: BadgePosition.topEnd(top: -5, end: -5),
                        badgeContent:
                            context.read(todoProvider).badgeCount().isNotEmpty
                                ? Text(
                                    context
                                        .read(todoProvider)
                                        .badgeCount()
                                        .length
                                        .toString(),
                                    style: const TextStyle(color: Colors.white),
                                  )
                                : null,
                        showBadge:
                            context.read(todoProvider).badgeCount().isNotEmpty
                                ? true
                                : false,
                        child: IconButton(
                          key: todoButton,
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const TodoScreen()));
                          },
                          icon: const Icon(
                            Icons.note_alt_outlined,
                            size: 35,
                          ),
                        ),
                      )
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
