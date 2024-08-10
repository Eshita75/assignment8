import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:assignment8/ui/controller/email_verification_controller.dart';
import 'package:assignment8/ui/screens/authentication/pin_verification_screen.dart';
import 'package:assignment8/ui/widgets/centered_progress_indicator.dart';
import '../../utility/app_colors.dart';
import '../../utility/app_constants.dart';
import '../../widgets/background_widget.dart';
import '../../widgets/show_snack_bar_message.dart';


class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final TextEditingController _emailTEController = TextEditingController();

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
                  Text('Your Email Address', style: Theme.of(context).textTheme.titleLarge,),
                  Text('A 6 digit verification pin will send to your email address',
                    style: Theme.of(context).textTheme.titleSmall,),

                  const SizedBox(height: 24,),

                  TextFormField(
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

                  const SizedBox(height: 16,),

                  GetBuilder<EmailVerificationController>(
                    init: Get.find<EmailVerificationController>(),
                    builder: (emailVerificationController) {
                      return Visibility(
                        visible: emailVerificationController.mailVerificationInProgress == false,
                        replacement: const CenteredProgressIndicator(),
                        child: ElevatedButton(onPressed: _mailVerification,
                          child: const Icon(Icons.arrow_circle_right_outlined),),
                      );
                    }
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

  _onTapSignInButton(){
    Navigator.pop(context);
  }

  Future<void> _mailVerification() async{
    final EmailVerificationController emailVerificationController = Get.find<EmailVerificationController>();
    final bool result = await emailVerificationController.mailVerification(
      _emailTEController.text.trim(),
    );
    if (result) {
      Get.to(() => PinVerificationScreen(recoveryMail: _emailTEController.text));
    } else {
      if (mounted) {
        showSnackBarMessage(context, emailVerificationController.errorMessage);
      }
    }
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    super.dispose();
  }
}
