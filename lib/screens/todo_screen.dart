import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weekly_manage_me/main.dart';

class TodoScreen extends ConsumerWidget {
  const TodoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Scaffold(
      backgroundColor: watch(dateProvider).changeColor(),
      body: Container(),
    );
  }
}
