import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String userEmail;
  String userName;
  String userPassword;
  String userImage;
  String createAt;
  String chatingWith;
  String userId;
  String status;

  UserModel({
    required this.userName,
    required this.userPassword,
    required this.userImage,
    required this.userEmail,
    required this.createAt,
    required this.chatingWith,
    required this.userId,
    required this.status,
  });
  factory UserModel.fromMap(DocumentSnapshot<Object?> map) {
    return UserModel(
        userId: map["userId"],
        userName: map['userName'],
        userPassword: map['userPassword'],
        userImage: map['userImage'],
        userEmail: map['userEmail'],
        chatingWith: map["chatingWith"],
        status: map["status"],
        createAt: map["createAt"]);
  }
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'userPassword': userPassword,
      'userImage': userImage,
      'userEmail': userEmail,
      'chatingWith': chatingWith,
      'createAt': createAt,
      "status": status,
    };
  }
}
