import 'package:app_projet/models/activity.dart';
import 'package:flutter/material.dart';

class Cart {
  List<Activity> activities = [];

  void add(Activity activity) {
    activities.add(activity);
  }

  void remove(Activity activity) {
    activities.remove(activity);
  }
}

class CartModel with ChangeNotifier {
  final List<Activity> _activities = [];

  List<Activity> get activities => _activities;

  void add(Activity activity) {
    _activities.add(activity);
    notifyListeners();
  }

  void remove(Activity activity) {
    int indexToRemove = _activities.indexWhere((a) =>
        a.title == activity.title &&
        a.place == activity.place &&
        a.price == activity.price &&
        a.category == activity.category &&
        a.minParticipants == activity.minParticipants &&
        a.preview == activity.preview);

    if (indexToRemove != -1) {
      _activities.removeAt(indexToRemove);
      notifyListeners();
    }
  }

  void removeAt(int index) {
    activities.removeAt(index);
    notifyListeners();
  }
}
