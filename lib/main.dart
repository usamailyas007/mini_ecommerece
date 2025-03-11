import 'package:easy_localization/easy_localization.dart' as localization;
import 'package:ecommerce_app/utils/app_colors.dart';
import 'package:ecommerce_app/utils/app_styles.dart';
import 'package:ecommerce_app/utils/global.dart';
import 'package:ecommerce_app/utils/route_generator.dart';
import 'package:ecommerce_app/view/screens/auth_screens/provider/auth_provider.dart';
import 'package:ecommerce_app/view/screens/products_screen/provider/product_provider.dart';
import 'package:ecommerce_app/view/screens/profile_screen/provider/profile_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'utils/app_strings.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = stripeKey;

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await localization.EasyLocalization.ensureInitialized();
  runApp(
      localization.EasyLocalization(
        supportedLocales: const [
          Locale("en", "US"),
          Locale("ar", "SA"),
        ],
        saveLocale: true,
        path: 'assets/translations',
        fallbackLocale: const Locale("en", "US"),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (context) => ProductProvider()),
          ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  ThemeData _buildTheme(brightness) {
    var baseTheme = ThemeData(brightness: brightness);

    return baseTheme.copyWith(
      primaryColor: kWhiteColor,
      scaffoldBackgroundColor: kWhiteColor,
      timePickerTheme: const TimePickerThemeData(
        backgroundColor: kWhiteColor,
      ),
      datePickerTheme: const DatePickerThemeData(
          backgroundColor: kWhiteColor
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: kWhiteColor,
        iconTheme: IconThemeData(color: kBlackColor1),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: AppStyles.poppinsTextStyle().copyWith(color: kGreyColor),
        prefixIconColor: kBorderColor,
        contentPadding: EdgeInsets.symmetric(
          vertical: 8.h,
          horizontal: 14.w,
        ),
        fillColor: kWhiteColor,
        filled: true,
        iconColor: kSecondaryColor,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: kBorderColor),
          borderRadius: AppStyles.customBorder8,
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: AppStyles.customBorder8,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppStyles.customBorder8,
          borderSide: const BorderSide(color: kPrimaryColor),
        ),
      ),
      textTheme: TextTheme(
        titleMedium: TextStyle(color: kBlackColor1, fontSize: 14.sp),
        bodyLarge: TextStyle(color: kBlackColor1, fontSize: 14.sp),
        bodyMedium: TextStyle(color: kBlackColor1, fontSize: 14.sp),
      ),
      colorScheme: ThemeData().colorScheme.copyWith(primary: kPrimaryColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    Locale locale = context.locale;
    TextDirection textDirection =
    locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr;

    return ScreenUtilInit(
      designSize: const Size(428, 926),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Directionality(
          textDirection: textDirection,
          child: MaterialApp(
            title: kAppName,
            debugShowCheckedModeBanner: false,
            theme: _buildTheme(Brightness.light),
            initialRoute: kSplashScreenRoute,
            onGenerateRoute: RouteGenerator.generateRoute,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
          ),
        );
      },
    );
  }
}
