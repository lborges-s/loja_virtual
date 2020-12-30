import 'package:flutter/material.dart';
import 'package:loja_virtual/shared/managers/product_manager.dart';
import 'package:loja_virtual/shared/managers/user_manager.dart';
import 'package:loja_virtual/shared/widgets/custom_drawer/custom_drawer.dart';
import 'package:provider/provider.dart';

import 'components/product_list_tile.dart';
import 'components/search_dialog.dart';

class ProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).primaryColor,
        onPressed: () => Navigator.of(context).pushNamed('/cart'),
        child: const Icon(Icons.shopping_cart),
      ),
      appBar: AppBar(
        title: LayoutBuilder(builder: (_, constraints) {
          return Consumer<ProductManager>(
            builder: (_, productManager, __) {
              if (productManager.search.isEmpty) {
                return const Text('Produtos');
              } else {
                return GestureDetector(
                  onTap: () => _onSearch(context, productManager),
                  child: SizedBox(
                    width: constraints.biggest.width,
                    child: Text(
                      productManager.search,
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
            },
          );
        }),
        centerTitle: true,
        actions: [
          Consumer<ProductManager>(
            builder: (_, productManager, __) {
              if (productManager.search.isEmpty) {
                return IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _onSearch(context, productManager),
                );
              } else {
                return IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () async {
                    productManager.search = '';
                  },
                );
              }
            },
          ),
          Consumer<UserManager>(
            builder: (_, userManager, __) {
              if (userManager.adminEnabled) {
                return IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () =>
                      Navigator.of(context).pushNamed('/edit_product'),
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
      drawer: CustomDrawer(),
      body: Consumer<ProductManager>(
        builder: (_, productManager, __) {
          final filteredProducts = productManager.filteredProducts;
          return ListView.builder(
            padding: const EdgeInsets.all(4),
            itemCount: filteredProducts.length,
            itemBuilder: (_, index) {
              return ProductListTile(
                product: filteredProducts[index],
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _onSearch(
      BuildContext context, ProductManager productManager) async {
    final searchText = await showDialog<String>(
      context: context,
      builder: (_) => SearchDialog(initialText: productManager.search),
    );
    if (searchText != null) {
      productManager.search = searchText;
    }
    return;
  }
}
