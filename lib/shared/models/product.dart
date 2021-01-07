import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/shared/models/item_size.dart';
import 'package:uuid/uuid.dart';

class Product extends ChangeNotifier {
  Product({this.id, this.name, this.description, this.images, this.sizes}) {
    images = images ?? [];
    sizes = sizes ?? [];
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

  final storage = FirebaseStorage.instance;
  final firestore = FirebaseFirestore.instance;

  DocumentReference get firestoreRef => firestore.doc('products/$id');
  StorageReference get storageRef => storage.ref().child('products').child(id);

  String id;
  String name;
  String description;
  List<String> images;
  List<ItemSize> sizes;

  List<dynamic> newImages;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

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

  bool get hasStock => totalStock > 0;

  num get basePrice {
    num lowest = double.infinity;

    for (final size in sizes) {
      if (size.price < lowest && size.hasStock) lowest = size.price;
    }
    return lowest;
  }

  ItemSize findSize(String size) =>
      sizes.firstWhere((s) => s.name == size, orElse: () => null);

  List<Map<String, dynamic>> exportSizeList() =>
      sizes.map((size) => size.toMap()).toList();

  Future<void> save() async {
    loading = true;
    final Map<String, dynamic> data = {
      'name': name,
      'description': description,
      'sizes': exportSizeList(),
    };

    if (id == null) {
      final doc = await firestore.collection('products').add(data);
      id = doc.id;
    } else {
      await firestoreRef.update(data);
    }

    final updateImages = <String>[];

    for (final newImage in newImages) {
      if (images.contains(newImage)) {
        updateImages.add(newImage as String);
      } else {
        final task = storageRef.child(Uuid().v1()).putFile(newImage as File);
        final snapshot = await task.onComplete;
        final url = await snapshot.ref.getDownloadURL() as String;
        updateImages.add(url);
      }
    }

    for (final image in images) {
      if (!newImages.contains(image)) {
        try {
          final ref = await storage.getReferenceFromUrl(image);
          await ref.delete();
        } catch (e) {
          debugPrint('Falha ao deletar $image');
        }
      }
    }

    await firestoreRef.update({'images': updateImages});

    images = updateImages;
    loading = false;
  }

  Product clone() {
    return Product(
      id: id,
      name: name,
      description: description,
      images: List.from(images),
      sizes: sizes.map((size) => size.clone()).toList(),
    );
  }
}
