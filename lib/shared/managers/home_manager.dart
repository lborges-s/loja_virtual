import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/shared/models/section.dart';

class HomeManager extends ChangeNotifier {
  HomeManager() {
    _loadSections();
  }
  bool isEditing = false;
  bool isLoading = false;

  final List<Section> _sections = [];

  List<Section> _editingSections = [];

  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  List<Section> get sections {
    if (isEditing) {
      return _editingSections;
    } else {
      return _sections;
    }
  }

  Future<void> _loadSections() async {
    firestore.collection('home').orderBy('pos').snapshots().listen(
      (snaps) {
        _sections.clear();
        for (final doc in snaps.docs) {
          _sections.add(Section.fromDocument(doc));
        }
        notifyListeners();
      },
    );
  }

  void addSection(Section section) {
    _editingSections.add(section);
    notifyListeners();
  }

  void removeSection(Section section) {
    _editingSections.remove(section);
    notifyListeners();
  }

  void enterEditing() {
    isEditing = true;
    _editingSections = _sections.map((s) => s.clone()).toList();
    notifyListeners();
  }

  Future<void> saveEditing() async {
    bool valid = true;
    for (final section in _editingSections) {
      if (!section.isValid()) valid = false;
    }
    if (!valid) return;

    isLoading = true;
    notifyListeners();

    int pos = 0;
    for (final section in _editingSections) {
      await section.save(pos);
      pos++;
    }

    for (final section in List.from(_sections)) {
      if (!_editingSections.any((element) => element.id == section.id)) {
        await section.delete();
      }
    }

    isLoading = false;
    isEditing = false;
    notifyListeners();
  }

  void discardEditing() {
    isEditing = false;
    notifyListeners();
  }
}
