import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/shared/helpers/firebase_errors.dart';
import 'package:loja_virtual/shared/models/user.dart';

class UserManager extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  UserManager() {
    _loadCurrentUser();
  }

  UserModel user;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  bool get isLoggedIn => user != null;

  bool get adminEnabled => user != null && user.isAdmin;

  Future<void> signIn(
      {UserModel user, Function(String) onFail, Function onSuccess}) async {
    isLoading = true;

    try {
      final UserCredential result = await auth.signInWithEmailAndPassword(
          email: user.email, password: user.password);

      _loadCurrentUser(firebaseUser: result.user);

      onSuccess();
    } on FirebaseAuthException catch (e) {
      onFail(getErrorString(e.code));
    }
    isLoading = false;
  }

  Future<void> signUp(
      {UserModel user, Function(String) onFail, Function onSuccess}) async {
    isLoading = true;

    try {
      final result = await auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );

      user.id = result.user.uid;
      this.user = user;

      await user.saveData();

      onSuccess();
    } on FirebaseAuthException catch (e) {
      onFail(getErrorString(e.code));
    }
    isLoading = false;
  }

  void signOut() {
    auth.signOut();
    user = null;
    notifyListeners();
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> _loadCurrentUser({User firebaseUser}) async {
    final currentUser = firebaseUser ?? auth.currentUser;
    if (currentUser != null) {
      final docUser =
          await firestore.collection('users').doc(currentUser.uid).get();
      user = UserModel.fromDocument(docUser);
      final docAdmin = await firestore.collection('admins').doc(user.id).get();
      if (docAdmin.exists) {
        user.isAdmin = true;
      }
      notifyListeners();
    }
  }
}
