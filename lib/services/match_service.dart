import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinter/models/models.dart';
import 'package:dinter/services/services.dart';

class MatchService {
  CollectionReference matchRef =
      FirebaseFirestore.instance.collection('matches');

  UserService userService = UserService();

  // Like use khác (tim)
  Future like(User user) async {
    final QuerySnapshot querySnapshot = await matchRef.get();
    bool check = true;
    List<MatchModel> matches =
        querySnapshot.docs.map((doc) => MatchModel.fromFirestore(doc)).toList();
    for (MatchModel match in matches) {
      if (match.user!.id == user.id &&
          match.secondUser!.id == AuthService().currentUser!.uid &&
          !match.isMatch) {
        match.isMatch = true;
        matchRef.doc(match.id).set(match.toJson());
        check = false;
        break;
      }

      if (match.user!.id == AuthService().currentUser!.uid &&
          match.secondUser!.id == user.id) {
        check = false;
        break;
      }

      if (match.user!.id == user.id &&
          match.secondUser!.id == AuthService().currentUser!.uid) {
        check = false;
        break;
      }
    }
    if (check) {
      String newMatchId = matchRef.doc().id;
      User currentUser =
          await userService.getUserById(AuthService().currentUser!.uid);
      MatchModel newMatch = MatchModel(newMatchId, currentUser, user,
          Chat(newMatchId, List<Message>.empty()), false);
      await matchRef.doc(newMatchId).set(newMatch.toJson());
    }
  }

  Future<void> unmatch(User user) async {
    final QuerySnapshot querySnapshot = await matchRef.get();
    List<MatchModel> matches =
        querySnapshot.docs.map((doc) => MatchModel.fromFirestore(doc)).toList();

    for (MatchModel match in matches) {
      if ((match.user!.id == user.id &&
              match.secondUser!.id == AuthService().currentUser!.uid) ||
          (match.secondUser!.id == user.id &&
              match.user!.id == AuthService().currentUser!.uid)) {
        await matchRef.doc(match.id).delete();
        break;
      }
    }
  }

  // Lấy danh sách các user đã like mình
  Stream<List<MatchModel>> getUserLikesStream() {
    StreamController<List<MatchModel>> controller =
        StreamController<List<MatchModel>>();

    userService
        .getUserById(AuthService().currentUser!.uid)
        .then((currentUser) async {
      final QuerySnapshot querySnapshot = await matchRef
          .where("secondUser", isEqualTo: currentUser.toJson())
          .where("isMatch", isEqualTo: false)
          .get();

      List<MatchModel> userLikes = [];
      if (querySnapshot.docs.isNotEmpty) {
        userLikes = querySnapshot.docs
            .map((doc) => MatchModel.fromFirestore(doc))
            .toList();
      }

      controller.add(userLikes);
    }).catchError((error) {
      controller.addError(error);
    });

    return controller.stream;
  }

  // Lấy danh sách đã match
  Stream<List<MatchModel>> getMatchedListStream() {
    return matchRef.where('isMatch', isEqualTo: true).snapshots().map(
        (querySnapshot) => querySnapshot.docs
            .map((doc) => MatchModel.fromFirestore(doc))
            .where((match) =>
                match.user!.id == AuthService().currentUser!.uid ||
                match.secondUser!.id == AuthService().currentUser!.uid)
            .toList());
  }

  // Check matched
  Future<bool> isMatched(String userId) async {
    List<MatchModel> matches = [];
    QuerySnapshot querySnapshot_1 =
        await matchRef.where("isMatch", isEqualTo: true).get();
    matches = querySnapshot_1.docs
        .map((doc) => MatchModel.fromFirestore(doc))
        .where((match) =>
            (match.user!.id == AuthService().currentUser!.uid ||
                match.secondUser!.id == AuthService().currentUser!.uid) &&
            (match.user!.id == userId || match.secondUser!.id == userId))
        .toList();
    print(matches.isNotEmpty && userId != AuthService().currentUser!.uid);
    return matches.isNotEmpty && userId != AuthService().currentUser!.uid;
  }

  // Lấy danh sách tin nhắn
  Stream<List<Message>> getMessagesStream(String matchId) {
    return matchRef.doc(matchId).snapshots().map((documentSnapshot) {
      MatchModel match = MatchModel.fromFirestore(documentSnapshot);
      return match.chat!.messages;
    });
  }

  // Gửi tin nhắn
  Future sendMessage(
      MatchModel match, String receiverId, String content) async {
    Message newMessage = Message(DateTime.now().toString(),
        AuthService().currentUser!.uid, receiverId, content, Timestamp.now());
    match.chat!.messages.add(newMessage);
    matchRef.doc(match.id).update({
      'chat.messages': FieldValue.arrayUnion([newMessage.toJson()]),
    });
  }
}
