import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinter/models/models.dart';

class Chat {
  final String id;
  final List<Message> messages;

  Chat(this.id, this.messages);

  factory Chat.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Chat(doc.id, data['messages']);
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    List<dynamic> tempList = map['messages'];
    List<Message> messages = tempList
        .map((item) => Message(item['id'], item['senderId'], item['receiverId'],
            item['message'], item['dateTime']))
        .toList();
    return Chat(map['id'], messages);
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> mapMessageList = [];
    for (Message message in messages) {
      mapMessageList.add(message.toJson());
    }
    return {
      'id': id,
      'messages': mapMessageList,
    };
  }
}
