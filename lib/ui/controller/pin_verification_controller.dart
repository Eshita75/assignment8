import 'package:get/get.dart';

import '../../data/models/network_response.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utility/urls.dart';

class PinVerificationController extends GetxController {
  bool _getPinVerificationInProgress = false;
  bool get getPinVerificationInProgress => _getPinVerificationInProgress;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<bool> pinVerification(String recoveryMail, String pin) async {
    bool isSuccess = false;
    _getPinVerificationInProgress = true;
    update();

    NetworkResponse response = await NetworkCaller.getRequest(Urls.otpVerification(recoveryMail, pin));

    if(response.isSuccess && response.responseData['status'] == 'success') {
      isSuccess = true;
    }else{
      _errorMessage = response.errorMessage ?? 'otp is not correct. Try again';
    }

    _getPinVerificationInProgress = false;
    update();
    return isSuccess;
  }
}