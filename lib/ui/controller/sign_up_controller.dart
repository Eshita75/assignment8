import 'package:get/get.dart';

import '../../data/models/login_model.dart';
import '../../data/models/network_response.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utility/urls.dart';
import 'auth_controller.dart';

class SignUpController extends GetxController{
  bool _registrationInProgress = false;
  bool get registrationInProgress => _registrationInProgress;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<bool> registerUser(String email, String firstName, String lasName, String mobile, String password) async{
    bool isSuccess = false;
    _registrationInProgress = true;
    update();

    Map<String, dynamic> requestData = {
      "email":email,
      "firstName":firstName,
      "lastName": lasName,
      "mobile":mobile,
      "password":password,
      "photo":""
    };

    NetworkResponse response = await NetworkCaller.postRequest(Urls.registration, body: requestData);//NetworkResponse class er object create korci first then NetworkCaller k call korci



    if (response.isSuccess) {
      isSuccess = true;
    }else{
      _errorMessage = response.errorMessage ?? 'Login failed! Try again';
    }

    _registrationInProgress = false;
    update();
    return isSuccess;
  }
}



