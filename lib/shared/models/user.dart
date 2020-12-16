import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String email;
  String password;
  String name;

  String confirmPassword;

  UserModel({this.email, this.password, this.name, this.id});

  UserModel.fromDocument(DocumentSnapshot document) {
    final data = document.data();
    id = document.id;
    name = data['name'] as String;
    email = data['email'] as String;
  }

  DocumentReference get firestoreRef =>
      FirebaseFirestore.instance.doc('users/$id');

  Future<void> saveData() async {
    await firestoreRef.set(toMap());
  }

  Map<String, String> toMap() => {
        'name': name,
        'email': email,
      };
}
