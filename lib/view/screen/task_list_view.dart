import 'package:flutter/material.dart';
import 'package:myapp/model/tarea_model.dart';
import 'package:myapp/view/widgets/tasks/add_task_button_widget.dart';
import 'package:myapp/view_model/task_view_model.dart';
import 'package:provider/provider.dart';

class TaskListView extends StatelessWidget {
  const TaskListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskViewModel>(
      builder: (context, taskViewModel, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: const Text(
              'Gestión de Tareas',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.filter_list,
                  color: Colors.white,
                ),
                onPressed: taskViewModel.toggleHighPriorityFilter,
              ),
              PopupMenuButton<TaskStatus?>(
                onSelected: taskViewModel.setGroupByStatus,
                iconColor: Colors.white,
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: null,
                    child: Text('Todas'),
                  ),
                  PopupMenuItem(
                    value: TaskStatus.pending,
                    child: Text('Pendientes'),
                  ),
                  PopupMenuItem(
                    value: TaskStatus.completed,
                    child: Text('Completadas'),
                  ),
                ],
              ),
            ],
          ),
          body: Column(
            children: [
              // Header
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(16),
                child: Text(
                  'Lista de Tareas',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 18),
                ),
              ),

              // ListView
              Expanded(
                child: ListView.builder(
                  itemCount: taskViewModel.tasks.length,
                  itemBuilder: (context, index) {
                    final task = taskViewModel.tasks[index];
                    return TaskListItem(
                      task: task,
                      onStatusChanged: (newStatus) {
                        final updatedTask = Task(
                          id: task.id,
                          name: task.name,
                          priority: task.priority,
                          status: newStatus,
                          creationDate: task.creationDate,
                        );
                        taskViewModel.updateTask(updatedTask);
                      },
                      onDelete: () => taskViewModel.deleteTask(task.id!),
                    );
                  },
                ),
              ),

              // Footer
              Container(
                padding: EdgeInsets.all(16),
                color: Colors.grey[200],
                child: Text(
                  'Total: ${taskViewModel.totalTasks} | Completadas: ${taskViewModel.completedTasks}',
                ),
              ),
            ],
          ),
          floatingActionButton: AddTaskButton(
            taskViewModel: taskViewModel,
          ),
        );
      },
    );
  }
}

class TaskListItem extends StatelessWidget {
  final Task task;
  final Function(TaskStatus) onStatusChanged;
  final VoidCallback onDelete;

  const TaskListItem({
    Key? key,
    required this.task,
    required this.onStatusChanged,
    required this.onDelete,
  }) : super(key: key);

  Color _getPriorityColor() {
    switch (task.priority) {
      case Priority.low:
        return Colors.green;
      case Priority.medium:
        return Colors.orange;
      case Priority.high:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.id.toString()),
      onDismissed: (_) => onDelete(),
      background: Container(color: Colors.red),
      child: ListTile(
        leading: Checkbox(
          value: task.status == TaskStatus.completed,
          onChanged: (bool? value) {
            onStatusChanged(value! ? TaskStatus.completed : TaskStatus.pending);
          },
        ),
        title: Text(
          task.name,
          style: TextStyle(
            decoration: task.status == TaskStatus.completed
                ? TextDecoration.lineThrough
                : null,
          ),
        ),
        subtitle: Text('Creado: ${task.creationDate.toString().split('.')[0]}'),
        trailing: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getPriorityColor(),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            task.priority.toString().split('.').last.toUpperCase(),
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
