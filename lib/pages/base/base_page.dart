import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/pages/admin_orders/admin_orders_page.dart';
import 'package:loja_virtual/pages/admin_users/admin_users_page.dart';
import 'package:loja_virtual/pages/home/home_page.dart';
import 'package:loja_virtual/pages/orders/orders_page.dart';
import 'package:loja_virtual/pages/products/products_page.dart';
import 'package:loja_virtual/pages/stores/stores_page.dart';
import 'package:loja_virtual/shared/managers/page_manager.dart';
import 'package:loja_virtual/shared/managers/user_manager.dart';
import 'package:provider/provider.dart';

class BasePage extends StatefulWidget {
  @override
  _BasePageState createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  final pageController = PageController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
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
              OrdersPage(),
              StoresPage(),
              if (userManager.adminEnabled) ...[
                AdminUsersPage(),
                AdminOrdersPage(),
              ]
            ],
          );
        },
      ),
    );
  }
}
