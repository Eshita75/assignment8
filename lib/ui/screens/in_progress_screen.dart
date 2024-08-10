import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../controller/in_progress_controller.dart';
import '../widgets/centered_progress_indicator.dart';
import '../widgets/show_snack_bar_message.dart';
import '../widgets/task_item.dart';

class InProgressScreen extends StatefulWidget {
  const InProgressScreen({super.key});

  @override
  State<InProgressScreen> createState() => _InProgressScreenState();
}

class _InProgressScreenState extends State<InProgressScreen> {
  //List<TaskModel> inProgressTasks = [];

  @override
  void initState() {
    super.initState();
    Get.find<InProgressController>().getProgressTasks();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async => Get.find<InProgressController>().getProgressTasks(),
        child: GetBuilder<InProgressController>(
          init: Get.find<InProgressController>(),
          builder: (inProgressController) {
            return Visibility(
              visible: inProgressController.getinProgressTasks == false,
              replacement: const CenteredProgressIndicator(),
              child: ListView.builder(
                itemCount: inProgressController.inProgressTasks.length,
                itemBuilder: (context, index) {
                  return TaskItem(
                    taskModel: inProgressController.inProgressTasks[index],
                    onUpdateTask: () {
                      inProgressController.getProgressTasks();
                    }, statusColour: Colors.pink,
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
