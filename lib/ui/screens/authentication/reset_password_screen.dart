import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:assignment8/ui/controller/reset_password_controller.dart';
import 'package:assignment8/ui/screens/authentication/sign_in_screen.dart';
import 'package:assignment8/ui/utility/app_colors.dart';
import 'package:assignment8/ui/widgets/background_widget.dart';
import 'package:assignment8/ui/widgets/centered_progress_indicator.dart';
import '../../widgets/show_snack_bar_message.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key, required this.recoveryMail, required this.recoveryOTP, });
  final String recoveryMail;
  final String recoveryOTP;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _resetPasswordTEController = TextEditingController();
  final TextEditingController _confirmPasswordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 120,),
                  Text('Set Password', style: Theme.of(context).textTheme.titleLarge,),
                  Text('Minimum length password 8 character with letter and number combination',
                    style: Theme.of(context).textTheme.titleSmall,),

                  const SizedBox(height: 24,),

                  Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _resetPasswordTEController,
                          decoration: const InputDecoration(
                              hintText: 'Password'
                          ),
                          validator: (String? value){
                            if(value?.trim().isEmpty ?? true){
                              return 'Enter your password';
                            }
                            if(value!.isNotEmpty && value.length < 8){
                              return 'Enter correct your password';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16,),

                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _confirmPasswordTEController,
                          decoration: const InputDecoration(
                              hintText: 'Confirm Password'
                          ),
                          validator: (String? value){
                            if(value?.trim().isEmpty ?? true){
                              return 'Confirm your password';
                            }
                            if(value!.isNotEmpty && value.length < 8){
                              return 'Confirm correct password';
                            }
                            if(value != _resetPasswordTEController.text){
                              return 'Match your password';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16,),

                        GetBuilder<ResetPasswordController>(
                          init: Get.find<ResetPasswordController>(),
                          builder: (resetPasswordController) {
                            return Visibility(
                              visible: resetPasswordController.getResetPasswordInProgress == false,
                              replacement: const CenteredProgressIndicator(),
                              child: ElevatedButton(onPressed: (){
                                resetPassword();
                              },
                                child: const Text('Confirm'),),
                            );
                          }
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 36,),

                  Center(
                    child: RichText(text: TextSpan(
                        style: TextStyle(
                            color: Colors.black.withOpacity(.8),
                            fontWeight: FontWeight.w600,
                            letterSpacing: .4
                        ),
                        text: "Have account? ",
                        children: [
                          TextSpan(
                            text: 'Sign in',
                            style: const TextStyle(color: AppColors.themeColor),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                _onTapSignInButton();
                              },
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _onTapSignInButton() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const SignInScreen(),
        ),
        (route) => false);
  }

  Future<void> resetPassword() async{
    final ResetPasswordController resetPasswordController = Get.find<ResetPasswordController>();
    final bool result = await resetPasswordController.resetPassword(widget.recoveryMail, widget.recoveryOTP, _resetPasswordTEController.text);
    if (result) {
      Get.offAll(() => const SignInScreen());
    } else {
      if (mounted) {
        showSnackBarMessage(context, resetPasswordController.errorMessage);
      }
    }
  }

  // _onTapConfirmButton() {
  //   Navigator.pushAndRemoveUntil(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => SignInScreen(),
  //       ),
  //       (route) => false);
  // }

  @override
  void dispose() {
    _resetPasswordTEController.dispose();
    _confirmPasswordTEController.dispose();
    super.dispose();
  }
}
