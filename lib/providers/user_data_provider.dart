import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserDataProvider with ChangeNotifier {
  List<Map<String, String>> _todayExercises = [];
  List<Map<String, String>> _weeklyReport = [];

  List<Map<String, String>> _routines = [];

  List<Map<String, String>> _dietList = [];

  List<Map<String, String>> get todayExercises => _todayExercises;
  List<Map<String, String>> get weeklyReport => _weeklyReport;

  List<Map<String, String>> get routines => _routines;

  List<Map<String, String>> get dietList => _dietList;

  void addExercise(Map<String, String> exercise) {
    _todayExercises.add(exercise);
    _weeklyReport.add(exercise);
    notifyListeners();
  }

  void addRoutine(Map<String, String> routine) {
    _routines.add(routine);
    notifyListeners();
  }

  void removeRoutine(int index) {
    if (index >= 0 && index < _routines.length) {
      _routines.removeAt(index);
      notifyListeners();
    }
  }

  void addDietItem(Map<String, String> item) {
    _dietList.add(item);
    notifyListeners();
  }

  void removeDietItem(int index) {
    if (index >= 0 && index < _dietList.length) {
      _dietList.removeAt(index);
      notifyListeners();
    }
  }
}
