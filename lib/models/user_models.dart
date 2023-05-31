import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String userEmail;
  String userName;
  String userPassword;
  String userImage;
  String createAt;
  String chatingWith;

  UserModel({
    required this.userName,
    required this.userPassword,
    required this.userImage,
    required this.userEmail,
    required this.createAt,
    required this.chatingWith,
  });
  factory UserModel.fromMap(DocumentSnapshot<Object?> map) {
    return UserModel(
        userName: map['userName'],
        userPassword: map['userPassword'],
        userImage: map['userImage'],
        userEmail: map['userEmail'],
        chatingWith: map["chatingWith"],
        createAt: map["createAt"]);
  }
  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'userPassword': userPassword,
      'userImage': userImage,
      'userEmail': userEmail,
      'chatingWith': chatingWith,
      'createAt': createAt,
    };
  }
}
