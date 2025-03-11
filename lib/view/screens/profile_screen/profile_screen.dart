import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart' as local;
import 'package:ecommerce_app/utils/app_images.dart';
import 'package:ecommerce_app/view/screens/profile_screen/provider/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_strings.dart';
import '../../../utils/app_styles.dart';
import '../../../utils/common_code.dart';
import '../../custom_widgets/custom_appbar.dart';
import '../../custom_widgets/custom_button.dart';
import '../../custom_widgets/custom_textField.dart';
import '../../models/user_model/user_model.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<ProfileProvider>(context, listen: false).loadUserData());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        CommonCode.unFocus(context);
      },
      child: Scaffold(
        appBar: CustomAppBar(
          backArrow: true,
          iconColor: kWhiteColor,
          centreTitle: true,
          automaticallyLeading: true,
          customTitle: Text(
            "kMyProfile".tr(),
            style: AppStyles.poppinsTextStyle()
                .copyWith(fontSize: 20.sp, fontWeight: FontWeight.w500),
          ),
        ),
        body: Consumer<ProfileProvider>(
          builder: (context, profileProvider, child) {
            final user = profileProvider.user;

            return SingleChildScrollView(
              child: Padding(
                padding: AppStyles().paddingAll24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5.h),
                    GestureDetector(
                      onTap: (){
                        profileProvider.pickImageFromGallery();
                      },
                      child: Center(
                        child: SizedBox(
                          height: 100.h,
                          width: 100.h,
                          child: Stack(
                            children: [
                              Container(
                                height: 100.h,
                                width: 100.h,
                                decoration: BoxDecoration(
                                  borderRadius: AppStyles.customBorderAll100,
                                ),
                                child: ClipRRect(
                                  borderRadius: AppStyles.customBorderAll100,
                                  child: profileProvider.selectedImage != null
                                      ? Image.file(
                                    File(profileProvider.selectedImage!.path),
                                    fit: BoxFit.cover,
                                  )
                                      : user?.profilePicture != ""
                                      ? CachedNetworkImage(imageUrl: user!.profilePicture, fit: BoxFit.cover,)
                                      : Image.asset(kProfileImage, fit: BoxFit.cover),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  profileProvider.pickImageFromGallery();
                                },
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    height: 30.h,
                                    width: 30.w,
                                    decoration: BoxDecoration(
                                      color: kPrimaryColor,
                                      borderRadius: BorderRadius.circular(100.r),
                                    ),
                                    child: Center(
                                      child: Icon(Icons.edit, size: 13, color: kWhiteColor),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30.h),
                    Text("kName".tr(), style: AppStyles.poppinsTextStyle()),
                    SizedBox(height: 8.h),
                    MyCustomTextField(
                      hintText: "kNameHint".tr(),
                      controller: profileProvider.nameController,
                      textInputType: TextInputType.name,
                    ),
                    SizedBox(height: 10.h),
                    Text("kEmail".tr(), style: AppStyles.poppinsTextStyle()),
                    SizedBox(height: 8.h),
                    MyCustomTextField(
                      hintText: "kEmailHint".tr(),
                      textInputType: TextInputType.emailAddress,
                      controller: profileProvider.emailController,
                    ),
                    SizedBox(height: 10.h),
                    Text("kMobile".tr(), style: AppStyles.poppinsTextStyle()),
                    SizedBox(height: 8.h),
                    MyCustomTextField(
                      textDirection: TextDirection.ltr,
                      hintText: "kMobileHint".tr(),
                      textInputType: TextInputType.number,
                      controller: profileProvider.numberController,
                    ),
                    SizedBox(height: 180.h),
                    Consumer<ProfileProvider>(
                      builder: (context, profileProvider, child) {
                        return profileProvider.isLoading
                            ? Center(child: CircularProgressIndicator(color: kPrimaryColor))
                            : CustomButton(
                          text: kUpdate,
                          onTap: () {
                            final updatedUser = UserModel(
                              uid: profileProvider.user!.uid,
                              name: profileProvider.nameController.text,
                              email: profileProvider.emailController.text,
                              phoneNumber: profileProvider.numberController.text,
                              profilePicture: profileProvider.user?.profilePicture ?? "",
                            );
                            profileProvider.updateUser(updatedUser).then((_) {
                              Fluttertoast.showToast(
                                msg: "kProfileUpdated".tr(),
                                backgroundColor: Colors.green,
                              );
                            }).catchError((error) {
                              Fluttertoast.showToast(
                                msg: error.toString(),
                                backgroundColor: kRedColor,
                              );
                            });
                          },
                          height: 52.h,
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
