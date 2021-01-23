import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/shared/models/product.dart';

class ProductManager extends ChangeNotifier {
  ProductManager() {
    _loadAllProducts();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Product> _allProducts = [];

  List<Product> get allProducts => _allProducts;

  String _search = '';
  String get search => _search;

  set search(String search) {
    _search = search;
    notifyListeners();
  }

  List<Product> get filteredProducts {
    final List<Product> filteredProducts = [];

    if (search.isEmpty) {
      filteredProducts.addAll(allProducts);
    } else {
      filteredProducts.addAll(
        allProducts.where(
          (p) => p.name.toLowerCase().contains(search.toLowerCase()),
        ),
      );
    }

    return filteredProducts;
  }

  Future<void> _loadAllProducts() async {
    final snapProducts = await firestore
        .collection('products')
        .where('deleted', isEqualTo: false)
        .get();

    _allProducts =
        snapProducts.docs.map((e) => Product.fromDocument(e)).toList();

    notifyListeners();
  }

  Product findProductById(String id) =>
      allProducts.firstWhere((p) => p.id == id, orElse: () => null);

  void update(Product product) {
    allProducts.removeWhere((p) => p.id == product.id);
    allProducts.add(product);
    notifyListeners();
  }

  void delete(Product product) {
    product.delete();
    allProducts.removeWhere((p) => p.id == product.id);
    notifyListeners();
  }
}
