import 'package:get/get.dart';
import 'package:assignment8/ui/controller/add_new_task_controller.dart';
import 'package:assignment8/ui/controller/cancelled_task_controller.dart';
import 'package:assignment8/ui/controller/completed_task_controller.dart';
import 'package:assignment8/ui/controller/email_verification_controller.dart';
import 'package:assignment8/ui/controller/in_progress_controller.dart';
import 'package:assignment8/ui/controller/new_task_by_count_controller.dart';
import 'package:assignment8/ui/controller/new_task_controller.dart';
import 'package:assignment8/ui/controller/pin_verification_controller.dart';
import 'package:assignment8/ui/controller/reset_password_controller.dart';
import 'package:assignment8/ui/controller/sign_in_controller.dart';
import 'package:assignment8/ui/controller/sign_up_controller.dart';
import 'package:assignment8/ui/controller/update_profile_controller.dart';

class ControllerBinder extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => SignInController());
    Get.lazyPut(() => NewTaskController());
    Get.lazyPut(() => NewTaskByCountController());
    Get.lazyPut(() => AddNewTaskController());
    Get.lazyPut(() => InProgressController());
    Get.lazyPut(() => CompletedTaskController());
    Get.lazyPut(() => CancelledTaskController());
    Get.lazyPut(() => UpdateProfileController());
    Get.lazyPut(() => SignUpController());
    Get.lazyPut(() => EmailVerificationController());
    Get.lazyPut(() => PinVerificationController());
    Get.lazyPut(() => ResetPasswordController());
  }
}