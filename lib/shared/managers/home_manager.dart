import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/shared/models/section.dart';

class HomeManager extends ChangeNotifier {
  HomeManager() {
    _loadSections();
  }

  List<Section> sections = [];

  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  Future<void> _loadSections() async {
    firestore.collection('home').snapshots().listen(
      (snaps) {
        sections.clear();
        for (final doc in snaps.docs) {
          sections.add(Section.fromDocument(doc));
        }
        notifyListeners();
      },
    );
  }
}
