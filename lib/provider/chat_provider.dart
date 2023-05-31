import 'package:chat_app_course/models/user_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatProvider with ChangeNotifier {
  List<UserModel> usersList = [];
  getHomeUsers() async {
    List<UserModel> newList = [];

    UserModel? userModel;
    String uid = FirebaseAuth.instance.currentUser!.uid;
    QuerySnapshot data =
        await FirebaseFirestore.instance.collection("Users").get();
    for (var element in data.docs) {
      if (element.exists) {
        if (element.get("userId") != uid) {
          
          userModel = UserModel.fromMap(element);
          newList.add(userModel);
        }
      }
    }
    usersList = newList;
    notifyListeners();
  }
}
