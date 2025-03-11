import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_images.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Color? iconColor;
  final Color? backgroundColor;
  final List<Widget>? actions;
  final bool centreTitle;
  final bool automaticallyLeading;
  final Widget customTitle;
  final bool backArrow;

  const CustomAppBar({
    super.key,
    this.iconColor,
    this.backgroundColor,
    this.actions,
    this.centreTitle = false,
    required this.automaticallyLeading,
    required this.customTitle,
    this.backArrow = false,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    Locale selectedLocale = Localizations.localeOf(context);

    return AppBar(
      surfaceTintColor: kWhiteColor,
      leading: Visibility(
        visible: widget.backArrow,
        child: InkWell(
          onTap: () => Navigator.pop(context),
          child: Center(
            child: selectedLocale.languageCode == 'ar'
                ? const Icon(Icons.arrow_back)
                : Image.asset(kArrowIcon, height: 24.h, width: 24.w),
          ),
        ),
      ),
      backgroundColor: widget.backgroundColor ?? kWhiteColor,
      iconTheme: IconThemeData(color: widget.iconColor),
      title: widget.customTitle,
      centerTitle: widget.centreTitle,
      automaticallyImplyLeading: widget.automaticallyLeading,
      actions: widget.actions,
    );
  }
}
