import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/shared/managers/user_manager.dart';
import 'package:loja_virtual/shared/models/user.dart';

class AdminUsersManager extends ChangeNotifier {
  List<UserModel> users = [];

  final firestore = FirebaseFirestore.instance;

  void updateUser(UserManager userManager) {
    if (userManager.adminEnabled) {
      _listenToUsers();
    } else {
      users.clear();
      _listenToUsers();
    }
  }

  void _listenToUsers() {
    firestore.collection('users').get().then((snap) {
      users = snap.docs.map((d) => UserModel.fromDocument(d)).toList();
      users
          .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      notifyListeners();
    });
  }

  List<String> get names => users.map((e) => e.name).toList();
}
