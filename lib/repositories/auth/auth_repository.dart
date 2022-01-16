import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:groupstudy/exceptions/exceptions.dart';
import 'package:groupstudy/models/user.dart';

class AuthRepository {
  late FirebaseAuth firebaseAuth;

  AuthRepository({required this.firebaseAuth});

  // Future<UserCredential> signInWithGoogle() async {
  //   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //   final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth?.accessToken,
  //     idToken: googleAuth?.idToken
  //   );
  //   return await FirebaseAuth.instance.signInWithCredential(credential);
  // }

  Future<User?> createUser(String email, String password) async {
    try {
      var result = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user!;
      return user;
    } on FirebaseAuthException catch(e) {
      debugPrint("ERROR: " + e.toString());
      if(e.code == "email-already-in-use") {
        throw UserAuthException(cause: "Email is already in use.");
      } else if(e.code == "weak-password") {
        throw UserAuthException(cause: "Password is too weak.");
      }
    } on Exception catch(e) {
      debugPrint("ERROR: " + e.toString());
      throw UserAuthException(cause: "Error creating user.");
    }
  }

  Future<User?> signIn(String email, String password) async {
    try {
      var result = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user!;
      return user;
    } on Exception catch(e) {
      throw UserAuthException(cause: "Failed signing in.");
    }
  }

  bool isAuthenticatedWithFirebase() {
    var currentUser = firebaseAuth.currentUser;
    return currentUser != null;
  }

  User? getFirebaseUser() {
    return firebaseAuth.currentUser;
  }

  Future<AppUser> getAppUser() async {
    QuerySnapshot userQuery = await FirebaseFirestore.instance.collection("users").where('uid', isEqualTo: firebaseAuth.currentUser!.uid).get();
    return AppUser.fromJson(userQuery.docs[0].data() as Map<String, dynamic>);
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }
}