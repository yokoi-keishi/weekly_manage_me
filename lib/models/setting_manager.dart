import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SettingManager extends ChangeNotifier {
  bool _isTap = false;
  bool get isTap => _isTap;
  bool _isNotificationStatus = false;
  bool get isNotificationStatus => _isNotificationStatus;

  void changeNotificationStatus() {
    _isNotificationStatus = !_isNotificationStatus;
    notifyListeners();
  }

  void changeTap() {
    _isTap = !_isTap;
    notifyListeners();
  }
}
