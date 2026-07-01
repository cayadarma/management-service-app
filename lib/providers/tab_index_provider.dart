import 'package:flutter/material.dart';

class TabIndexProvider with ChangeNotifier {
  int _index = 0;

  int get index => _index;

  void changeTab(int newIndex) {
    _index = newIndex;
    notifyListeners();
  }
}
