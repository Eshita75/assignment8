import 'package:get/get.dart';

import '../../data/models/network_response.dart';
import '../../data/models/task_list_wrapper_model.dart';
import '../../data/models/task_model.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utility/urls.dart';

class CancelledTaskController extends GetxController {
  bool _getCancelledTasksInProgress = false;
  bool get getCancelledTasksInProgress => _getCancelledTasksInProgress;


  List<TaskModel> _cancelledTasks = [];
  List<TaskModel> get cancelledTasks => _cancelledTasks;


  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<bool> getCancelledTasks() async {
    bool isSuccess = false;
    _getCancelledTasksInProgress = true;
    update();

    NetworkResponse response = await NetworkCaller.getRequest(Urls.cancelledTasks);
    if (response.isSuccess) {
      TaskListWrapperModel taskListWrapperModel =
      TaskListWrapperModel.fromJson(response.responseData);
      _cancelledTasks = taskListWrapperModel.taskList ?? [];
    } else {
      _errorMessage = response.errorMessage ?? 'Get Cancelled task failed! Try again';
    }
    _getCancelledTasksInProgress = false;
    update();
    return isSuccess;
  }
}
