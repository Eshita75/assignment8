import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:assignment8/ui/controller/sign_up_controller.dart';
import 'package:assignment8/ui/utility/app_colors.dart';
import 'package:assignment8/ui/utility/app_constants.dart';
import 'package:assignment8/ui/widgets/background_widget.dart';
import 'package:assignment8/ui/widgets/centered_progress_indicator.dart';
import 'package:assignment8/ui/widgets/show_snack_bar_message.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 120,),

                    Text('Join With Us', style: Theme.of(context).textTheme.titleLarge,),

                    const SizedBox(height: 24,),

                    TextFormField(
                      controller: _emailTEController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'Email'
                      ),
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Enter your email address';
                        }
                        if (AppConstants.emailRegExp.hasMatch(value!) ==
                            false) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 12,),

                    TextFormField(
                      controller: _firstNameTEController,
                      decoration: const InputDecoration(
                        hintText: 'First Name'
                      ),
                      validator: (String? value/*value null hote pare bujhate ? use*/){
                        if(value?.trim().isEmpty ?? true){
                          return 'Enter your first name';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 12,),

                    TextFormField(
                      controller: _lastNameTEController,
                      decoration: const InputDecoration(
                          hintText: 'Last Name'
                      ),
                      validator: (String? value/*value null hote pare bujhate ? use*/){
                        if(value?.trim().isEmpty ?? true){
                          return 'Enter your last name';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 12,),

                    TextFormField(
                      controller: _mobileTEController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          hintText: 'Mobile'
                      ),
                      validator: (String? value){
                        if(value?.trim().isEmpty ?? true){
                          return 'Enter your mobile number';
                        }
                        // if (AppConstants.mobileRegExp.hasMatch(value!) ==
                        //     false) {
                        //   return 'Enter a valid mobile number';
                        // }
                        return null;
                      },
                    ),

                    const SizedBox(height: 12,),

                    TextFormField(
                      obscureText: _showPassword == false,// _showPassword jodi false hoi then obsecureText kaj korbe true hole korbe na
                      controller: _passwordTEController,
                      decoration: InputDecoration(
                          hintText: 'Password',
                          suffixIcon: IconButton(onPressed: (){
                            _showPassword = !_showPassword;
                            if(mounted){
                              setState(() {

                              });
                            }
                          }, icon: Icon(_showPassword ? Icons.visibility_off : Icons.remove_red_eye))
                      ),
                      validator: (String? value/*value null hote pare bujhate ? use*/){
                        if(value?.trim().isEmpty ?? true){
                          return 'Enter your password';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16,),
                    GetBuilder<SignUpController>(
                      init: Get.find<SignUpController>(),
                      builder: (signUpController) {
                        return Visibility(
                          visible: signUpController.registrationInProgress == false,
                          replacement:  const CenteredProgressIndicator(),
                          child: ElevatedButton(
                            onPressed: () {
                              _registerUser();
                            },
                            child: const Icon(Icons.arrow_circle_right_outlined),
                          ),
                        );
                      }
                    ),

                    const SizedBox(height: 36,),

                    _buildBackToSignInSection()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackToSignInSection() {
    return Center(
      child: RichText(
        text: TextSpan(
            style: TextStyle(
                color: Colors.black.withOpacity(.8),
                fontWeight: FontWeight.w600,
                letterSpacing: .4),
            text: "Have account? ",
            children: [
            TextSpan(
                text: 'Sign In',
                style: const TextStyle(color: AppColors.themeColor),
                recognizer: TapGestureRecognizer()..onTap = _onTapSIgnInButton)
          ],
        ),
      ),
    );
  }

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      final SignUpController signUpController = Get.find<SignUpController>();
      final bool result = await signUpController.registerUser(
        _emailTEController.text.trim(),
        _firstNameTEController.text.trim(),
        _lastNameTEController.text.trim(),
        _mobileTEController.text.trim(),
        _passwordTEController.text,
      );
      if (result) {
        _clearTextFields();
        if (mounted) {
          showSnackBarMessage(context, 'Registration Successful');
        }
      } else {
        if (mounted) {
          showSnackBarMessage(context, signUpController.errorMessage);
        }
      }
    }
  }


  _clearTextFields(){
    _emailTEController.clear();
    _firstNameTEController.clear();
    _lastNameTEController.clear();
    _mobileTEController.clear();
    _passwordTEController.clear();
  }

  _onTapSIgnInButton(){
    Navigator.pop(context);
  }
  @override
  void dispose() {
    _emailTEController.dispose();
    _mobileTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
