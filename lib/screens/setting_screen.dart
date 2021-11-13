import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weekly_manage_me/main.dart';
import 'package:weekly_manage_me/models/setting_manager.dart';

class SettingScreen extends ConsumerWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: watch(dateProvider).changeColor(),
      body: ListView(
        children: [
          Card(
            child: ListTile(
              leading: Icon(Icons.notifications),
              title: Text('notification'),
              trailing: Switch(
                  onChanged: (bool value) {
                    var settingManager = SettingManager();
                    settingManager.changeNotificationStatus();
                  },
                  value: watch(settingProvider).isNotificationStatus),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.person),
              title: Text('ユーザー名'),
              trailing: TextButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('ユーザー名変更'),
                              TextField(
                                textAlign: TextAlign.center,
                              ),
                              Material(
                                child: MaterialButton(
                                  onPressed: () {},
                                  child: Text('決定'),
                                ),
                              )
                            ],
                          ),
                        );
                      });
                },
                child: Text('変更'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
