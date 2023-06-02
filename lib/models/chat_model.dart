import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String name;
  final String message;
  final String type;
  final String id;
  final String time;
  final String uid;

  ChatModel({
    required this.uid,
    required this.name,
    required this.type,
    required this.message,
    required this.id,
    required this.time,
  });

  factory ChatModel.fromMap(DocumentSnapshot<Object?> map) {
    return ChatModel(
      name: map["name"],
      id: map['id'],
      message: map['message'],
      type: map['type'],
      time: map['time'],
      uid: map["userId"],
    );
  }
  
}
