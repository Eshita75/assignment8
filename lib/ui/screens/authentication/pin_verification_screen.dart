import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:assignment8/ui/controller/pin_verification_controller.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:assignment8/ui/screens/authentication/reset_password_screen.dart';
import 'package:assignment8/ui/screens/authentication/sign_in_screen.dart';
import 'package:assignment8/ui/utility/app_colors.dart';
import 'package:assignment8/ui/widgets/background_widget.dart';
import 'package:assignment8/ui/widgets/centered_progress_indicator.dart';
import '../../widgets/show_snack_bar_message.dart';


class PinVerificationScreen extends StatefulWidget {
  const PinVerificationScreen({super.key, required this.recoveryMail,});

  final String recoveryMail;
  @override
  State<PinVerificationScreen> createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> {
  final TextEditingController _pinTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

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
                    Text('Pin Verification', style: Theme.of(context).textTheme.titleLarge,),

                    Text('A 6 digit verification pin has been sent to your email address',
                      style: Theme.of(context).textTheme.titleSmall,),

                    const SizedBox(height: 24,),

                    _buildPinCodeTextField(),
                    const SizedBox(height: 16,),

                    GetBuilder<PinVerificationController>(
                      init: Get.find<PinVerificationController>(),
                      builder: (pinVerificationController) {
                        return Visibility(
                          visible: pinVerificationController.getPinVerificationInProgress == false,
                          replacement: const CenteredProgressIndicator(),
                          child: ElevatedButton(onPressed: _pinVerification,
                            child: const Text('Verify'),),
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
                );
  }

  Widget _buildPinCodeTextField() {
    return PinCodeTextField(
        animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeFillColor: Colors.white,
                        selectedFillColor: Colors.white,
                        inactiveFillColor: Colors.white,
                        selectedColor: AppColors.themeColor),
                    animationDuration: const Duration(milliseconds: 300),
                    backgroundColor: Colors.transparent,
                    keyboardType: TextInputType.number,
                    enableActiveFill: true,
                    controller: _pinTEController,
                    appContext: context,
                    length: 6);
  }

  Future<void> _pinVerification() async{
    String otp = _pinTEController.text.trim();

    final PinVerificationController pinVerificationController = Get.find<PinVerificationController>();
    final bool result = await pinVerificationController.pinVerification(widget.recoveryMail, _pinTEController.text);
    if (result) {
      Get.to(() => ResetPasswordScreen(
        recoveryMail: widget.recoveryMail,
        recoveryOTP: otp,
      ));
    } else {
      if (mounted) {
        showSnackBarMessage(context, pinVerificationController.errorMessage);
      }
    }
  }

  _onTapSignInButton(){
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const SignInScreen()),
        (route) => false);
  }

  clear(){
    _pinTEController.clear();
  }
}
