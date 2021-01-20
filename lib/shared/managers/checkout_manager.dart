import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/shared/models/order.dart';
import 'package:loja_virtual/shared/models/product.dart';

import 'cart_manager.dart';

class CheckoutManager extends ChangeNotifier {
  CartManager cartManager;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  final firestore = FirebaseFirestore.instance;

  // ignore: use_setters_to_change_properties
  void updateCart(CartManager cartManager) {
    this.cartManager = cartManager;
  }

  Future<void> checkout(
      {Function(String error) onStockFail, Function onSuccess}) async {
    loading = true;
    try {
      await _decrementStock();
    } catch (e) {
      onStockFail(e.toString());
      loading = false;
      return;
    }

    final orderId = await _getOrderId();

    final order = Order.fromCartManager(cartManager);
    order.orderId = orderId.toString();
    await order.save();

    cartManager.clear();

    onSuccess();
    loading = false;
  }

  Future<int> _getOrderId() async {
    final ref = firestore.doc('aux/ordercounter');

    try {
      final result = await firestore.runTransaction((transac) async {
        final doc = await transac.get(ref);
        final orderId = doc.data()['current'] as int;
        transac.update(ref, {'current': orderId + 1});

        return {'orderId': orderId};
      });
      return result['orderId'];
    } catch (e) {
      debugPrint(e.toString());
      return Future.error('Falha ao gerar número do pedido');
    }
  }

  Future<void> _decrementStock() async {
    firestore.runTransaction((transac) async {
      final productsToUpdate = <Product>[];
      final productWithoutStock = <Product>[];

      for (final cartProduct in cartManager.items) {
        Product product;

        if (productsToUpdate.any((p) => p.id == cartProduct.productId)) {
          product =
              productsToUpdate.firstWhere((p) => p.id == cartProduct.productId);
        } else {
          final doc = await transac.get(
            firestore.doc('products/${cartProduct.productId}'),
          );

          product = Product.fromDocument(doc);
        }

        cartProduct.product = product;

        final size = product.findSize(cartProduct.size);

        if (size.stock - cartProduct.quantity < 0) {
          productWithoutStock.add(product);
        } else {
          size.stock -= cartProduct.quantity;
          productsToUpdate.add(product);
        }
      }

      if (productWithoutStock.isNotEmpty) {
        Future.error('${productWithoutStock.length} produto(s) sem estoque!');
      }

      for (final product in productsToUpdate) {
        transac.update(
          firestore.doc('products/${product.id}'),
          {'sizes': product.exportSizeList()},
        );
      }
    });
  }
}
