import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUp(String email, String password) async {
    try {
      final creds = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return creds.user;
    } catch (e) {
      print('Signup error: $e');
      return null;
    }
  }

  Future<User?> signIn(String email, String password) async {
    try {
      final creds = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return creds.user;
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  void signOut() => _auth.signOut();

  User? get currentUser => _auth.currentUser;
}
