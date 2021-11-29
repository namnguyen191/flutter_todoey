import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoey/models/task.dart';

const storageKey = 'tasks';

class TaskData extends ChangeNotifier {
  final List<Task> _tasks = [];

  Future<void> loadTaskFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> taskNames = prefs.getStringList(storageKey) ?? [];

    for (var name in taskNames) {
      _tasks.add(Task(name: name));
    }

    notifyListeners();
  }

  Future<void> saveTaskToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> taskNamesFromTasks = [];
    for (var task in _tasks) {
      taskNamesFromTasks.add(task.name);
    }
    prefs.setStringList(storageKey, taskNamesFromTasks);
  }

  int get tasksCount {
    return _tasks.length;
  }

  UnmodifiableListView<Task> get tasks {
    return UnmodifiableListView(_tasks);
  }

  void addTask(String newTaskTitle) {
    _tasks.add(Task(name: newTaskTitle));
    saveTaskToStorage();
    notifyListeners();
  }

  void updateTask(Task task) {
    task.toggleDone();
    notifyListeners();
  }

  void deleteTask(Task task) {
    _tasks.remove(task);
    saveTaskToStorage();
    notifyListeners();
  }
}
