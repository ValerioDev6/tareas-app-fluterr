import 'package:flutter/material.dart';

import '../../../model/tarea_model.dart';
import '../../../view_model/task_view_model.dart';

class AddTaskDialog extends StatefulWidget {
  final TaskViewModel taskViewModel;

  const AddTaskDialog({
    Key? key,
    required this.taskViewModel,
  }) : super(key: key);

  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _nameController = TextEditingController();
  Priority _selectedPriority = Priority.medium;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Nueva Tarea'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Nombre de la tarea'),
          ),
          DropdownButton<Priority>(
            value: _selectedPriority,
            items: Priority.values.map((priority) {
              return DropdownMenuItem(
                value: priority,
                child: Text(priority.toString().split('.').last),
              );
            }).toList(),
            onChanged: (Priority? value) {
              setState(() {
                _selectedPriority = value!;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            if (_nameController.text.isNotEmpty) {
              widget.taskViewModel.addTask(
                Task(
                  name: _nameController.text,
                  priority: _selectedPriority,
                  creationDate: DateTime.now(),
                ),
              );
              Navigator.pop(context);
            }
          },
          child: Text('Guardar'),
        ),
      ],
    );
  }
}
