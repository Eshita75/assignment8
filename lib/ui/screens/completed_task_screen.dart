import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:assignment8/ui/controller/completed_task_controller.dart';
import '../widgets/centered_progress_indicator.dart';
import '../widgets/task_item.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {

  @override
  void initState() {
    super.initState();
    Get.find<CompletedTaskController>().getCompletedTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async => Get.find<CompletedTaskController>().getCompletedTasks(),
        child: GetBuilder<CompletedTaskController>(
          init: Get.find<CompletedTaskController>(),
          builder: (completedTaskController) {
            return Visibility(
              visible: completedTaskController.getCompletedTasksInProgress == false,
              replacement: const CenteredProgressIndicator(),
              child: ListView.builder(
                itemCount: completedTaskController.completedTasks.length,
                itemBuilder: (context, index) {
                  return TaskItem(
                    taskModel: completedTaskController.completedTasks[index],
                    onUpdateTask: completedTaskController.getCompletedTasks,
                    statusColour: Colors.green,
                  );
                },
              ),
            );
          }
        ),
      ),
    );
  }
}