import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/shared/managers/cart_manager.dart';

import 'address.dart';
import 'cart_product.dart';

class Order {
  Order.fromCartManager(CartManager cartManager) {
    items = List.from(cartManager.items);
    price = cartManager.totalPrice;
    userId = cartManager.user.id;
    address = cartManager.address;
  }

  Order.fromDocument(DocumentSnapshot doc) {
    orderId = doc.id;

    final data = doc.data();

    items = (data['items'] as List<dynamic>)
        .map<CartProduct>((e) => CartProduct.fromMap(e as Map<String, dynamic>))
        .toList();

    price = data['price'] as num;
    userId = data['user'] as String;
    address = Address.fromMap(data['address'] as Map<String, dynamic>);
    date = data['date'] as Timestamp;
  }

  final firestore = FirebaseFirestore.instance;

  String get formattedId => '#${orderId.padLeft(6, '0')}';

  String orderId;

  List<CartProduct> items;
  num price;

  String userId;

  Address address;

  Timestamp date;

  Future<void> save() async {
    firestore.collection('orders').doc(orderId).set({
      'items': items.map((e) => e.toOrderItemMap()).toList(),
      'price': price,
      'user': userId,
      'address': address.toMap(),
    });
  }

  @override
  String toString() {
    return 'Order{orderId: $orderId, items: $items, price: $price, userId: $userId, address: $address, date: $date}';
  }
}
