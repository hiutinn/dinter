import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinter/models/user_model.dart';
import 'package:dinter/services/auth_service.dart';

class UserService {
  CollectionReference userRef = FirebaseFirestore.instance.collection('users');
  Future createUser(User user) async {
    await userRef.doc(user.id).set(user.toJson());
  }

  Future<List<User>?> getUserList() async {
    List<User>? userList = [];
    final QuerySnapshot querySnapshot = await userRef
        .where('id', isNotEqualTo: AuthService().currentUser!.uid)
        .get();
    if (querySnapshot.size == 0) {
      userList = null;
    } else {
      userList =
          querySnapshot.docs.map((doc) => User.fromFirestore(doc)).toList();
    }

    return userList;
  }

  Future<User> getUserById(String id) async {
    final DocumentSnapshot documentSnapshot = await userRef.doc(id).get();
    if (documentSnapshot.exists) {
      User user = User.fromFirestore(documentSnapshot);

      return user;
    } else {
      throw Exception("User not found");
    }
  }
}
