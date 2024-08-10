import 'package:get/get.dart';

import '../../data/models/network_response.dart';
import '../../data/models/task_list_wrapper_model.dart';
import '../../data/models/task_model.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utility/urls.dart';

class EmailVerificationController extends GetxController {
  bool _mailVerificationInProgress = false;
  bool get mailVerificationInProgress => _mailVerificationInProgress;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<bool> mailVerification(String email) async {
    bool isSuccess = false;
    _mailVerificationInProgress = true;
    update();

    NetworkResponse response = await NetworkCaller.getRequest(Urls.mailVerification(email));

    if(response.isSuccess && response.responseData['status'] == 'success') {
      isSuccess = true;
    }else{
      _errorMessage = response.errorMessage ?? 'Email/password is not correct. Try again';
    }

    _mailVerificationInProgress = false;
    update();
    return isSuccess;
  }
}