import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  User? currentUser = _auth.currentUser;
  // Sign in
  Future signInWithEmailAndPassword(
      {required String email, required String password}) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future createUserWithEmailAndPassword(
      {required String email, required String password}) async {
    await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future signOut() async {
    await _auth.signOut();
  }
}
