import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SettingManager extends ChangeNotifier {
  bool _isTap = false;
  bool get isTap => _isTap;

  void changeTap() {
    _isTap = !_isTap;
    notifyListeners();
  }
}
