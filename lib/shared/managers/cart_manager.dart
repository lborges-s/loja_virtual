import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/shared/managers/user_manager.dart';
import 'package:loja_virtual/shared/models/cart_product.dart';
import 'package:loja_virtual/shared/models/product.dart';
import 'package:loja_virtual/shared/models/user.dart';

class CartManager extends ChangeNotifier {
  List<CartProduct> items = [];

  UserModel user;

  num productsPrice = 0;

  void updateUser(UserManager value) {
    user = value.user;
    items.clear();

    if (user != null) {
      _loadCartItems();
    }
  }

  Future<void> _loadCartItems() async {
    final cartSnap = await user.cartReference.get();

    items = cartSnap.docs
        .map(
          (d) => CartProduct.fromDocument(d)..addListener(_onItemUpdated),
        )
        .toList();
  }

  void addToCart(Product product) {
    try {
      final e = items.firstWhere((p) => p.stackable(product));
      e.increment();
    } catch (e) {
      final cartProduct = CartProduct.fromProduct(product);
      cartProduct.addListener(_onItemUpdated);

      items.add(cartProduct);

      user.cartReference
          .add(cartProduct.toMap())
          .then((doc) => cartProduct.id = doc.id);

      _onItemUpdated();
    }
  }

  void removeOfCart(CartProduct cartProduct) {
    items.removeWhere((p) => p.id == cartProduct.id);
    user.cartReference.doc(cartProduct.id).delete();
    cartProduct.removeListener(_onItemUpdated);

    notifyListeners();
  }

  void _onItemUpdated() {
    productsPrice = 0.0;
    for (int i = 0; i < items.length; i++) {
      final cartProduct = items[i];
      if (cartProduct.quantity == 0) {
        removeOfCart(cartProduct);
        i--;
        continue;
      }

      productsPrice += cartProduct.totalPrice;
      _updateCartProduct(cartProduct);
    }
    notifyListeners();
  }

  void _updateCartProduct(CartProduct cartProduct) {
    if (cartProduct.id != null) {
      user.cartReference.doc(cartProduct.id).update(cartProduct.toMap());
    }
  }

  bool get isCartValid {
    //!items.any((cartProduct) => !(cartProduct.hasStock));
    if (items.isEmpty) return false;
    for (final cartProduct in items) {
      if (!cartProduct.hasStock) return false;
    }

    return true;
  }
}
