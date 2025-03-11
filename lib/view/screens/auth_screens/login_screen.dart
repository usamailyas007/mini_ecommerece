import 'dart:developer';

import 'package:easy_localization/easy_localization.dart' as localization;
import 'package:ecommerce_app/utils/global.dart';
import 'package:ecommerce_app/view/screens/auth_screens/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_images.dart';
import '../../../utils/app_strings.dart';
import '../../../utils/app_styles.dart';
import '../../../utils/common_code.dart';
import '../../custom_widgets/custom_appbar.dart';
import '../../custom_widgets/custom_button.dart';
import '../../custom_widgets/custom_textField.dart';
import '../../custom_widgets/language_bottom_sheet.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  void showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: kWhiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40.r),
          topRight: Radius.circular(40.r),
        ),
      ),
      builder: (_) => LanguageBottomSheet(),
    );
  }

  void getUserFromLocalStorage(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString("user_data");
    userSD = userDataString;
    if(userSD != null){
      Navigator.pushNamedAndRemoveUntil(context, kAllProductScreenRoute, (route) => false,);
    } else {
      // Navigator.pushNamed(context, kSignInScreenRoute);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      getUserFromLocalStorage(context);

    });

  }



  @override
  Widget build(BuildContext context) {
    Locale locale = context.locale;

    return GestureDetector(
      onTap: () {
        CommonCode.unFocus(context);
      },
      child: Scaffold(
        appBar: CustomAppBar(automaticallyLeading: false, customTitle: const Text('')),
        body: SingleChildScrollView(
          child: Padding(
            padding: AppStyles().paddingAll24,
            child: Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40.h),
                    Center(
                      child: Text(
                        "kWelcomeBack".tr(),
                        style: AppStyles.poppinsTextStyle().copyWith(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Center(
                      child: Text(
                        "kSingInContinue".tr(),
                        style: AppStyles.poppinsTextStyle().copyWith(color: kGreyColor),
                      ),
                    ),
                    SizedBox(height: 60.h),
                    Text("kEmail".tr(), style: AppStyles.poppinsTextStyle()),
                    SizedBox(height: 4.h),
                    MyCustomTextField(
                      controller: authProvider.loginEmailController,
                      hintText: "kEmailHint".tr(),
                      showError: authProvider.loginEmailError.isNotEmpty ? true : false,
                      fillColor: kWhiteColor,
                      textInputType: TextInputType.emailAddress,
                      errorText: authProvider.loginEmailError.isNotEmpty ? authProvider.loginEmailError : null,
                    ),
                    SizedBox(height: 16.h),
                    Text("kPassword".tr(), style: AppStyles.poppinsTextStyle()),
                    SizedBox(height: 4.h),
                    MyCustomTextField(
                      controller: authProvider.loginPassController,
                      // showError: true,
                      hintText: "kPasswordHint".tr(),
                      fillColor: kWhiteColor,
                      suffixIcon: authProvider.isPasswordVisible
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      isObscureText: !authProvider.isPasswordVisible,
                      suffixOnPress: authProvider.togglePasswordVisibility,
                      showError: authProvider.loginPassError.isNotEmpty ? true : false,
                      errorText: authProvider.loginPassError.isNotEmpty ? authProvider.loginPassError : null,
                    ),
                    SizedBox(height: 36.h),
                    CustomButton(
                      text: authProvider.isLoadingLogin ? "Loading... " : "kSignIn".tr(),
                      color: kPrimaryColor,
                      height: 50.h,
                      onTap: (){
                        authProvider.loginWithEmail(context);
                      },
                    ),
                    SizedBox(height: 26.h),
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            "kOr".tr(),
                            style: AppStyles.poppinsTextStyle().copyWith(color: kGreyColor),
                          ),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    SizedBox(height: 26.h),
                    GestureDetector(
                      onTap: () {
                        Provider.of<AuthProvider>(context, listen: false).loginWithGoogle(context);
                      },
                      child: Container(
                        height: 50.h,
                        decoration: BoxDecoration(
                          border: Border.all(color: kBorderColor, width: 1.w),
                          color: Colors.transparent,
                          borderRadius: AppStyles.customBorder8,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(kGoogleIcon, height: 20, width: 20),
                            SizedBox(width: 12.w),
                            Text("kGoogleSignIn".tr(), style: AppStyles.poppinsTextStyle()),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 80.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("kDontHaveAccount".tr(),
                            style: AppStyles.poppinsTextStyle().copyWith(color: kGreyColor)),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, kSignupScreenRoute);
                          },
                          child: Text(
                            " ${"kSignUp".tr()}",
                            style: AppStyles.poppinsTextStyle().copyWith(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: kPrimaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          showLanguageBottomSheet(context);
                        },
                        child: Container(
                          height: 20,
                          width: 85.w,
                          decoration: BoxDecoration(
                            borderRadius: AppStyles.customBorder20,
                            color: kPrimaryColor,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset(kLanguageIcon, height: 13, width: 13),
                              Text(
                                locale.languageCode == 'ar' ? "kArabic".tr() : "kEnglish".tr(),
                                style: AppStyles.poppinsTextStyle().copyWith(
                                  color: kWhiteColor,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
