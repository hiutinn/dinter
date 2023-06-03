import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinter/models/models.dart';

class MatchModel {
  late String id;
  late User? user;
  late User? secondUser;
  late Chat? chat;
  bool isMatch = false;

  MatchModel(this.id, this.user, this.secondUser, this.chat, this.isMatch);

  factory MatchModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MatchModel(
        doc.id,
        User.fromMap(data['user']),
        User.fromMap(data['secondUser']),
        Chat.fromMap(data['chat']),
        data['isMatch']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user!.toJson(),
      'secondUser': secondUser!.toJson(),
      'chat': chat!.toJson(),
      'isMatch': isMatch
    };
  }
}
