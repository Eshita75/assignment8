import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:assignment8/ui/controller/new_task_by_count_controller.dart';
import 'package:assignment8/ui/screens/add_new_task_screen.dart';
import 'package:assignment8/ui/utility/app_colors.dart';
import 'package:assignment8/ui/widgets/centered_progress_indicator.dart';
import '../controller/new_task_controller.dart';
import '../widgets/task_item.dart';
import '../widgets/task_summary_card.dart';


class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {


  @override
  void initState() {
    super.initState();
    _initialCall();
  }

  void _initialCall() {
    //_getTaskCountByStatus();
    Get.find<NewTaskController>().getNewTasks();
    Get.find<NewTaskByCountController>().getTaskCountByStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummarySection(),
            const SizedBox(
              height: 8,
            ),
            Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    _initialCall();
                  },
                  child:  GetBuilder<NewTaskController>(
                    init: Get.find<NewTaskController>(),
                      builder: (newTaskController) {
                    return Visibility(
                      visible: newTaskController.getNewTasksInProgress == false,
                      replacement: const CenteredProgressIndicator(),
                      child: ListView.builder(
                        itemCount: newTaskController.newTaskList.length,
                        itemBuilder: (context, index) {
                          return TaskItem(
                            taskModel: newTaskController.newTaskList[index],
                            onUpdateTask: _initialCall,
                            statusColour: Colors.blue,
                          );
                        },
                      ),
                    );
                  }),
                ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onTapAddButton,
        backgroundColor: AppColors.themeColor,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  _onTapAddButton() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const AddNewTaskScreen();
        },
      ),
    );
  }

  Widget _buildSummarySection() {
    return GetBuilder<NewTaskByCountController>(
        builder: (newTaskByCountController) {
          return Visibility(
            visible: newTaskByCountController.getTaskCountByStatusInProgress == false,
            replacement: const SizedBox(
              height: 100,
              child: CenteredProgressIndicator(),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: newTaskByCountController.taskCountByStatusList.map((e) {
                  return TaskSummaryCard(
                    title: (e.sId ?? 'Unknown').toUpperCase(),
                    count: e.sum.toString(),
                  );
                }).toList(),
              ),
            ),
          );
        }
    );
  }
}