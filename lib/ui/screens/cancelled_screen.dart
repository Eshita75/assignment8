import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:assignment8/ui/controller/cancelled_task_controller.dart';
import '../../data/models/task_model.dart';
import '../widgets/centered_progress_indicator.dart';
import '../widgets/task_item.dart';

class CancelledScreen extends StatefulWidget {
  const CancelledScreen({super.key});

  @override
  State<CancelledScreen> createState() => _CancelledScreenState();
}

class _CancelledScreenState extends State<CancelledScreen> {

  List<TaskModel> cancelledTasks = [];

  @override
  void initState() {
    super.initState();
    Get.find<CancelledTaskController>().getCancelledTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async => Get.find<CancelledTaskController>().getCancelledTasks(),
        child: GetBuilder<CancelledTaskController>(
          init: Get.find<CancelledTaskController>(),
          builder: (cancelledTaskController) {
            return Visibility(
              visible: cancelledTaskController.getCancelledTasksInProgress == false,
              replacement: const CenteredProgressIndicator(),
              child: ListView.builder(
                itemCount: cancelledTaskController.cancelledTasks.length,
                itemBuilder: (context, index) {
                  return TaskItem(
                    taskModel: cancelledTaskController.cancelledTasks[index],
                    onUpdateTask: () {
                      cancelledTaskController.getCancelledTasks();
                    }, statusColour: Colors.red,
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
