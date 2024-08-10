import 'package:get/get.dart';

import '../../data/models/network_response.dart';
import '../../data/models/task_list_wrapper_model.dart';
import '../../data/models/task_model.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utility/urls.dart';

class InProgressController extends GetxController {
  bool _getinProgressTasks = false;
  List<TaskModel> _inProgressTasks = [];
  String _errorMessage = '';

  bool get getinProgressTasks => _getinProgressTasks;

  List<TaskModel> get inProgressTasks => _inProgressTasks;

  String get errorMessage => _errorMessage;

  Future<bool> getProgressTasks() async {
    bool isSuccess = false;
    _getinProgressTasks = true;
    update();

    NetworkResponse response = await NetworkCaller.getRequest(Urls.progressTasks);
    if (response.isSuccess) {
      TaskListWrapperModel taskListWrapperModel =
      TaskListWrapperModel.fromJson(response.responseData);
      _inProgressTasks = taskListWrapperModel.taskList ?? [];
    } else {
      _errorMessage = response.errorMessage ?? 'Get Progress task failed! Try again';
    }
    _getinProgressTasks = false;
    update();
    return isSuccess;
  }
}
