import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weekly_manage_me/main.dart';
import 'package:weekly_manage_me/models/todo.dart';
import 'package:weekly_manage_me/models/todo_manager.dart';

import 'package:weekly_manage_me/constants.dart';

class TodoScreen extends ConsumerWidget {
  const TodoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    TextEditingController textEditingController = TextEditingController();
    Box<Todo> todoBox = Hive.box<Todo>('todo');
    var todoManager = TodoManager();
    String? todoTitleString;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          child: Icon(Icons.add, color: Colors.black),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) => Dialog(
                      child: Padding(
                        padding: const EdgeInsets.all(kPadding * 2),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '新しいTodoが追加できます',
                              style: kSimpleTextStyle.copyWith(fontSize: 18),
                            ),
                            const SizedBox(height: 20),
                            TextField(
                              textDirection: TextDirection.ltr,
                              autofocus: true,
                              controller: textEditingController,
                              onChanged: (value) {
                                todoTitleString = value;
                              },
                              decoration: kTextFieldDecoration.copyWith(
                                  hintText: '例：航空券を予約する'),
                            ),
                            const SizedBox(height: 20),
                            Material(
                              color: Colors.black45,
                              elevation: 6.0,
                              borderRadius: BorderRadius.circular(10),
                              child: MaterialButton(
                                  minWidth: 150,
                                  child: const Text(
                                    '決定',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () {
                                    if (todoTitleString != "") {
                                      todoManager.addTodo(
                                          Todo(title: todoTitleString!));
                                      textEditingController.clear();
                                      Navigator.pop(context);
                                    }
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ));
          },
        ),
        backgroundColor: watch(dateProvider).changeColor(),
        body: Padding(
          padding: const EdgeInsets.all(kPadding),
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: SingleChildScrollView(
                  child: ValueListenableBuilder(
                    valueListenable: todoBox.listenable(),
                    builder: (context, Box<Todo> todos, _) {
                      List<int>? ongoings;
                      ongoings = todos.keys
                          .cast<int>()
                          .where((element) =>
                              todos.get(element)!.complete == false)
                          .toList();

                      return Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: kPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'やること',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: ongoings.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  int key = ongoings![index];
                                  Todo? todo = todos.get(key);
                                  return Card(
                                    child: ListTile(
                                      leading: Checkbox(
                                        value: todo!.complete,
                                        onChanged: (bool? value) {
                                          watch(todoProvider)
                                              .changeTodoState(key, todo);
                                        },
                                      ),
                                      title: Text(
                                        todo.title,
                                        style: todo.complete
                                            ? TextStyle(
                                                decoration:
                                                    TextDecoration.lineThrough)
                                            : TextStyle(),
                                      ),
                                    ),
                                  );
                                }),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(kPadding),
                child: Divider(
                  color: Colors.black,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: ValueListenableBuilder(
                    valueListenable: todoBox.listenable(),
                    builder: (context, Box<Todo> todos, _) {
                      List<int>? completeKeys;

                      completeKeys = todos.keys
                          .cast<int>()
                          .where(
                              (element) => todos.get(element)!.complete == true)
                          .toList();

                      return Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: kPadding),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '完了',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: completeKeys.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      int key = completeKeys![index];
                                      Todo? todo = todos.get(key);
                                      return Card(
                                        child: ListTile(
                                          leading: Checkbox(
                                            value: todo!.complete,
                                            onChanged: (bool? value) {
                                              watch(todoProvider)
                                                  .changeTodoState(key, todo);
                                            },
                                          ),
                                          title: Text(
                                            todo.title,
                                            style: todo.complete
                                                ? TextStyle(
                                                    decoration: TextDecoration
                                                        .lineThrough)
                                                : TextStyle(),
                                          ),
                                        ),
                                      );
                                    })
                              ]));
                    },
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
