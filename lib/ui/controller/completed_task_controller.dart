import 'package:get/get.dart';

import '../../data/models/network_response.dart';
import '../../data/models/task_list_wrapper_model.dart';
import '../../data/models/task_model.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utility/urls.dart';

class CompletedTaskController extends GetxController {
  bool _getCompletedTasksInProgress = false;
  bool get getCompletedTasksInProgress => _getCompletedTasksInProgress;


  List<TaskModel> _completedTasks = [];
  List<TaskModel> get completedTasks => _completedTasks;


  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<bool> getCompletedTasks() async {
    bool isSuccess = false;
    _getCompletedTasksInProgress = true;
    update();

    NetworkResponse response = await NetworkCaller.getRequest(Urls.completedTasks);
    if (response.isSuccess) {
      TaskListWrapperModel taskListWrapperModel =
      TaskListWrapperModel.fromJson(response.responseData);
      _completedTasks = taskListWrapperModel.taskList ?? [];
    } else {
      _errorMessage = response.errorMessage ?? 'Get Completed task failed! Try again';
    }
    _getCompletedTasksInProgress = false;
    update();
    return isSuccess;
  }
}
