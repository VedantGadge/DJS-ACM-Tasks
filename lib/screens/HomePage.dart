import 'package:action_slider/action_slider.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/utils/Tasks.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final _controller = TextEditingController();

  List<List<dynamic>> taskLists = [
    ['Wake up bruh', 'Wake up and get ready to go to the gym', '07:00', false],
    ['Gym (Back Biceps)', '', '09:00', false],
  ];

  // Helper function to convert time string to DateTime
  DateTime parseTime(String time) {
    return DateTime.tryParse('1970-01-01 $time:00') ?? DateTime(1970, 1, 1);
  }

  // Function to sort taskLists based on time
  void sortTasks() {
    taskLists.sort((a, b) {
      // If either time is empty, push it to the end
      if (a[2].isEmpty) return 1;
      if (b[2].isEmpty) return -1;

      DateTime timeA = parseTime(a[2]);
      DateTime timeB = parseTime(b[2]);

      return timeA.compareTo(timeB);
    });
  }

  void changeTaskStatus(int index) {
    setState(() {
      taskLists[index][3] = !taskLists[index][3];
    });
  }

  void addTask(String newTask) {
    setState(() {
      taskLists.add([newTask, '', '', false]);
      sortTasks(); // Sort the list after adding a new task
    });
  }

  void deleteTask(int index) {
    setState(() {
      taskLists.removeAt(index);
    });
  }

  void showTaskDescription(int index) {
    final titleController = TextEditingController(text: taskLists[index][0]);
    final descController = TextEditingController(text: taskLists[index][1]);
    final timeController = TextEditingController(text: taskLists[index][2]);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Edit Task"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Task Title',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(
                    labelText: 'Task Description',
                  ),
                  maxLines: null,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: timeController,
                  decoration: const InputDecoration(
                    labelText: 'Task Time',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: Color.fromARGB(255, 85, 136, 255)),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  taskLists[index][0] = titleController.text;
                  taskLists[index][1] = descController.text;
                  taskLists[index][2] = timeController.text;
                  sortTasks(); // Sort the list after editing a task
                });
                Navigator.of(context).pop();
              },
              child: const Text(
                "Save",
                style: TextStyle(color: Color.fromARGB(255, 85, 136, 255)),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffb3cde0),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: ListView.builder(
          itemCount: taskLists.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                showTaskDescription(index);
              },
              child: TasksWidget(
                taskName: taskLists[index][0],
                taskDesc: taskLists[index][1],
                isCompleted: taskLists[index][3],
                taskTime: taskLists[index][2],
                deleteTask: (context) => deleteTask(index),
                onChanged: (value) => changeTaskStatus(index),
              ),
            );
          },
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 85, 136, 255),
        title: const Center(
          child: Text(
            'Manage your tasks',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: ActionSlider.standard(
          rolling: true,
          reverseSlideAnimationCurve: Curves.easeOut,
          reverseSlideAnimationDuration: const Duration(milliseconds: 500),
          sliderBehavior: SliderBehavior.stretch,
          icon: const Icon(Icons.add, size: 30),
          successIcon: const Icon(Icons.check, size: 30),
          toggleColor: const Color.fromARGB(255, 85, 136, 255),
          action: (controller) async {
            if (_controller.text.isNotEmpty) {
              addTask(_controller.text);
              _controller.clear();
              controller.success();
              await Future.delayed(const Duration(milliseconds: 500));
              controller.reset();
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 30),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Add a new task...',
                filled: true,
                fillColor: Colors.white,
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
