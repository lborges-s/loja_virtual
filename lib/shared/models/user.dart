import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/shared/models/address.dart';

class UserModel {
  String id;
  String email;
  String password;
  String name;

  bool isAdmin = false;
  String confirmPassword;

  Address address;

  UserModel({this.email, this.password, this.name, this.id});

  UserModel.fromDocument(DocumentSnapshot document) {
    final data = document.data();
    id = document.id;
    name = data['name'] as String;
    email = data['email'] as String;
    if (data.containsKey('address')) {
      address = Address.fromMap(data['address'] as Map<String, dynamic>);
    }
  }

  DocumentReference get firestoreRef =>
      FirebaseFirestore.instance.doc('users/$id');

  CollectionReference get cartReference => firestoreRef.collection('cart');

  Future<void> saveData() async {
    await firestoreRef.set(toMap());
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'email': email,
        if (address != null) 'address': address.toMap(),
      };

  void setAddress(Address address) {
    this.address = address;

    saveData();
  }
}
