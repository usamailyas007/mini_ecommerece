import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerce_app/utils/app_colors.dart';
import 'package:ecommerce_app/utils/app_strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../../../models/product_model/product_model.dart';

class ProductProvider extends ChangeNotifier {
  List<ProductModel> _allProducts = [];
  List<ProductModel> _cartProducts = [];
  List<ProductModel> get cartProducts => _cartProducts;
  List<ProductModel> _filteredProducts = [];
  String _searchQuery = "";
  List<ProductModel> get products => _filteredProducts;
  String get searchQuery => _searchQuery;
  int _quantity = 1;
  int get quantity => _quantity;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int _cartItemCount = 0;
  int get cartItemCount => _cartItemCount;

  LatLng? _userLocation;
  bool _isLocLoading = false;

  LatLng? get userLocation => _userLocation;
  bool get isLocLoading => _isLocLoading;


  bool _isLoadingCart = false;
  bool get isLoadingCart => _isLoadingCart;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> getUserLocation() async {
    _isLoading = true;
    notifyListeners();

    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      _userLocation = LatLng(position.latitude, position.longitude);

    } catch (e) {
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchProducts(String query) {
    _searchQuery = query;
    if (query.isEmpty) {
      _filteredProducts = List.from(_allProducts);
    } else {
      _filteredProducts = _allProducts
          .where((product) =>
          product.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  void increment(ProductModel product) {
    int currentQuantity = int.tryParse(product.quantity) ?? 1;
    product.quantity = (currentQuantity + 1).toString();
    notifyListeners();
  }

  void decrement(ProductModel product) {
    int currentQuantity = int.tryParse(product.quantity) ?? 1;

    if (currentQuantity > 1) {
      product.quantity = (currentQuantity - 1).toString();
      notifyListeners();
    }
  }

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      QuerySnapshot snapshot = await _firestore.collection('product').get();

      _allProducts = snapshot.docs.map((doc) {
        return ProductModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      _filteredProducts = List.from(_allProducts);
    } catch (e) {
      debugPrint("Error fetching products: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> logoutUser(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("user_data");
    await _auth.signOut();

    Navigator.pushNamedAndRemoveUntil(context, kSignInScreenRoute, (route) => false);
  }

  Future<void> addToCart(ProductModel product, int quantity) async {
    try {
      _isLoading = true;
      notifyListeners();

      String userId = FirebaseAuth.instance.currentUser!.uid;
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      DocumentReference cartRef = firestore.collection("cart").doc(userId);
      DocumentReference productRef = firestore.collection("product").doc(product.id);

      DocumentSnapshot cartSnapshot = await cartRef.get();
      Map<String, dynamic> cartData = cartSnapshot.exists ? cartSnapshot.data() as Map<String, dynamic> : {};

      List<dynamic> cartItems = cartData["items"] ?? [];

      int existingIndex = cartItems.indexWhere((item) => item["id"] == product.id);

      if (existingIndex != -1) {
        int newQuantity = cartItems[existingIndex]["quantity"].toString().isNotEmpty
            ? int.parse(cartItems[existingIndex]["quantity"]) + quantity
            : quantity;

        cartItems[existingIndex]["quantity"] = newQuantity.toString();
        cartItems[existingIndex]["totalPrice"] = (newQuantity * product.price);
      } else {
        cartItems.add({
          "id": product.id,
          "name": product.name,
          "imageUrl": product.imageUrl,
          "price": product.price,
          "quantity": quantity.toString(),
          "totalPrice": product.price * quantity,
          "isAddedToCart": true,
        });
      }

      await cartRef.set({"items": cartItems});

      await productRef.update({"isAddedToCart": true});

      product.isAddedToCart = true;
      notifyListeners();

      Fluttertoast.showToast(
        msg: "kProductAddedCart".tr(),
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "${"kFailedAddedCart".tr()} $e",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCartProducts() async {
    try {
      _isLoadingCart = true;
      notifyListeners();

      String userId = FirebaseAuth.instance.currentUser!.uid;
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      DocumentSnapshot cartSnapshot = await firestore.collection("cart").doc(userId).get();

      if (!cartSnapshot.exists) {
        _cartProducts = [];
      } else {
        Map<String, dynamic> cartData = cartSnapshot.data() as Map<String, dynamic>;
        List<dynamic> cartItems = cartData["items"] ?? [];

        _cartProducts = cartItems.map((item) => ProductModel.fromJson(item)).toList();
      }

      _isLoadingCart = false;
      notifyListeners();
    } catch (e) {
      _isLoadingCart = false;
      notifyListeners();
    }
  }

  Future<void> updateCartQuantity(ProductModel product, int change) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentReference cartRef = FirebaseFirestore.instance.collection("cart").doc(userId);

      DocumentSnapshot cartSnapshot = await cartRef.get();
      if (!cartSnapshot.exists) return;

      Map<String, dynamic> cartData = cartSnapshot.data() as Map<String, dynamic>;
      List<dynamic> cartItems = cartData["items"] ?? [];

      int productIndex = cartItems.indexWhere((item) => item["id"] == product.id);
      if (productIndex == -1) return;

      int currentQuantity = int.tryParse(cartItems[productIndex]["quantity"].toString()) ?? 0;
      int newQuantity = currentQuantity + change;

      if (newQuantity < 1) {
        cartItems.removeAt(productIndex);
      } else {
        cartItems[productIndex]["quantity"] = newQuantity.toString();
        cartItems[productIndex]["totalPrice"] = (newQuantity * product.price).toString();
      }

      await cartRef.update({"items": cartItems});

      if (newQuantity < 1) {
        _cartProducts.removeWhere((p) => p.id == product.id);
      } else {
        _cartProducts[productIndex].quantity = newQuantity.toString();
      }

      notifyListeners();
    } catch (e) {
      log("Error updating quantity: $e");
    }
  }

  Future<void> removeFromCart(ProductModel product) async {
    try {
      _isLoadingCart = true;
      notifyListeners();

      String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentReference cartRef = FirebaseFirestore.instance.collection("cart").doc(userId);
      DocumentReference productRef = FirebaseFirestore.instance.collection("product").doc(product.id);


      DocumentSnapshot cartSnapshot = await cartRef.get();
      if (!cartSnapshot.exists) return;

      Map<String, dynamic> cartData = cartSnapshot.data() as Map<String, dynamic>;
      List<dynamic> cartItems = cartData["items"] ?? [];

      cartItems.removeWhere((item) => item["id"] == product.id);

      await cartRef.update({"items": cartItems});

      await productRef.update({"isAddedToCart": false});


      product.isAddedToCart = false;

      _cartProducts.removeWhere((p) => p.id == product.id);

      Fluttertoast.showToast(msg: "kProductRemoved".tr(), backgroundColor: Colors.green,textColor: kWhiteColor);
      _isLoadingCart = false;
      notifyListeners();
    } catch (e) {
      _isLoadingCart = false;
      notifyListeners();
    }
  }

  Future<void> clearCart() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentReference cartRef = FirebaseFirestore.instance.collection("cart").doc(userId);

      DocumentSnapshot cartSnapshot = await cartRef.get();
      if (cartSnapshot.exists) {
        Map<String, dynamic> cartData = cartSnapshot.data() as Map<String, dynamic>;
        List<dynamic> cartItems = cartData["items"] ?? [];

        for (var item in cartItems) {
          String productId = item["id"];
          DocumentReference productRef = FirebaseFirestore.instance.collection("product").doc(productId);

          await productRef.update({"isAddedToCart": false});
        }
      }

      await cartRef.update({"items": []});

      for (var product in _cartProducts) {
        product.isAddedToCart = false;
      }

      _cartProducts.clear();
      notifyListeners();
    } catch (e) {
      debugPrint("Error clearing cart: $e");
    }
  }

  double getTotalCartPrice() {
    return _cartProducts.fold(0.0, (sum, item) {
      int quantity = int.tryParse(item.quantity) ?? 0;
      return sum + (item.price * quantity);
    });
  }

  Future<void> fetchCartItemCount() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentReference cartRef = FirebaseFirestore.instance.collection("cart").doc(userId);

      DocumentSnapshot cartSnapshot = await cartRef.get();
      if (!cartSnapshot.exists) {
        _cartItemCount = 0;
        notifyListeners();
        return;
      }

      Map<String, dynamic> cartData = cartSnapshot.data() as Map<String, dynamic>;
      List<dynamic> cartItems = cartData["items"] ?? [];

      _cartItemCount = cartItems.fold(0, (sum, item) {
        return sum + (int.tryParse(item["quantity"].toString()) ?? 0);
      });

      notifyListeners();
    } catch (e) {
      log("Error fetching cart count: $e");
    }
  }


}
