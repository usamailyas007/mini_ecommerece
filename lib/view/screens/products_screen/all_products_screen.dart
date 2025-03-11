import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerce_app/utils/app_images.dart';
import 'package:ecommerce_app/utils/app_strings.dart';
import 'package:ecommerce_app/view/screens/products_screen/provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_styles.dart';
import '../../custom_widgets/custom_textField.dart';
import '../../models/product_model/product_model.dart';
import '../../models/user_model/user_model.dart';


class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({super.key});

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  UserModel? _user;

  Future<void> _loadUserData() async {
    UserModel? user = await getUserFromLocalStorage();
    if (user != null) {
      setState(() {
        _user = user;
      });
    }
  }

  Future<UserModel?> getUserFromLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString("user_data");

    if (userDataString != null) {
      Map<String, dynamic> userData = jsonDecode(userDataString);
      return UserModel.fromJson(userData);
    }
    return null;
  }

  Future<bool> _showLogoutDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: kPrimaryColor,
        title: Text("${"kLogout".tr()} !!"),
        content: Text("kLogoutDetail".tr(),style: AppStyles.poppinsTextStyle().copyWith(color: kWhiteColor),),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text("kCancel".tr(),style: AppStyles.poppinsTextStyle().copyWith(color: kWhiteColor),),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text("kLogout".tr(),style: AppStyles.poppinsTextStyle().copyWith(color: kWhiteColor),),
          ),
        ],
      ),
    ) ?? false;
  }


  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _loadUserData();
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
      Provider.of<ProductProvider>(context, listen: false).fetchCartItemCount();
      Provider.of<ProductProvider>(context, listen: false).getUserLocation();
    });
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        floatingActionButton: Consumer<ProductProvider>(
          builder: (context, productProvider, child) {
            return SizedBox(
              child: Stack(
                children: [
                  FloatingActionButton(
                    elevation: 0,
                    backgroundColor: kPrimaryColor,
                    onPressed: () {
                      Navigator.pushNamed(context, kMyCartScreenRoute).then((_) {
                        Provider.of<ProductProvider>(context, listen: false).fetchProducts();
                        Provider.of<ProductProvider>(context, listen: false).fetchCartItemCount();
                      });
                    },
                    child: Icon(Icons.shopping_cart_outlined, color: kWhiteColor),
                  ),
                  if (productProvider.cartItemCount > 0)
                    Positioned(
                      right: 0,
                      top: -4,
                      child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          productProvider.cartItemCount.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          actions: [
            IconButton(icon: Icon(Icons.logout),color: kPrimaryColor,onPressed: () async {
              bool confirmLogout = await _showLogoutDialog(context);
              if (confirmLogout) {
                await Provider.of<ProductProvider>(context, listen: false).logoutUser(context);
              }
            })
          ],
          title: Text("kHome".tr(),style: AppStyles.poppinsTextStyle().copyWith(fontSize: 20.sp,fontWeight: FontWeight.w600)),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: AppStyles().horizontal,
            child: Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    SizedBox(height: 16.h),
                    MyCustomTextField(
                      hintText: "kSearch".tr(),
                      prefixIcon: Icon(Icons.search_rounded),
                      onChanged: (value) {
                        Provider.of<ProductProvider>(context, listen: false).searchProducts(value);
                      },
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      "kRecommended".tr(),
                      style: AppStyles.poppinsTextStyle().copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    _buildProductGrid(productProvider,context),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, kProfileScreenRoute);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _user != null ? "${"kHello".tr()} ${_user!.name} 👋" : "kHelloUser".tr(),
                style: AppStyles.poppinsTextStyle().copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 20.sp,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                "kStartShopping".tr(),
                style: AppStyles.poppinsTextStyle().copyWith(
                  fontWeight: FontWeight.w500,
                  color: kBlackColor1.withOpacity(0.5),
                ),
              ),
            ],
          ),
          CircleAvatar(
            radius: 25,
            backgroundImage: _user != null && _user!.profilePicture.isNotEmpty
                ? CachedNetworkImageProvider(_user!.profilePicture)
                : AssetImage(kProfileImage) as ImageProvider,
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid(ProductProvider productProvider, BuildContext context) {
    if (productProvider.products.isEmpty) {
      return FutureBuilder(
        future: Future.delayed(Duration(seconds: 3)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              height: 300.h,
              child: Center(
                child: CircularProgressIndicator(color: kPrimaryColor),
              ),
            );
          } else {
            return Center(
              child: Text(
                "kNoProductFound".tr(),
                style: AppStyles.poppinsTextStyle().copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: kGreyColor,
                ),
              ),
            );
          }
        },
      );
    }

    return Wrap(
      spacing: 10.w,
      runSpacing: 12.h,
      children: productProvider.products.map((product) {
        return _buildProductCard(product, context);
      }).toList(),
    );
  }

  Widget _buildProductCard(ProductModel product,BuildContext context,) {
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, kProductDetailScreenRoute, arguments: product).then((_) {
          Provider.of<ProductProvider>(context, listen: false).fetchCartItemCount();
        });
      },
      child: Container(
        width: (ScreenUtil().screenWidth - 60.w) / 2,
        decoration: BoxDecoration(
          borderRadius: AppStyles.customBorder14,
          color: kWhiteColor,
          border: Border.all(color: kBorderColor, width: 1.w),
          boxShadow: [
            BoxShadow(
              color: kBlackColor1.withOpacity(0.06),
              spreadRadius: -5,
              blurRadius: 20,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(4.r),
          child: Column(
            children: [
              Container(
                height: 202.h,
                width: 166.w,
                decoration: BoxDecoration(
                  borderRadius: AppStyles.customBorder10,
                ),
                child: ClipRRect(
                  borderRadius: AppStyles.customBorder10,
                  child: CachedNetworkImage(
                    imageUrl: product.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Image.asset(kShirtImage,fit: BoxFit.contain,),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("\$${product.price}",
                            style: AppStyles.poppinsTextStyle().copyWith(
                                fontWeight: FontWeight.w600, color: kGreenColor)),
                        Text("${product.size}, ${product.color}",
                            style: AppStyles.poppinsTextStyle().copyWith(
                                fontWeight: FontWeight.w600,
                                color: kGreyColor,
                                fontSize: 12.sp)),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(product.name, style: AppStyles.poppinsTextStyle()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
