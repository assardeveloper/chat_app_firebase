import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ChatProvider with ChangeNotifier {
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

  Future<String> uploadImage(File pickedImage) async {
    try {
      final Reference storageReference =
          _storage.ref().child('chats/${DateTime.now()}');

      final UploadTask uploadTask =
          storageReference.putFile(File(pickedImage.path));
      final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

      final String imageUrl = await taskSnapshot.ref.getDownloadURL();

      return imageUrl;
    } catch (error) {
      return '';
    }
  }

  Stream<QuerySnapshot> getAllUsers(int limit, String query) {
    if (query == "") {
      return FirebaseFirestore.instance
          .collection("Users")
          .limit(limit)
          .where("userId", isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .snapshots();
    } else {
      return FirebaseFirestore.instance
          .collection("Users")
          .limit(limit)
          .where("userName", isEqualTo: query)
          .snapshots();
    }
  }
}
