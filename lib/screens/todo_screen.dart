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
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('新しいTodo'),
                          TextField(
                            controller: textEditingController,
                            onChanged: (value) {
                              textEditingController.text = value;
                            },
                          ),
                          MaterialButton(onPressed: () {
                            if (textEditingController.text != "") {
                              todoManager.addTodo(
                                  Todo(title: textEditingController.text));
                              textEditingController.clear();
                              Navigator.pop(context);
                            }
                          })
                        ],
                      ),
                    ));
          },
        ),
        backgroundColor: watch(dateProvider).changeColor(),
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: SingleChildScrollView(
                child: ValueListenableBuilder(
                  valueListenable: todoBox.listenable(),
                  builder: (context, Box<Todo> todos, _) {
                    List<int>? keys;

                    keys = todos.keys
                        .cast<int>()
                        .where(
                            (element) => todos.get(element)!.complete == false)
                        .toList();

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: kPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ongoing',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: keys.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                int key = keys![index];
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
              padding: const EdgeInsets.symmetric(horizontal: kPadding * 2),
              child: Divider(
                color: Colors.black,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: ValueListenableBuilder(
                  valueListenable: todoBox.listenable(),
                  builder: (context, Box<Todo> todos, _) {
                    List<int>? keys;

                    keys = todos.keys
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
                                'completed',
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                              ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: keys.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    int key = keys![index];
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
        ));
  }
}
