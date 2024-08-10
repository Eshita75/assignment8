import 'package:get/get.dart';

import '../../data/models/login_model.dart';
import '../../data/models/network_response.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utility/urls.dart';
import '../widgets/show_snack_bar_message.dart';
import 'auth_controller.dart';

class AddNewTaskController extends GetxController{
  bool _addNewTaskInProgress = false;
  bool get addNewTaskInProgress => _addNewTaskInProgress;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<bool> addNewTask(String title, String description) async {
    bool isSuccess = false;
    _addNewTaskInProgress = true;
    update();


    Map<String, dynamic> requestData = {
      "title": title,
      "description": description,
      "status": "New",
    };
    NetworkResponse response = await NetworkCaller.postRequest(
      Urls.createTask,
      body: requestData,
    );


    if (response.isSuccess) {
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage ?? 'New task added failed! Try again';
    }
    _addNewTaskInProgress = false;
    update();
    return isSuccess;
  }
  // Future<bool> signIn(String email, String password) async{
  //   bool isSuccess = false;
  //   _addNewTaskInProgress = true;
  //   update();
  //   Map<String, dynamic> requestData = {
  //     "email":email,
  //     "password":password
  //   };
  //   NetworkResponse response = await NetworkCaller.postRequest(Urls.signIn, body: requestData);//NetworkResponse class er object create korci first then NetworkCaller k call korci
  //
  //
  //   if (response.isSuccess) {
  //     LoginModel loginModel = LoginModel.fromJson(response.responseData);
  //     await AuthController.saveUserAccessToken(loginModel.token!);
  //     await AuthController.saveUserData(loginModel.userModel!);
  //     isSuccess = true;
  //   }else{
  //     _errorMessage = response.errorMessage ?? 'Login failed! Try again';
  //   }
  //
  //   _signInProgress = false;
  //   update();
  //   return isSuccess;
  // }
}