import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  //! Instance of auth & firestore --
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //! get current user --
  User? getCurrentUser(){
    return _auth.currentUser;
  }

  //! Signin --
  Future<UserCredential> signInWithEmailPassword(
      String email, password) async {
    try {
      // signin user ..
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // save user info if it dosenot already exist  ..
      _firestore.collection("Users").doc(userCredential.user!.uid).set(
        {
          'uid': userCredential.user!.uid,
          'email': email,
        }
      );     
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //! Signup --
  Future<UserCredential> signUpWithEmailPassword(
      String email, password) async {
    try {
      // create user  ..
      UserCredential userCredential = 
          await _auth.createUserWithEmailAndPassword(
            email: email, 
            password: password
            );
      // save user info in a seprate doc ..
      _firestore.collection("Users").doc(userCredential.user!.uid).set(
        {
          'uid': userCredential.user!.uid,
          'email': email,
        }
      );         

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //! Signout --
  Future<void> signOut() async {
    return await _auth.signOut();
  }
  //! error --
}
