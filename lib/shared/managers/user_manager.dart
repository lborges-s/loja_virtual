import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/shared/helpers/firebase_errors.dart';
import 'package:loja_virtual/shared/models/user.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class UserManager extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  UserManager() {
    _loadCurrentUser();
  }

  UserModel user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool _loadingFace = false;
  bool get isLoadingFace => _loadingFace;
  set isLoadingFace(bool value) {
    _loadingFace = value;
    notifyListeners();
  }

  bool get isLoggedIn => user != null;

  bool get adminEnabled => user != null && user.isAdmin;

  Future<void> signIn(
      {UserModel user, Function(String) onFail, Function onSuccess}) async {
    isLoading = true;

    try {
      final UserCredential result = await auth.signInWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );

      _loadCurrentUser(firebaseUser: result.user);

      onSuccess();
    } on FirebaseAuthException catch (e) {
      onFail(getErrorString(e.code));
    }
    isLoading = false;
  }

  Future<void> facebookLogin(
      {Function(String) onFail, Function onSuccess}) async {
    isLoadingFace = true;

    final result = await FacebookLogin().logIn(['email', 'public_profile']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final credential =
            FacebookAuthProvider.credential(result.accessToken.token);

        final authResult = await auth.signInWithCredential(credential);

        if (authResult.user != null) {
          final firebaseUser = authResult.user;

          user = UserModel(
            id: firebaseUser.uid,
            name: firebaseUser.displayName,
            email: firebaseUser.email,
          );

          await user.saveData();

          onSuccess();
        }
        break;
      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        onFail(result.errorMessage);
        break;
    }

    isLoadingFace = false;
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
