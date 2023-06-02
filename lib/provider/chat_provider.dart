import 'dart:io';

import 'package:chat_app_course/models/user_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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

  List<UserModel> searchBar(String query) {
    List<UserModel> seachList = [];
    seachList = usersList
        .where(
          (element) =>
              element.userName.toLowerCase().contains(query) ||
              element.userName.toUpperCase().contains(query),
        )
        .toList();
    return seachList;
  }

  void sendMessage({
    required String message,
    required String type,
    required String groupId,
    required String name,
    required String id,
  }) async {
    DocumentReference value = FirebaseFirestore.instance
        .collection("chating")
        .doc(groupId)
        .collection(groupId)
        .doc(DateTime.now().millisecondsSinceEpoch.toString());

    value.set(
      {
        "time": DateTime.now().millisecondsSinceEpoch.toString(),
        "userId": id,
        "message": message,
        "type": type,
        "name": name,
        "id": value.id,
      },
    );
  }

  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImage(XFile pickedImage) async {
    try {
     

      final Reference storageReference = _storage.ref().child('chats/${DateTime.now()}');

      final UploadTask uploadTask =
          storageReference.putFile(File(pickedImage.path));
      final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

      final String imageUrl = await taskSnapshot.ref.getDownloadURL();

      return imageUrl;
    } catch (error) {
      return '';
    }
  }
}
