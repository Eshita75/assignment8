import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:assignment8/ui/screens/authentication/sign_in_screen.dart';
import 'package:assignment8/ui/screens/main_bottom_nav_screen.dart';
import 'package:assignment8/ui/utility/assets_path.dart';
import 'package:assignment8/ui/widgets/background_widget.dart';
import '../../controller/auth_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _moveToNextScreen();
  }

  Future _moveToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));
    bool isUserLoggedIn = await AuthController.checkAuthState();
    if(mounted){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return isUserLoggedIn ?  const MainBottomNavScreen() : const SignInScreen();
          },
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: Center(
          child: SvgPicture.asset(
            AssetsPaths.appLogoSVG,
            width: 140,
          ),
        ),
      ),
    );
  }
}
