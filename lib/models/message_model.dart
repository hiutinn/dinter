import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String senderId;
  final String receiverId;
  final String message;
  final Timestamp dateTime;

  Message(this.id, this.senderId, this.receiverId, this.message, this.dateTime);

  factory Message.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Message(doc.id, data['senderId'] ?? '', data['receiverId'] ?? '',
        data['message'] ?? '', data['dateTime']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'dateTime': dateTime
    };
  }
}
