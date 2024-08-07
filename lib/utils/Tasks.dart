import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TasksWidget extends StatelessWidget {
  const TasksWidget({
    super.key,
    required this.taskName,
    required this.taskDesc,
    required this.isCompleted,
    required this.deleteTask,
    required this.onChanged,
    required this.taskTime,
  });

  final String taskName;
  final String taskDesc;
  final bool isCompleted;
  final Function(bool?) onChanged;
  final Function(BuildContext) deleteTask;
  final String taskTime;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Slidable(
          key: ValueKey(taskName),
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            dragDismissible: true,
            dismissible: DismissiblePane(onDismissed: () {
              deleteTask(context);
            }),
            children: [
              SlidableAction(
                padding: const EdgeInsets.only(top: 10),
                backgroundColor: Colors.redAccent,
                onPressed: deleteTask,
                icon: Icons.delete_rounded,
                label: 'Delete',
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 85, 136, 255),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomLeft: Radius.circular(15))),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Checkbox(
                        value: isCompleted,
                        onChanged: onChanged,
                        checkColor: Colors.black54,
                        activeColor: Colors.white24,
                        side: const BorderSide(color: Colors.white60),
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: Text(
                        taskName,
                        style: TextStyle(
                          decoration: isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          color: isCompleted ? Colors.white38 : Colors.white,
                          fontSize: 20,
                          decorationColor: Colors.white,
                          decorationThickness: 2,
                        ),
                        overflow:
                            TextOverflow.ellipsis, // Handles overflow text
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        taskTime,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 15),
                        textAlign: TextAlign.right, // Align text to the right
                      ),
                    ),
                  ],
                )),
          )),
    );
  }
}
