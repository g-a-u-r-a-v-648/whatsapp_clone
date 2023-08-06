import 'dart:io';

class ChatModel {
  String? user;
  String? message;
  dynamic timestamp;
  File? image;

  ChatModel(
      {required this.message,
      required this.user,
      required this.timestamp,
      required this.image});

  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'message': message,
      'timestamp': timestamp,
      'file': image,
    };
  }

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      user: json['user'],
      message: json['message'],
      timestamp: json['timestamp'],
      image: json['file'],
    );
  }
}
