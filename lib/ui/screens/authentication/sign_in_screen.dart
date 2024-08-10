import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:assignment8/ui/screens/authentication/sign_up_screen.dart';
import 'package:assignment8/ui/screens/main_bottom_nav_screen.dart';
import 'package:assignment8/ui/utility/app_colors.dart';
import 'package:assignment8/ui/widgets/background_widget.dart';
import 'package:assignment8/ui/screens/authentication/email_verification_screen.dart';
import 'package:assignment8/ui/widgets/centered_progress_indicator.dart';
import 'package:assignment8/ui/widgets/show_snack_bar_message.dart';
import '../../controller/sign_in_controller.dart';
import '../../utility/app_constants.dart';


class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailTEController = TextEditingController();
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 120,),
                    Text('Get Started With', style: Theme.of(context).textTheme.titleLarge,),

                    const SizedBox(height: 24,),

                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailTEController,
                      decoration: const InputDecoration(
                        hintText: 'Email'
                      ),
                      validator: (String? value){
                        if(value?.trim().isEmpty ?? true){
                          return 'Enter your email address';
                        }
                        if (AppConstants.emailRegExp.hasMatch(value!) ==
                            false) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 8,),

                    TextFormField(
                      obscureText: _showPassword == false,
                      controller: _passwordTEController,
                      decoration:  InputDecoration(
                        hintText: 'Password',
                        suffixIcon: IconButton(onPressed: (){
                          _showPassword = !_showPassword;
                          if(mounted){
                            setState(() {
                            });
                          }
                        }, icon: Icon(_showPassword ? Icons.visibility_off : Icons.remove_red_eye))
                      ),

                      validator: (String? value){
                        if(value?.trim().isEmpty ?? true){
                          return 'Enter your password';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16,),

                    GetBuilder<SignInController>(
                      init: Get.find<SignInController>(),
                      builder: (signInController) {
                        return Visibility(
                          visible: signInController.signInProgress == false,
                          replacement: const CenteredProgressIndicator(),
                          child: ElevatedButton(
                            onPressed: _onTapNextButton,
                            child:
                            const Icon(Icons.arrow_circle_right_outlined),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 36,),

                    _buildSignUpSection()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Center _buildSignUpSection() {
    return Center(
                    child: Column(
                      children: [
                        TextButton(onPressed: _onTapForgotPasswordButton, child: const Text('Forgot password?'),),
                        RichText(text: TextSpan(
                            style: TextStyle(
                                color: Colors.black.withOpacity(.8),
                                fontWeight: FontWeight.w600,
                                letterSpacing: .4
                            ),
                            text: "Don't have an account? ",
                            children: [
                              TextSpan(
                                text: 'Sign up',
                                style: const TextStyle(color: AppColors.themeColor),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    _onTapSignUpButton();
                                  },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
  }

  Future<void> _onTapNextButton() async {
    if (_formKey.currentState!.validate()) {
      final SignInController signInController = Get.find<SignInController>();
      final bool result = await signInController.signIn(
        _emailTEController.text.trim(),
        _passwordTEController.text,
      );
      if (result) {
        Get.offAll(() => const MainBottomNavScreen());
      } else {
        if (mounted) {
          showSnackBarMessage(context, signInController.errorMessage);
        }
      }
    }
  }

  _onTapSignUpButton(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const SignUpScreen();
        },
      ),
    );
  }


  _onTapForgotPasswordButton(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const EmailVerificationScreen();
        },
      ),
    );
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
