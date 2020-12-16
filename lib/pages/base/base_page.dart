import 'package:flutter/material.dart';
import 'package:loja_virtual/pages/products/products_page.dart';
import 'package:loja_virtual/shared/managers/page_manager.dart';
import 'package:loja_virtual/shared/widgets/custom_drawer/custom_drawer.dart';
import 'package:provider/provider.dart';

class BasePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pageController = PageController();
    return Provider<PageManager>(
      create: (_) => PageManager(pageController),
      child: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Scaffold(
            appBar: AppBar(title: const Text('Início')),
            drawer: CustomDrawer(),
          ),
          ProductsPage(),
          Scaffold(
            appBar: AppBar(title: const Text('Meus Pedidos')),
            drawer: CustomDrawer(),
          ),
          Scaffold(
            appBar: AppBar(title: const Text('Lojas')),
            drawer: CustomDrawer(),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
