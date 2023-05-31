import 'dart:io';

import 'package:chat_app_course/screen/chat/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_course/models/user_models.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthProvider with ChangeNotifier {
  bool isLoginLoadding = false;
  bool isSignupLoadding = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController signupEmailController = TextEditingController();
  TextEditingController signupPasswordController = TextEditingController();

  TextEditingController signupName = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> loginWithEmailAndPassword(context) async {
    try {
      isLoginLoadding = true;
      notifyListeners();
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      if (userCredential.user!.uid.isNotEmpty) {
        isLoginLoadding = false;
        emailController.clear();
        passwordController.clear();
        notifyListeners();
        await Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
          (route) => false,
        );
      }
      // User signup successful
      print('Signup successful: ${userCredential.user!.email}');
    } catch (error) {
      isLoginLoadding = false;
      notifyListeners();
      // Signup failed
      print('Signup failed: $error');
    }
  }

  Future<void> signUpWithEmailAndPassword(
    context, {
    required File imageFile,
  }) async {
    try {
      isSignupLoadding = true;
      notifyListeners();
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: signupEmailController.text,
        password: signupPasswordController.text,
      );
      UserModel userModel = UserModel(
        userEmail: signupEmailController.text,
        userPassword: signupPasswordController.text,
        userImage: "",
        userId: userCredential.user!.uid,
        userName: signupName.text,
        createAt: DateTime.now().millisecondsSinceEpoch.toString(),
        chatingWith: "",
      );
      if (userCredential.user!.uid.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(userCredential.user!.uid)
            .set(userModel.toMap());
        String userImage =
            await uploadImage(imageFile, userCredential.user!.uid);
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(userCredential.user!.uid)
            .update({"userImage": userImage}).then((e) async {
          isSignupLoadding = false;
          notifyListeners();
          await Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
            (route) => false,
          );
        });
      }
      // User signup successful
    } catch (error) {
      isSignupLoadding = false;
      notifyListeners();
      // Signup failed
      print('Signup failed: $error');
    }
  }

  // String uid = FirebaseAuth.instance.currentUser!.uid.isEmpty?"":FirebaseAuth.instance.currentUser!.uid;

  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImage(File imageFile, String uid) async {
    try {
      final Reference storageReference = _storage.ref().child('images/$uid');

      final UploadTask uploadTask = storageReference.putFile(imageFile);
      final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

      final String imageUrl = await taskSnapshot.ref.getDownloadURL();

      return imageUrl;
    } catch (error) {
      print('Image upload failed: $error');
      return '';
    }
  }

  UserModel? userModel;

  getCurrentUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot userData = await FirebaseFirestore.instance
        .collection("Users")
        .doc(user!.uid)
        .get();
    if (userData.exists) {
      userModel = UserModel.fromMap(userData);
      notifyListeners();
    }
  }

  bool isProfileLoadding = false;

  updateUserProfile(
      {required String name,
      required String email,
      required File imageFile}) async {
    try {
      isProfileLoadding = true;
      notifyListeners();
      User? user = FirebaseAuth.instance.currentUser;
      String userImage = await uploadImage(imageFile, user!.uid);
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(user.uid)
          .update({
        "userEmail": email,
        "userName": name,
        "userImage": userImage,
      }).then(
        (value) async {
          isProfileLoadding = false;
          notifyListeners();
          Fluttertoast.showToast(msg: "Profile Updated");
        },
      );
    } catch (error) {
      isProfileLoadding = false;
      notifyListeners();
    }
  }
}
