import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loja_virtual/shared/managers/user_manager.dart';
import 'package:loja_virtual/shared/models/address.dart';
import 'package:loja_virtual/shared/models/cart_product.dart';
import 'package:loja_virtual/shared/models/product.dart';
import 'package:loja_virtual/shared/models/user.dart';
import 'package:loja_virtual/shared/services/cep_aberto_service.dart';

class CartManager extends ChangeNotifier {
  List<CartProduct> items = [];

  UserModel user;
  Address address;

  num productsPrice = 0.0;
  num deliveryPrice;

  num get totalPrice => productsPrice + (deliveryPrice ?? 0);

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  bool get isCartValid {
    if (items.isEmpty) return false;
    for (final cartProduct in items) {
      if (!cartProduct.hasStock) return false;
    }

    return true;
  }

  bool get isAddressValid => address != null && deliveryPrice != null;

  final firestore = FirebaseFirestore.instance;

  void updateUser(UserManager value) {
    user = value.user;
    productsPrice = 0.0;
    items.clear();
    removeAddress();

    if (user != null) {
      _loadCartItems();
      _loadUserAddress();
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

  Future<void> _loadUserAddress() async {
    if (user.address != null &&
        await calculateDelivery(user.address.lat, user.address.long)) {
      address = user.address;
      notifyListeners();
    }
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

  Future<void> getAddress(String cep) async {
    isLoading = true;
    final cepAbertoService = CepAbertoService();

    try {
      final cepAbertoAddress = await cepAbertoService.getAddressFromCep(cep);

      if (cepAbertoAddress != null) {
        address = Address(
            street: cepAbertoAddress.logradouro,
            district: cepAbertoAddress.bairro,
            zipCode: cepAbertoAddress.cep,
            city: cepAbertoAddress.cidade.nome,
            state: cepAbertoAddress.estado.sigla,
            lat: cepAbertoAddress.latitude,
            long: cepAbertoAddress.longitude);
      }
      isLoading = false;
    } catch (e) {
      isLoading = false;
      return Future.error('CEP Inválido');
    }
  }

  Future<void> setAddress(Address address) async {
    isLoading = true;
    this.address = address;

    if (await calculateDelivery(address.lat, address.long)) {
      user.setAddress(address);
      isLoading = false;
    } else {
      isLoading = false;
      return Future.error('Endereço fora do raio de entrega :(');
    }
  }

  void removeAddress() {
    address = null;
    deliveryPrice = null;
    notifyListeners();
  }

  Future<bool> calculateDelivery(double lat, double long) async {
    final doc = await firestore.doc('aux/delivery').get();

    final data = doc.data();

    final latStore = data['lat'] as double;
    final longStore = data['long'] as double;
    final basePrice = doc['base'] as num;
    final km = doc['km'] as num;
    final maxKm = data['maxkm'] as num;

    double distance =
        Geolocator.distanceBetween(latStore, longStore, lat, long);

    distance /= 1000.0;

    if (distance > maxKm) {
      return false;
    }

    deliveryPrice = basePrice + distance * km;

    return true;
  }
}
