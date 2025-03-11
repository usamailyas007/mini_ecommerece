import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerce_app/utils/app_colors.dart';
import 'package:ecommerce_app/utils/app_images.dart';
import 'package:ecommerce_app/utils/app_strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../utils/global.dart';
import '../../../models/user_model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController loginEmailController = TextEditingController();
  final TextEditingController loginPassController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _emailError = '';
  String _passwordError = '';
  bool _isChecked = false;
  bool _isPasswordVisible = false;
  String loginEmailError = "";
  String loginPassError = "";

  String get emailError => _emailError;

  String get passwordError => _passwordError;

  bool get isChecked => _isChecked;

  bool get isPasswordVisible => _isPasswordVisible;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  bool _isLoadingLogin = false;

  bool get isLoadingLogin => _isLoadingLogin;
  bool isLoadingGoogleLogin = false;

  double imageSizeHeight = 200;

  void expandLogo() {
    imageSizeHeight = 200;
    notifyListeners();
  }

  // =============Sign up with email function==============
  Future<Map<String, dynamic>?> signUpWithEmail(BuildContext context) async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String name = nameController.text.trim();

    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      Fluttertoast.showToast(
        msg: "kFieldsRequired".tr(),
        backgroundColor: kRedColor,
        textColor: kWhiteColor,
      );
      return null;
    }

    try {
      _isLoading = true;
      notifyListeners();

      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      UserModel userModel = UserModel(
        uid: userCredential.user!.uid,
        name: name,
        email: email,
        profilePicture: "",
        phoneNumber: "",
        createdAt: DateTime.now(),
      );

      await _firestore
          .collection('users')
          .doc(userModel.uid)
          .set(userModel.toJson());

      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userModel.uid).get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("user_data", jsonEncode(userData));

        userSD = userData;

        nameController.clear();
        emailController.clear();
        passwordController.clear();

        Fluttertoast.showToast(
          msg: "kSignedUpSuccess".tr(),
          backgroundColor: kGreenColor,
          textColor: kWhiteColor,
        );
        Navigator.pushNamedAndRemoveUntil(
          context,
          kAllProductScreenRoute,
          (route) => false,
        );

        return userData;
      }
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: "Error: ${e.message}");
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return null;
  }

  // ===========Login with email function=============
  Future<Map<String, dynamic>?> loginWithEmail(BuildContext context) async {
    if (!validateLoginForm()) return null;

    String email = loginEmailController.text.trim();
    String password = loginPassController.text.trim();

    _isLoadingLogin = true;
    notifyListeners();

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        DocumentSnapshot userDoc =
            await FirebaseFirestore.instance
                .collection("users")
                .doc(user.uid)
                .get();

        if (userDoc.exists) {
          loginPassController.clear();
          loginEmailController.clear();
          Map<String, dynamic> userData =
              userDoc.data() as Map<String, dynamic>;

          userSD = userData;
          notifyListeners();

          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString("user_data", jsonEncode(userData));

          Fluttertoast.showToast(
            msg: "Welcome to your account",
            backgroundColor: Colors.green,
            textColor: kWhiteColor,
          );

          Navigator.pushNamedAndRemoveUntil(
            context,
            kAllProductScreenRoute,
            (route) => false,
          );
          return userData;
        }
      }
    } on FirebaseAuthException catch (e) {
      String message = "kLoginFailed".tr();
      if (e.code == "user-not-found") {
        message = "kNoUserFoundEmail".tr();
      } else if (e.code == 'wrong-password') {
        message = "kIncorrectPassword".tr();
      }

      Fluttertoast.showToast(
        msg: message,
        backgroundColor: kRedColor,
        textColor: kWhiteColor,
      );
    } finally {
      _isLoadingLogin = false;
      notifyListeners();
    }

    return null;
  }

  // =================Login with Google==============
  Future<void> loginWithGoogle(BuildContext context) async {
    try {
      isLoadingGoogleLogin = true;
      notifyListeners();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        isLoadingGoogleLogin = false;
        notifyListeners();
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        final DocumentReference userRef = FirebaseFirestore.instance.collection("users").doc(user.uid);
        final DocumentSnapshot userSnapshot = await userRef.get();

        Map<String, dynamic> userData;

        if (!userSnapshot.exists) {
          // If user does NOT exist, create new user
          userData = {
            "uid": user.uid,
            "name": user.displayName ?? "No Name",
            "email": user.email ?? "",
            "profilePicture":  "",
            "phoneNumber": user.phoneNumber ?? "",
            "createdAt": FieldValue.serverTimestamp(),
          };

          await userRef.set(userData);

          userData["createdAt"] = DateTime.now().toIso8601String();

          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString("user_data", jsonEncode(userData));
          userSD = userData;
          Navigator.pushNamedAndRemoveUntil(context, kAllProductScreenRoute, (route) => false);

        } else {
          // If user exists, fetch their existing data
          userData = userSnapshot.data() as Map<String, dynamic>;

          if (userData["createdAt"] is Timestamp) {
            userData["createdAt"] = (userData["createdAt"] as Timestamp).toDate().toIso8601String();
          }

          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString("user_data", jsonEncode(userData));
          userSD = userData;

          Navigator.pushNamedAndRemoveUntil(context, kAllProductScreenRoute, (route) => false);

        }

      }

    } catch (e) {
      debugPrint("Google Sign-In Error: $e");
      Fluttertoast.showToast(msg: "$e", backgroundColor: kRedColor,textColor: kWhiteColor);

    } finally {
      isLoadingGoogleLogin = false;
      notifyListeners();
    }
  }

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void toggleRememberMe() {
    _isChecked = !_isChecked;
    notifyListeners();
  }

  void validateForm(context) {
    if (!RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
    ).hasMatch(loginEmailController.text)) {
      _emailError = "Invalid email format";
    } else {
      _emailError = "";
    }

    if (loginPassController.text.length < 6) {
      _passwordError = "Password must be at least 6 characters";
    } else {
      _passwordError = "";
    }
    Navigator.pushNamed(context, kAllProductScreenRoute);
    notifyListeners();
  }

  bool validateLoginForm() {
    loginEmailError =
        loginEmailController.text.isEmpty ? "Please enter your email" : "";
    loginPassError =
        loginPassController.text.isEmpty ? "Please enter your password" : "";

    notifyListeners();
    return loginEmailError.isEmpty && loginPassError.isEmpty;
  }

  String _selectedLanguageCode = 'en';

  String get selectedLanguageCode => _selectedLanguageCode;

  //============Set language function==============
  void setLanguage(String languageCode, BuildContext context) {
    _selectedLanguageCode = languageCode;
    Locale locale =
        languageCode == 'ar'
            ? const Locale('ar', 'SA')
            : const Locale('en', 'US');
    context.setLocale(locale);
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    loginPassController.dispose();
    loginEmailController.dispose();
    super.dispose();
  }
}
