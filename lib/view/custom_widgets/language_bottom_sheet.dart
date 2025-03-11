import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_styles.dart';
import '../screens/auth_screens/provider/auth_provider.dart';
import 'custom_button.dart';

class LanguageBottomSheet extends StatelessWidget {
  const LanguageBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Padding(
      padding: AppStyles().paddingAll24,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 10.h),
          Text(
            "kAppLanguage".tr(),
            style: AppStyles.poppinsTextStyle().copyWith(fontSize: 18.sp, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 21.h),
          SizedBox(
            height: 120.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    authProvider.setLanguage('en',context);
                    context.setLocale(const Locale('en', 'US'));
                    log('English Selected');
                  },
                  child: _buildLanguageOption(context, 'en', kEnglish, authProvider.selectedLanguageCode),
                ),
                GestureDetector(
                  onTap: () {
                    authProvider.setLanguage('ar',context);
                    context.setLocale(const Locale('ar', 'SA'));
                    log('Arabic Selected');
                  },
                  child: _buildLanguageOption(context, 'ar', kArabic, authProvider.selectedLanguageCode),
                ),
              ],
            ),
          ),
          SizedBox(height: 26.h),
          CustomButton(
            color: kPrimaryColor,
            text: "kClose".tr(),
            height: 50.h,
            onTap: () {
              Navigator.pop(context);
            },
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(BuildContext context, String value, String title, String selectedValue) {
    return Container(
      height: 49.h,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border(bottom: BorderSide(color: kBlackColor1, width: 0.3.w)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppStyles.interTextStyle().copyWith(fontSize: 14.sp, fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 15,
            width: 15,
            child: Radio(
              value: value,
              groupValue: selectedValue,
              focusColor: selectedValue == value ? kPrimaryColor : kGreyColor,
              fillColor: MaterialStateProperty.resolveWith((states) => selectedValue == value ? kPrimaryColor : kGreyColor),
              onChanged: (val) {
                if (val != null) {
                  Provider.of<AuthProvider>(context, listen: false).setLanguage(val,context);
                  context.setLocale(Locale(val == 'en' ? 'en' : 'ar', val == 'en' ? 'US' : 'SA'));
                  log('Radio button selected: $val');
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
