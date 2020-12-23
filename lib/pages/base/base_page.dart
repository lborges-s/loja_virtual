import 'package:flutter/material.dart';
import 'package:loja_virtual/pages/home/home_page.dart';
import 'package:loja_virtual/pages/products/products_page.dart';
import 'package:loja_virtual/shared/managers/page_manager.dart';
import 'package:loja_virtual/shared/managers/user_manager.dart';
import 'package:loja_virtual/shared/widgets/custom_drawer/custom_drawer.dart';
import 'package:provider/provider.dart';

class BasePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pageController = PageController();
    return Provider<PageManager>(
      create: (_) => PageManager(pageController),
      child: Consumer<UserManager>(
        builder: (_, userManager, __) {
          return PageView(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              HomePage(),
              ProductsPage(),
              Scaffold(
                appBar: AppBar(title: const Text('Meus Pedidos')),
                drawer: CustomDrawer(),
              ),
              Scaffold(
                appBar: AppBar(title: const Text('Lojas')),
                drawer: CustomDrawer(),
              ),
              if (userManager.adminEnabled) ...[
                Scaffold(
                  appBar: AppBar(title: const Text('Usuários')),
                  drawer: CustomDrawer(),
                ),
                Scaffold(
                  appBar: AppBar(title: const Text('Pedidos')),
                  drawer: CustomDrawer(),
                ),
              ]
            ],
          );
        },
      ),
    );
  }
}
