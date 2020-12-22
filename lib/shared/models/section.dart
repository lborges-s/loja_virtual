import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/shared/models/section_item.dart';

class Section {
  Section.fromDocument(DocumentSnapshot document) {
    final data = document.data();
    name = data['name'] as String;
    type = data['type'] as String;
    items = (data['items'] as List)
        .map<SectionItem>(
          (map) => SectionItem.fromMap(map as Map<String, dynamic>),
        )
        .toList();
  }

  String name;
  String type;
  List<SectionItem> items;

  @override
  String toString() {
    return 'Section:{name: $name, type: $type, items: $items}';
  }
}
