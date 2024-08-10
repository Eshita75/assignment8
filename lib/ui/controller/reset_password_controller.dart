import 'package:get/get.dart';

import '../../data/models/network_response.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utility/urls.dart';

class ResetPasswordController extends GetxController {
  bool _getResetPasswordInProgress = false;
  bool get getResetPasswordInProgress => _getResetPasswordInProgress;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<bool> resetPassword(String recoveryMail,  String recoveryOTP, String password) async {
    bool isSuccess = false;
    _getResetPasswordInProgress = true;
    update();

    Map<String, dynamic> requestData = {
      "email": recoveryMail,
      "OTP": recoveryOTP,
      "password": password
    };

    NetworkResponse response = await NetworkCaller.postRequest(Urls.recoverResetPass, body: requestData);

    if(response.isSuccess && response.responseData['status'] == 'success') {
      isSuccess = true;
    }else{
      _errorMessage = response.errorMessage ?? 'otp is not correct. Try again';
    }

    _getResetPasswordInProgress = false;
    update();
    return isSuccess;
  }
}