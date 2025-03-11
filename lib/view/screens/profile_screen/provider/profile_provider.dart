import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/user_model/user_model.dart';

class ProfileProvider extends ChangeNotifier {
  UserModel? _user;
  UserModel? get user => _user;
  File? _selectedImage;
  File? get selectedImage => _selectedImage;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final ImagePicker _picker = ImagePicker();

  //  ====================Pick Image From Gallery Function==============
  Future<void> pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _selectedImage = File(pickedFile.path);
      notifyListeners();
    }
  }

  Future<String?> uploadProfileImage(File imageFile, String userId) async {
    try {
      final ref = _storage.ref().child("profile_images/$userId.jpg");
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  //  ====================Load User Data From Local====================
  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString("user_data");

    if (userDataString != null) {
      Map<String, dynamic> userData = jsonDecode(userDataString);
      _user = UserModel.fromJson(userData);

      nameController.text = _user?.name ?? "";
      emailController.text = _user?.email ?? "";
      numberController.text = _user?.phoneNumber ?? "";

      notifyListeners();
    }
  }

  //  ====================Update User Profile Function====================
  Future<void> updateUser(UserModel updatedUser) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (selectedImage != null) {
        String? imageUrl = await uploadProfileImage(selectedImage!, updatedUser.uid);
        if (imageUrl != null) {
          updatedUser = UserModel(
            uid: updatedUser.uid,
            name: updatedUser.name,
            email: updatedUser.email,
            phoneNumber: updatedUser.phoneNumber,
            profilePicture: "",
          );
        }
      }

      await _firestore.collection("users").doc(updatedUser.uid).set(updatedUser.toJson());

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("user_data", jsonEncode(updatedUser.toJson()));

      _user = updatedUser;
    } catch (e) {
      print("Error updating user: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

}
