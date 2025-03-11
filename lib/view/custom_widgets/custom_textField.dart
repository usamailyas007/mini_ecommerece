import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_styles.dart';

class MyCustomTextField extends StatefulWidget {
  final String? hintText;
  final String? labelText;
  final IconData? suffixIcon;
  final VoidCallback? suffixOnPress;
  final VoidCallback? onTap;
  final Widget? prefixIcon;
  final Color? fillColor;
  final TextEditingController? controller;
  final TextInputType? textInputType;
  final Color? hintColor;
  final Color? textColor;
  final Color? borderColor;
  final String? errorText;
  final bool showError;
  final bool isObscureText;
  final double? width;
  final int? maxLines;
  final ValueChanged<String>? onChanged;
  final EdgeInsetsGeometry? contentPadding;
  final TextDirection? textDirection;

  const MyCustomTextField({
    super.key,
    this.hintText,
    this.labelText,
    this.suffixIcon,
    this.suffixOnPress,
    this.onTap,
    this.prefixIcon,
    this.controller,
    this.textInputType,
    this.fillColor,
    this.hintColor,
    this.textColor,
    this.errorText,
    this.isObscureText = false,
    this.showError = false,
    this.width,
    this.onChanged,
    this.maxLines,
    this.contentPadding,
    this.borderColor,
    this.textDirection,
  });

  @override
  State<MyCustomTextField> createState() => _MyCustomTextFieldState();
}

class _MyCustomTextFieldState extends State<MyCustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 48.h,
          child: TextField(
            onTap: widget.onTap,
            textDirection: widget.textDirection,
            controller: widget.controller,
            keyboardType: widget.textInputType,
            obscureText: widget.isObscureText,
            onChanged: widget.onChanged,
            maxLines: widget.isObscureText ? 1 : widget.maxLines ?? 1,
            style: TextStyle(color: widget.textColor),
            decoration: InputDecoration(
              contentPadding: widget.contentPadding,
              labelText: widget.labelText,
              labelStyle: TextStyle(color: widget.hintColor ?? kGreyColor),
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.suffixIcon != null
                  ? IconButton(
                onPressed: widget.suffixOnPress,
                icon: Icon(widget.suffixIcon, color: kBorderColor, size: 20),
              )
                  : null,
              fillColor: widget.fillColor,
              filled: true,
              hintText: widget.hintText,
              hintStyle: AppStyles.poppinsTextStyle().copyWith(color: widget.hintColor ?? kGreyColor),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: widget.showError ? Colors.red : (widget.borderColor ?? kBorderColor),
                ),
                borderRadius: AppStyles.customBorder10,
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red),
                borderRadius: AppStyles.customBorder10,
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red),
                borderRadius: AppStyles.customBorder10,
              ),
            ),
          ),
        ),
        if (widget.showError && widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 5),
            child: Text(
              widget.errorText!,
              style: AppStyles.poppinsTextStyle().copyWith(
                fontSize: 12,
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}
