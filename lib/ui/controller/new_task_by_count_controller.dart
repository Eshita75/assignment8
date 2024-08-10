import 'package:get/get.dart';

import '../../data/models/network_response.dart';
import '../../data/models/task_count_by_status_model.dart';
import '../../data/models/task_count_by_status_wrapper_model.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utility/urls.dart';

class NewTaskByCountController extends GetxController {
  bool _getTaskCountByStatusInProgress = false;
  List<TaskCountByStatusModel> _taskCountByStatusList = [];
  String _errorMessage = '';

  bool get getTaskCountByStatusInProgress => _getTaskCountByStatusInProgress;

  List<TaskCountByStatusModel> get taskCountByStatusList => _taskCountByStatusList;

  String get errorMessage => _errorMessage;

  Future<bool> getTaskCountByStatus() async {
    bool isSuccess = false;
    _getTaskCountByStatusInProgress = true;
    update();

    NetworkResponse response =
    await NetworkCaller.getRequest(Urls.taskStatusCount);
    if (response.isSuccess) {
      TaskCountByStatusWrapperModel taskCountByStatusWrapperModel =
      TaskCountByStatusWrapperModel.fromJson(response.responseData);
      _taskCountByStatusList =
          taskCountByStatusWrapperModel.taskCountByStatusList ?? [];
    } else {
      _errorMessage = response.errorMessage ?? 'Get new task failed! Try again';
    }

    _getTaskCountByStatusInProgress = false;
    update();

    return isSuccess;
  }
}
