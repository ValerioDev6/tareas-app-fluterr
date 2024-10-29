import 'package:flutter/material.dart';

import '../../../view_model/task_view_model.dart';
import 'add_task_widget.dart';

class AddTaskButton extends StatelessWidget {
  final TaskViewModel taskViewModel;

  const AddTaskButton({
    Key? key,
    required this.taskViewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showAddTaskDialog(context),
      child: Icon(Icons.add),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddTaskDialog(taskViewModel: taskViewModel),
    );
  }
}
