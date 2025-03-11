import 'package:easy_localization/easy_localization.dart' as loc;
import 'package:ecommerce_app/view/screens/auth_screens/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_images.dart';
import '../../../utils/app_strings.dart';
import '../../../utils/app_styles.dart';
import '../../../utils/common_code.dart';
import '../../custom_widgets/custom_appbar.dart';
import '../../custom_widgets/custom_button.dart';
import '../../custom_widgets/custom_textField.dart';
import '../../custom_widgets/language_bottom_sheet.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

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

  @override
  Widget build(BuildContext context) {
    Locale locale = context.locale;
    return GestureDetector(
      onTap: () => CommonCode.unFocus(context),
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
                        "kWelcomeUser".tr(),
                        style: AppStyles.poppinsTextStyle().copyWith(fontSize: 24.sp, fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Center(
                      child: Text(
                        "kSignInToJoin".tr(),
                        style: AppStyles.poppinsTextStyle().copyWith(color: kGreyColor),
                      ),
                    ),
                    SizedBox(height: 60.h),
                    Text("kName".tr(), style: AppStyles.poppinsTextStyle()),
                    SizedBox(height: 4.h),
                    MyCustomTextField(
                      controller: authProvider.nameController,
                      hintText: "kNameHint".tr(),
                      fillColor: kWhiteColor,
                      textInputType: TextInputType.name,
                    ),
                    SizedBox(height: 16.h),
                    Text("kEmail".tr(), style: AppStyles.poppinsTextStyle()),
                    SizedBox(height: 4.h),
                    MyCustomTextField(
                      controller: authProvider.emailController,
                      textDirection: TextDirection.ltr,
                      hintText: "kEmailHint".tr(),
                      fillColor: kWhiteColor,
                      textInputType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 16.h),
                    Text("kPassword".tr(), style: AppStyles.poppinsTextStyle()),
                    SizedBox(height: 4.h),
                    MyCustomTextField(
                      controller: authProvider.passwordController,
                      hintText: "kPasswordHint".tr(),
                      fillColor: kWhiteColor,
                      suffixIcon: authProvider.isPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      isObscureText: !authProvider.isPasswordVisible,
                      suffixOnPress: authProvider.togglePasswordVisibility,
                    ),
                    SizedBox(height: 16.h),
                    SizedBox(height: 36.h),
                    CustomButton(
                      text: authProvider.isLoading ? "Signing Up..." : "kSignUp".tr(),
                      color: kPrimaryColor,
                      height: 50.h,
                      onTap: (){
                        authProvider.signUpWithEmail(context);
                      },
                    ),
                    SizedBox(height: 80.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("kHaveAccount".tr(),
                            style: AppStyles.poppinsTextStyle().copyWith(color: kGreyColor)),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, kSignInScreenRoute);
                          },
                          child: Text(
                            " ${"kSignIn".tr()}",
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
                        onTap: () => showLanguageBottomSheet(context),
                        child: Container(
                          height: 20,
                          width: 85.w,
                          decoration: BoxDecoration(borderRadius: AppStyles.customBorder20, color: kPrimaryColor),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset(kLanguageIcon, height: 13, width: 13),
                              Text(
                                locale.languageCode == 'ar' ? "kArabic".tr() : "kEnglish".tr(),
                                style: AppStyles.poppinsTextStyle().copyWith(color: kWhiteColor, fontSize: 12.sp, fontWeight: FontWeight.w500),
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
