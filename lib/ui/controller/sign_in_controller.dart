import 'package:get/get.dart';

import '../../data/models/login_model.dart';
import '../../data/models/network_response.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utility/urls.dart';
import 'auth_controller.dart';

class SignInController extends GetxController{
  bool _signInProgress = false;
  bool get signInProgress => _signInProgress;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<bool> signIn(String email, String password) async{
    bool isSuccess = false;
    _signInProgress = true;
    update();

    Map<String, dynamic> requestData = {
      "email":email,
      "password":password
    };

    NetworkResponse response = await NetworkCaller.postRequest(Urls.signIn, body: requestData);//NetworkResponse class er object create korci first then NetworkCaller k call korci



    if (response.isSuccess) {
      LoginModel loginModel = LoginModel.fromJson(response.responseData);
      await AuthController.saveUserAccessToken(loginModel.token!);
      await AuthController.saveUserData(loginModel.userModel!);
      isSuccess = true;
    }else{
      _errorMessage = response.errorMessage ?? 'Login failed! Try again';
    }

    _signInProgress = false;
    update();
    return isSuccess;
  }
}