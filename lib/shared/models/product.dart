import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/shared/models/item_size.dart';

class Product extends ChangeNotifier {
  String id;
  String name;
  String description;
  List<String> images;
  List<ItemSize> sizes;

  ItemSize _selectedSize;

  ItemSize get selectedSize => _selectedSize;
  set selectedSize(ItemSize size) {
    _selectedSize = size;
    notifyListeners();
  }

  int get totalStock {
    int stock = 0;
    for (final size in sizes) {
      stock += size.stock;
    }
    return stock;
  }

  bool get hasStock {
    return totalStock > 0;
  }

  Product.fromDocument(DocumentSnapshot document) {
    final data = document.data();
    id = document.id;
    name = document['name'] as String;
    description = document['description'] as String;
    images = List<String>.from(data['images'] as List<dynamic>);
    sizes = (data['sizes'] as List<dynamic> ?? [])
        .map((s) => ItemSize.fromMap(s as Map<String, dynamic>))
        .toList();
  }
}