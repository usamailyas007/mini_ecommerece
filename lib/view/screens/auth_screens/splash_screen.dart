import 'package:ecommerce_app/view/screens/auth_screens/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utils/app_images.dart';
import '../../../utils/app_strings.dart';
import '../../../utils/app_styles.dart';
import '../../../utils/global.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      context.read<AuthProvider>().expandLogo();
      getUserFromLocalStorage(context);
    });
  }

  void getUserFromLocalStorage(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString("user_data");
    userSD = userDataString;
    if(userSD != null){
      Navigator.pushNamedAndRemoveUntil(context, kAllProductScreenRoute, (route) => false,);
    } else {
      Navigator.pushNamed(context, kSignInScreenRoute);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: AppStyles().paddingAll24,
        child: Center(
          child: Consumer<AuthProvider>(
            builder: (context, provider, child) {
              return AnimatedContainer(
                duration: const Duration(seconds: 1),
                curve: Curves.easeOut,
                height: provider.imageSizeHeight,
                width: provider.imageSizeHeight,
                child: Image.asset(
                  kLogoIcon,
                  fit: BoxFit.contain,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
