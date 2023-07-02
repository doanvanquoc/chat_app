import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  //singleton
  static final _service = AuthService._internal();

  factory AuthService() => _service;

  AuthService._internal();
  //instance
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  //sign user in
  Future<UserCredential> signInWithEmailAndPassword(
      String email, password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    }
    // catch error
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //register user
  Future<UserCredential> createUserWithEmailAndPassword(
      String email, password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    }
    //catch error
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //save user data
  Future saveUserData(String email) async {
    try {
      String uid = _auth.currentUser!.uid;
      await _firestore.collection('user').doc(uid).set(
        {
          'email': email,
          'uid': uid,
        },
      );
    }
    //catch error
    catch (e) {
      throw Exception(e);
    }
  }

  //Get current user
  User? getCurrentUser() {
    final user = _auth.currentUser;
    return user;
  }
}

final authService = AuthService();
