import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/shared/models/section_item.dart';
import 'package:uuid/uuid.dart';

class Section extends ChangeNotifier {
  Section({this.id, this.name, this.type, this.items}) {
    items = items ?? [];
    originalItems = List.from(items);
  }

  Section.fromDocument(DocumentSnapshot document) {
    final data = document.data();
    id = document.id;
    name = data['name'] as String;
    type = data['type'] as String;
    items = (data['items'] as List)
        .map<SectionItem>(
          (map) => SectionItem.fromMap(map as Map<String, dynamic>),
        )
        .toList();
  }

  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

  DocumentReference get firestoreRef => firestore.doc('home/$id');
  StorageReference get storageRef => storage.ref().child('home/$id');

  String id;
  String name;
  String type;
  List<SectionItem> items;
  List<SectionItem> originalItems;

  String _error;
  String get error => _error;
  set error(String value) {
    _error = value;
    notifyListeners();
  }

  bool isValid() {
    if (name == null || name.isEmpty) {
      error = 'Título inválido';
    } else if (items.isEmpty) {
      error = 'Insira ao menos uma imagem';
    } else {
      error = null;
    }
    return error == null;
  }

  void addItem(SectionItem item) {
    items.add(item);
    notifyListeners();
  }

  void removeItem(SectionItem item) {
    items.remove(item);
    notifyListeners();
  }

  Future<void> save(int pos) async {
    final Map<String, dynamic> data = {
      'name': name,
      'type': type,
      'pos': pos,
    };

    if (id == null) {
      final doc = await firestore.collection('home').add(data);
      id = doc.id;
    } else {
      await firestoreRef.update(data);
    }

    for (final item in items) {
      if (item.image is File) {
        final task = storageRef.child(Uuid().v1()).putFile(item.image as File);
        final snapshot = await task.onComplete;
        final url = await snapshot.ref.getDownloadURL();
        item.image = url;
      }
    }

    for (final original in originalItems) {
      if (!items.contains(original) &&
          (original.image as String).contains('firebase')) {
        try {
          final ref =
              await storage.getReferenceFromUrl(original.image as String);
          await ref.delete();
          // ignore: empty_catches
        } catch (e) {}
      }
    }

    final Map<String, dynamic> itemsData = {
      'items': items.map((e) => e.toMap()).toList()
    };

    await firestoreRef.update(itemsData);
  }

  Future<void> delete() async {
    await firestoreRef.delete();
    for (final item in items) {
      if ((item.image as String).contains('firebase')) {
        try {
          final ref = await storage.getReferenceFromUrl(item.image as String);
          await ref.delete();
          // ignore: empty_catches
        } catch (e) {}
      }
    }
  }

  Section clone() {
    return Section(
      id: id,
      name: name,
      type: type,
      items: items.map((e) => e.clone()).toList(),
    );
  }

  @override
  String toString() {
    return 'Section:{name: $name, type: $type, items: $items}';
  }
}
