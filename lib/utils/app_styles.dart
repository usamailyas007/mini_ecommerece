import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppStyles {

  static TextStyle latoTextStyle() => GoogleFonts.lato(
      fontSize: 14.sp, fontWeight: FontWeight.w700, color: kBlackColor1);


  static TextStyle poppinsTextStyle() => GoogleFonts.poppins(
      fontSize: 14.sp, fontWeight: FontWeight.w400, color: kBlackColor1,);

  static TextStyle interTextStyle() => GoogleFonts.inter(
    fontSize: 14.sp, fontWeight: FontWeight.w400, color: kBlackColor1,);


  static BorderRadius get customBorder20=> BorderRadius.all(
    Radius.circular(20.r),
  );


  static BorderRadius get customBorder8 => BorderRadius.all(
    Radius.circular(8.r),
  );


  static BorderRadius get customBorder10 => BorderRadius.all(
    Radius.circular(10.r),
  );

  static BorderRadius get customBorder14 => BorderRadius.all(
    Radius.circular(14.r),
  );
  static BorderRadius get customBorderAll100 => BorderRadius.all(
    Radius.circular(100.r),
  );

  EdgeInsets get horizontal => EdgeInsets.symmetric(horizontal: 24.0.w);
  EdgeInsets get vertical => EdgeInsets.symmetric(vertical: 20.0.h);
  EdgeInsets get horizontal16 => EdgeInsets.symmetric(horizontal: 16.0.w);
  EdgeInsets get paddingAll24 => EdgeInsets.all(20.0.r);
  EdgeInsets get paddingAll10 => EdgeInsets.all(10.0.r);
  EdgeInsets get paddingAll30 => EdgeInsets.all(30.0.r);
  EdgeInsets get paddingAll32 => EdgeInsets.all(32.0.r);
  EdgeInsets get paddingAll16 => EdgeInsets.all(16.0.r);



}


