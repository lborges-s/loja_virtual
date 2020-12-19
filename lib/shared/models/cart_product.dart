import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/shared/models/item_size.dart';
import 'package:loja_virtual/shared/models/product.dart';

class CartProduct extends ChangeNotifier {
  CartProduct.fromProduct(this.product) {
    productId = product.id;
    quantity = 1;
    size = product.selectedSize.name;
  }

  CartProduct.fromDocument(DocumentSnapshot document) {
    final data = document.data();
    id = document.id;
    productId = data['pid'] as String;
    quantity = data['quantity'] as int;
    size = data['size'] as String;

    firestore.doc('products/$productId').get().then(
      (doc) {
        product = Product.fromDocument(doc);
        notifyListeners();
      },
    );
  }

  final firestore = FirebaseFirestore.instance;
  String id;

  String productId;
  int quantity;
  String size;

  Product product;

  ItemSize get itemSize => product?.findSize(size);

  bool get hasStock {
    final size = itemSize;
    if (size == null) return false;

    return size.stock >= quantity;
  }

  num get unitPrice {
    if (product == null) return 0;
    return itemSize?.price ?? 0;
  }

  num get totalPrice => unitPrice * quantity;

  Map<String, dynamic> toMap() => {
        'pid': productId,
        'quantity': quantity,
        'size': size,
      };

  bool stackable(Product product) {
    return product.id == productId && product.selectedSize.name == size;
  }

  void increment() {
    quantity++;

    notifyListeners();
  }

  void decrement() {
    quantity--;

    notifyListeners();
  }
}
