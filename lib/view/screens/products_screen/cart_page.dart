import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerce_app/utils/app_colors.dart';
import 'package:ecommerce_app/utils/app_images.dart';
import 'package:ecommerce_app/utils/app_strings.dart';
import 'package:ecommerce_app/utils/app_styles.dart';
import 'package:ecommerce_app/view/custom_widgets/custom_button.dart';
import 'package:ecommerce_app/view/screens/products_screen/provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../../services/stripe_services.dart';
import '../../custom_widgets/custom_appbar.dart';
import '../../models/product_model/product_model.dart';

class MyCartScreen extends StatefulWidget {
  const MyCartScreen({super.key});

  @override
  State<MyCartScreen> createState() => _MyCartScreenState();
}

class _MyCartScreenState extends State<MyCartScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<ProductProvider>().fetchCartProducts());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.microtask(() {
      if (ModalRoute.of(context)?.isCurrent == false) {
        context.read<ProductProvider>().fetchProducts();
        context.read<ProductProvider>().fetchCartItemCount();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<ProductProvider>().fetchProducts();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "kMyCart".tr(),
            style: AppStyles.poppinsTextStyle().copyWith(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: Consumer<ProductProvider>(
          builder: (context, provider, child) {
            if (provider.isLoadingCart) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.cartProducts.isEmpty) {
              return Center(child: Text("kYourCartEmpty".tr(),style: AppStyles.poppinsTextStyle().copyWith(fontWeight: FontWeight.w700,fontSize: 18.sp),));
            }

            return Padding(
              padding: AppStyles().horizontal,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      physics: const BouncingScrollPhysics(),
                      itemCount: provider.cartProducts.length,
                      itemBuilder: (context, index) {
                        ProductModel product = provider.cartProducts[index];

                        return Container(
                          height: 115.h,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: kBorderColor,
                                width: 2.w,
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 14.0.h),
                            child: Row(
                              children: [
                                Container(
                                  height: 84,
                                  width: 84,
                                  decoration: BoxDecoration(
                                    borderRadius: AppStyles.customBorder10,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: AppStyles.customBorder10,
                                    child:
                                        product.imageUrl != ""
                                            ? CachedNetworkImage(
                                              imageUrl: product.imageUrl,
                                              fit: BoxFit.cover,
                                            )
                                            : Image.asset(
                                              kShirtImage,
                                              fit: BoxFit.cover,
                                            ),
                                  ),
                                ),
                                SizedBox(width: 11.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name,
                                        style: AppStyles.poppinsTextStyle()
                                            .copyWith(
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                      const Spacer(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "\$${product.price}",
                                            style: AppStyles.poppinsTextStyle()
                                                .copyWith(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15,
                                                ),
                                          ),
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap:
                                                    () => provider
                                                        .updateCartQuantity(
                                                          product,
                                                          -1,
                                                        ),
                                                child: Container(
                                                  height: 23.h,
                                                  width: 23.w,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        AppStyles.customBorder8,
                                                    color: kPrimaryColor,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "-",
                                                      style:
                                                          AppStyles.poppinsTextStyle()
                                                              .copyWith(
                                                                fontSize: 18.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color:
                                                                    kWhiteColor,
                                                              ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 12.w,
                                                ),
                                                child: Text(
                                                  product.quantity.toString(),
                                                  style:
                                                      AppStyles.poppinsTextStyle()
                                                          .copyWith(
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: kGreyColor,
                                                          ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap:
                                                    () => provider
                                                        .updateCartQuantity(
                                                          product,
                                                          1,
                                                        ),
                                                child: Container(
                                                  height: 23.h,
                                                  width: 23.w,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        AppStyles.customBorder8,
                                                    color: kPrimaryColor,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "+",
                                                      style:
                                                          AppStyles.poppinsTextStyle()
                                                              .copyWith(
                                                                fontSize: 18.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color:
                                                                    kWhiteColor,
                                                              ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            onPressed:
                                                () => provider.removeFromCart(
                                                  product,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20.h),
                  CustomButton(
                    text:
                        "${"kProceedToCheckout".tr()} | \$${provider.getTotalCartPrice().toStringAsFixed(2)}",
                    height: 48.h,
                    onTap: () async {
                      double totalPrice = provider.getTotalCartPrice();

                      bool paymentSuccess = await StripeService.makePayment(
                        amount: totalPrice,
                      );

                      if (paymentSuccess) {
                        Fluttertoast.showToast(
                          msg: "kPaymentSuccessful".tr(),
                          backgroundColor: Colors.green,
                        );
                        provider.clearCart();
                      } else {
                        Fluttertoast.showToast(
                          msg: "kPaymentFailed".tr(),
                          backgroundColor: Colors.red,
                        );
                      }

                    },
                  ),
                  SizedBox(height: 25.h),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
