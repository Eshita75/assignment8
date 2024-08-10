import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:assignment8/ui/controller/update_profile_controller.dart';
import 'package:assignment8/ui/widgets/background_widget.dart';
import 'package:assignment8/ui/widgets/profile_appbar.dart';
import '../controller/auth_controller.dart';
import '../widgets/centered_progress_indicator.dart';
import '../widgets/show_snack_bar_message.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  XFile? _selectedImage;


  void initState() {
    super.initState();
    final userData = AuthController.userData!;
    _emailTEController.text = userData.email ?? '';
    _firstNameTEController.text = userData.firstName ?? '';
    _lastNameTEController.text = userData.lastName ?? '';
    _mobileTEController.text = userData.mobile ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProfileAppBar(context, true),
      body: BackgroundWidget(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 48,),
                        
                  Text('Update Profile', style: Theme.of(context).textTheme.titleLarge,),
                        
                  const SizedBox(height: 16,),
                        
                  _buildPhotoPickerWidget(),
                        
                  const SizedBox(height: 8,),
                        
                  TextFormField(
                    controller: _emailTEController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'Email'
                    ),
                    enabled: false,
                  ),
                        
                  SizedBox(height: 8,),
                        
                  TextFormField(
                    controller: _firstNameTEController,
                    decoration: const InputDecoration(
                      hintText: 'First Name'
                    ),
                  ),
                        
                  const SizedBox(height: 8,),
                        
                  TextFormField(
                    controller: _lastNameTEController,
                    decoration: const InputDecoration(
                      hintText: 'Last Name'
                    ),
                  ),
                        
                  const SizedBox(height: 8,),
                        
                  TextFormField(
                    controller: _mobileTEController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      hintText: 'Mobile'
                    ),
                  ),
                        
                  const SizedBox(height: 8,),
                        
                  TextFormField(
                    controller: _passwordTEController,
                    decoration: const InputDecoration(
                      hintText: 'Password'
                    ),
                  ),
                        
                  SizedBox(height: 16,),

                  GetBuilder<UpdateProfileController>(
                    init: Get.find<UpdateProfileController>(),
                    builder: (updateProfileController) {
                      return Visibility(
                        visible: updateProfileController.updateProfileInProgress == false,
                        replacement: const CenteredProgressIndicator(),
                        child: ElevatedButton(
                          onPressed: _updateProfile,
                          child: const Icon(Icons.arrow_circle_right_outlined),
                        ),
                      );
                    }
                  ),
              
                  SizedBox(height: 16,)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      final UpdateProfileController updateProfileController = Get.find<UpdateProfileController>();
      final bool result = await updateProfileController.updateProfile(
        _emailTEController.text.trim(),
        _firstNameTEController.text.trim(),
        _lastNameTEController.text.trim(),
        _mobileTEController.text.trim(),
        _passwordTEController.text.trim(),
       _selectedImage
      );
      if (result) {
        if (mounted) {
          showSnackBarMessage(context, 'Profile updated!');
        }
      } else {
        if (mounted) {
          showSnackBarMessage(context, 'Profile update failed! Try again', true);
        }
      }
    }
  }

  // Future<void> _updateProfile() async {
  //   _updateProfileInProgress = true;
  //   String encodePhoto = AuthController.userData?.photo ?? '';
  //   if (mounted) {
  //     setState(() {});
  //   }
  //
  //   Map<String, dynamic> requestBody = {
  //     "email": _emailTEController.text,
  //     "firstName": _firstNameTEController.text.trim(),
  //     "lastName": _lastNameTEController.text.trim(),
  //     "mobile": _mobileTEController.text.trim(),
  //   };
  //
  //   if (_passwordTEController.text.isNotEmpty) {
  //     requestBody['password'] = _passwordTEController.text;
  //   }
  //
  //   if (_selectedImage != null) {
  //     File file = File(_selectedImage!.path);
  //     encodePhoto = base64Encode(file.readAsBytesSync());
  //     requestBody['photo'] = encodePhoto;
  //   }
  //   final NetworkResponse response =
  //   await NetworkCaller.postRequest(Urls.updateProfile, body: requestBody);
  //   if (response.isSuccess && response.responseData['status'] == 'success') {
  //     UserModel userModel = UserModel(
  //       email: _emailTEController.text,
  //       photo: encodePhoto,
  //       firstName: _firstNameTEController.text.trim(),
  //       lastName: _lastNameTEController.text.trim(),
  //       mobile: _mobileTEController.text.trim(),
  //     );
  //     await AuthController.saveUserData(userModel);
  //     if (mounted) {
  //       showSnackBarMessage(context, 'Profile updated!');
  //     }
  //   } else {
  //     if (mounted) {
  //       showSnackBarMessage(context,
  //           response.errorMessage ?? 'Profile update failed! Try again');
  //     }
  //   }
  //   _updateProfileInProgress = false;
  //   if (mounted) {
  //     setState(() {});
  //   }
  // }

  Widget _buildPhotoPickerWidget() {
    return GestureDetector(
      onTap: _pickProfileImage,
      child: Container(
        width: double.maxFinite,
        height: 48,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), color: Colors.white),
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Container(
              width: 100,
              height: 48,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                  color: Colors.grey),
              alignment: Alignment.center,
              child: const Text(
                'Photo',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 16),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                _selectedImage?.name ?? 'No image selected',
                maxLines: 1,
                style: const TextStyle(overflow: TextOverflow.ellipsis),
              ),
            )
          ],
        ),
      ),
    );
  }


  Future<void> _pickProfileImage() async {
    final imagePicker = ImagePicker();
    final XFile? result = await imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (result != null) {
      _selectedImage = result;
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _mobileTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
