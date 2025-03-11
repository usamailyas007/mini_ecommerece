import 'package:ecommerce_app/view/screens/auth_screens/signup_screen.dart';
import 'package:ecommerce_app/view/screens/products_screen/all_products_screen.dart';
import 'package:ecommerce_app/view/screens/products_screen/cart_page.dart';
import 'package:ecommerce_app/view/screens/products_screen/product_detail_screen.dart';
import 'package:ecommerce_app/view/screens/profile_screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/view/screens/auth_screens/login_screen.dart';
import 'package:ecommerce_app/utils/app_strings.dart';

import '../view/models/product_model/product_model.dart';
import '../view/screens/auth_screens/splash_screen.dart';

class RouteGenerator {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case kSplashScreenRoute:
        return _noTransitionRoute(const SplashScreen());
      case kSignInScreenRoute:
        return _noTransitionRoute(const LoginScreen());
      case kSignupScreenRoute:
        return _noTransitionRoute(const SignupScreen());
      case kAllProductScreenRoute:
        return _noTransitionRoute(const AllProductsScreen());
      case kProductDetailScreenRoute:
        final product = settings.arguments as ProductModel?;
        return _noTransitionRoute(ProductDetailScreen(product: product));
      case kMyCartScreenRoute:
        return _noTransitionRoute(const MyCartScreen());
      case kProfileScreenRoute:
        return _noTransitionRoute(ProfileScreen());
      default:
        return _noTransitionRoute(
          const Scaffold(body: Center(child: Text("Page Not Found"))),
        );
    }
  }

  static PageRouteBuilder _noTransitionRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    );
  }
}
