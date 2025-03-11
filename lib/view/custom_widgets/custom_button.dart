import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_styles.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color? color;
  final Color? gradientColor1;
  final Color? gradientColor2;
  final Color? textColor;
  final Color? borderColor;
  final double? width;
  final double height;
  final double? fontSize;
  final VoidCallback onTap;
  bool? isImage = false;
  bool? isGradientBtn = false;
  String? image;
  BorderRadius? borderRadius;
  // bool? buttonTextStyle = false;

  CustomButton(
      {super.key,
        required this.text,
        this.color,
        this.gradientColor1,
        this.gradientColor2,
        this.textColor,
        this.width,
        required this.height,
        required this.onTap,
        this.isImage,
        this.image,
        this.isGradientBtn,
        this.borderColor,
        // this.buttonTextStyle,
        this.fontSize,
        this.borderRadius,
      });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          border: Border.all(color: borderColor ?? kPrimaryColor),
          borderRadius: AppStyles.customBorder8,
          gradient: isGradientBtn == true ? LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
              colors: [
                gradientColor1 ?? Colors.transparent,
                gradientColor2 ?? Colors.transparent
          ]) : null,
          color: color ?? kPrimaryColor
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(isImage == true)
            Image.asset(image!,height: 30,width: 30,),
            if(isImage == true)
              SizedBox(width: 10.w),
            isImage == true ? Text(
                text,
                textAlign: TextAlign.center,
                style: AppStyles.poppinsTextStyle().copyWith(fontSize: fontSize ?? 17.sp,fontWeight: FontWeight.w600,color: textColor ?? kWhiteColor)
            )
                : Expanded(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: AppStyles.poppinsTextStyle().copyWith(fontSize: fontSize ?? 17.sp,fontWeight: FontWeight.w600,color: textColor ?? kWhiteColor)
              ),
            )
          ],
        ),
      ),
    );
  }
}
