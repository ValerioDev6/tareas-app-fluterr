import 'package:flutter/material.dart';

import '../model/services/database_helper.dart';
import '../model/tarea_model.dart';

class TaskViewModel extends ChangeNotifier{
  List<Task> _tasks = [];
  bool _showOnlyHighPriority = false;
  TaskStatus? _groupByStatus;

  List<Task> get tasks {
    var filteredTasks = _tasks;
    
    if (_showOnlyHighPriority) {
      filteredTasks = filteredTasks.where((task) => task.priority == Priority.high).toList();
    }

    if (_groupByStatus != null) {
      filteredTasks = filteredTasks.where((task) => task.status == _groupByStatus).toList();
    }

    return filteredTasks;
  }

  Future<void> loadTasks() async {
    _tasks = await DatabaseHelper.instance.getAllTasks();
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    await DatabaseHelper.instance.insertTask(task);
    await loadTasks();
  }

  Future<void> updateTask(Task task) async {
    await DatabaseHelper.instance.updateTask(task);
    await loadTasks();
  }

  Future<void> deleteTask(int id) async {
    await DatabaseHelper.instance.deleteTask(id);
    await loadTasks();
  }

  void toggleHighPriorityFilter() {
    _showOnlyHighPriority = !_showOnlyHighPriority;
    notifyListeners();
  }

  void setGroupByStatus(TaskStatus? status) {
    _groupByStatus = status;
    notifyListeners();
  }

  int get totalTasks => _tasks.length;
  
  int get completedTasks => _tasks.where((task) => task.status == TaskStatus.completed).length;
}
  
 