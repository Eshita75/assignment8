import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/models/network_response.dart';
import '../../data/models/user_model.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/utility/urls.dart';
import 'auth_controller.dart';

class UpdateProfileController extends GetxController{
  bool _updateProfileInProgress = false;
  bool get updateProfileInProgress => _updateProfileInProgress;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;


  Future<bool> updateProfile(String email, String firstName, String lastName, String mobile, String password, XFile? selectedImage) async {
    _updateProfileInProgress = true;
    bool isSuccess = false;
    update();
    String encodePhoto = AuthController.userData?.photo ?? '';



    Map<String, dynamic> requestBody = {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile,
    };

    if (password.isNotEmpty) {
      requestBody['password'] = password;
    }

    if (selectedImage != null) {
      File file = File(selectedImage.path);
      encodePhoto = base64Encode(file.readAsBytesSync());
      requestBody['photo'] = encodePhoto;
    }
    final NetworkResponse response =
    await NetworkCaller.postRequest(Urls.updateProfile, body: requestBody);
    if (response.isSuccess && response.responseData['status'] == 'success') {
      UserModel userModel = UserModel(
        email: email,
        photo: encodePhoto,
        firstName: firstName,
        lastName: lastName,
        mobile: mobile,
      );
      await AuthController.saveUserData(userModel);
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage ?? 'Profile update failed! Try again';
    }
    _updateProfileInProgress = false;
    update();
    return isSuccess;
  }

  // Future<bool> updateProfile(String email, String password) async{
  //   bool isSuccess = false;
  //   _signInProgress = true;
  //   update();
  //
  //   Map<String, dynamic> requestData = {
  //     "email":email,
  //     "password":password
  //   };
  //
  //   NetworkResponse response = await NetworkCaller.postRequest(Urls.signIn, body: requestData);//NetworkResponse class er object create korci first then NetworkCaller k call korci
  //
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