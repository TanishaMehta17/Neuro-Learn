
import 'package:flutter/material.dart';
import 'package:neuro_learn/model/task.dart';




class TaskProvider extends ChangeNotifier {
  Task _task = Task(
    id: '',
    description: '',
    isCompleted: false,
    userId: '',
  );

  Task get task => _task;

  void setTask(String task) {
    
    _task = Task.fromJson(task);
    notifyListeners();
  }

  void setUserFromModel(Task task) {
    _task = task;
    notifyListeners();
  }
}