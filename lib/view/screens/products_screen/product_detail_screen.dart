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
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../utils/common_code.dart';
import '../../custom_widgets/custom_appbar.dart';
import '../../models/product_model/product_model.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel? product;
  const ProductDetailScreen({super.key, this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  GoogleMapController? mapController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.microtask(() {
      if (ModalRoute.of(context)?.isCurrent == false) {
        context.read<ProductProvider>().fetchCartItemCount();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final locationProvider = context.watch<ProductProvider>();

    if (widget.product == null) {
      return Scaffold(
        appBar: CustomAppBar(
          automaticallyLeading: true,
          customTitle: Text(
            "kProductNotFound".tr(),
            style: AppStyles.poppinsTextStyle()
                .copyWith(fontSize: 20.sp, fontWeight: FontWeight.w600),
          ),
          backArrow: true,
        ),
        body: Center(child: Text("kProductNotFoundDetail".tr())),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        context.read<ProductProvider>().fetchCartItemCount();
        return true;
      },
      child: Scaffold(
        bottomNavigationBar: Consumer<ProductProvider>(
          builder: (context, provider, child) {
            int quantity = int.tryParse(widget.product!.quantity) ?? 1;

            return Container(
              padding: EdgeInsets.symmetric(vertical: 25),
              decoration: const BoxDecoration(color: kWhiteColor),
              child: Padding(
                padding: AppStyles().horizontal,
                child: Row(
                  children: [
                    Text(
                      "\$${(widget.product!.price * quantity).toStringAsFixed(2)}",
                      style: AppStyles.poppinsTextStyle().copyWith(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 19.w),
                    Expanded(
                      child: CustomButton(
                        text: provider.isLoading ? "kAdding".tr() : "kAddToCart".tr(),
                        height: 48.h,
                        onTap: provider.isLoading
                            ? () {}
                            : () {
                          provider.addToCart(widget.product!, quantity);
                        },
                        color: widget.product!.isAddedToCart ? Colors.green : kPrimaryColor,
                        borderColor: widget.product!.isAddedToCart ? Colors.green : kPrimaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        appBar: CustomAppBar(automaticallyLeading: true, customTitle: Text(widget.product!.name,style: AppStyles.poppinsTextStyle().copyWith(fontSize: 20.sp,fontWeight: FontWeight.w600)),backArrow: true,centreTitle: true,),
        body: SingleChildScrollView(
          child: Padding(
            padding: AppStyles().horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 253.h,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: AppStyles.customBorder10
                  ),
                  child: ClipRRect(
                    borderRadius: AppStyles.customBorder10,
                      child: widget.product!.imageUrl != "" ? CachedNetworkImage(imageUrl: widget.product!.imageUrl) : Image.asset(kShirtImage,fit: BoxFit.contain,)),
                ),
                SizedBox(height: 14.h,),
                Text(widget.product!.name,style: AppStyles.poppinsTextStyle().copyWith(fontSize: 16.sp,fontWeight: FontWeight.w500),),
                SizedBox(height: 12.h,),
                Row(
                  children: [
                    Text(
                      "kQuantity".tr(),
                      style: AppStyles.poppinsTextStyle()
                          .copyWith(fontSize: 14.sp, fontWeight: FontWeight.w400, color: kGreyColor),
                    ),
                    const Spacer(),
                    Consumer<ProductProvider>(
                      builder: (context, provider, child) {
                        int quantity = int.tryParse(widget.product!.quantity) ?? 1;

                        return Row(
                          children: [
                            GestureDetector(
                              onTap: () => provider.decrement(widget.product!),
                              child: Container(
                                height: 28.h,
                                width: 28.w,
                                decoration: BoxDecoration(
                                  borderRadius: AppStyles.customBorder8,
                                  color: kPrimaryColor,
                                ),
                                child: Center(
                                  child: Text(
                                    "-",
                                    style: AppStyles.poppinsTextStyle().copyWith(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w700,
                                      color: kWhiteColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              child: Text(
                                quantity.toString(),
                                style: AppStyles.poppinsTextStyle().copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: kGreyColor,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => provider.increment(widget.product!),
                              child: Container(
                                height: 28.h,
                                width: 28.w,
                                decoration: BoxDecoration(
                                  borderRadius: AppStyles.customBorder8,
                                  color: kPrimaryColor,
                                ),
                                child: Center(
                                  child: Text(
                                    "+",
                                    style: AppStyles.poppinsTextStyle().copyWith(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w700,
                                      color: kWhiteColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10.h,),
                Text(widget.product!.description,style: AppStyles.poppinsTextStyle().copyWith(color: kGreyColor),),
                SizedBox(height: 20.h,),
                if (locationProvider.isLoading)
                  Center(child: CircularProgressIndicator())
                else if (locationProvider.userLocation != null)
                  Container(
                    height: 200.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: kBorderColor,
                        width: 2.w
                      )
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: locationProvider.userLocation!,
                          zoom: 15,
                        ),
                        markers: {
                          Marker(
                            markerId: MarkerId("User Location"),
                            position: locationProvider.userLocation!,
                            infoWindow: InfoWindow(title: "Your Location"),
                          ),
                        },
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        onMapCreated: (GoogleMapController controller) {
                          mapController = controller;
                          mapController!.setMapStyle(CommonCode.mapStyles);

                        },
                      ),
                    ),
                  )
                else
                  Center(child: Text("Failed to get location")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
