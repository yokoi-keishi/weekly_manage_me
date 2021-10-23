import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:weekly_manage_me/main.dart';
import 'package:flutter/material.dart';
import 'package:weekly_manage_me/screens/add_task_screen.dart';
import 'package:weekly_manage_me/screens/home_screen.dart';
import 'package:weekly_manage_me/screens/todo_screen.dart';

class HomeBottomScreen extends ConsumerWidget {
  const HomeBottomScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    var navProvider = watch(navigationProvider);

    return ConvexAppBar(
      style: TabStyle.fixedCircle,
      items: const [
        TabItem(icon: Icons.home, title: 'Home'),
        TabItem(icon: Icons.add, title: 'Add'),
        TabItem(icon: Icons.task, title: 'Todos'),
      ],
      initialActiveIndex: navProvider.selectedIndex,
      onTap: (int i) {
        if (navProvider.selectedIndex == i) return;
        switch (i) {
          case 0:
            Navigator.pushNamed(context, HomeScreen.id);
            navProvider.changeSelectedIndex(i);
            break;
          case 1:
            showBarModalBottomSheet(
              expand: true,
              context: context,
              backgroundColor: Colors.transparent,
              builder: (context) => AddTaskScreen(),
            );
            break;
          case 2:
            Navigator.pushNamed(context, TodoScreen.id);
            navProvider.changeSelectedIndex(i);
            break;
          default:
            Navigator.pushNamed(context, HomeScreen.id);
            navProvider.changeSelectedIndex(i);
        }
      },
    );
  }
}
