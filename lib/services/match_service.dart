import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinter/models/models.dart';
import 'package:dinter/services/services.dart';

class MatchService {
  CollectionReference matchRef =
      FirebaseFirestore.instance.collection('matches');

  UserService userService = UserService();

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

  Future<List<MatchModel>> getUserLikes() async {
    List<MatchModel> userLikes = [];
    User currentUser =
        await userService.getUserById(AuthService().currentUser!.uid);

    final QuerySnapshot querySnapshot = await matchRef
        .where("secondUser", isEqualTo: currentUser.toJson())
        .where("isMatch", isEqualTo: false)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      userLikes = querySnapshot.docs
          .map((doc) => MatchModel.fromFirestore(doc))
          .toList();
    }

    return userLikes;
  }

  Stream<List<MatchModel>> getMatchedListStream() {
    return matchRef.where('isMatch', isEqualTo: true).snapshots().map(
        (querySnapshot) => querySnapshot.docs
            .map((doc) => MatchModel.fromFirestore(doc))
            .where((match) =>
                match.user!.id == AuthService().currentUser!.uid ||
                match.secondUser!.id == AuthService().currentUser!.uid)
            .toList());
  }

  Stream<List<Message>> getMessagesStream(String matchId) {
    return matchRef.doc(matchId).snapshots().map((documentSnapshot) {
      MatchModel match = MatchModel.fromFirestore(documentSnapshot);
      return match.chat!.messages;
    });
  }

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
