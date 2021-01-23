import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/pages/base/base_page.dart';
import 'package:loja_virtual/pages/login/login_page.dart';
import 'package:loja_virtual/pages/products/pages/edit_product/edit_product_page.dart';
import 'package:loja_virtual/pages/products/pages/product_detail/product_detail_page.dart';
import 'package:loja_virtual/shared/managers/user_manager.dart';
import 'package:loja_virtual/shared/models/product.dart';
import 'package:provider/provider.dart';

import 'pages/address/address_page.dart';
import 'pages/cart/cart_page.dart';
import 'pages/checkout/checkout_page.dart';
import 'pages/confirmation/confirmation_page.dart';
import 'pages/select_product/select_product_page.dart';
import 'pages/signup/signup_page.dart';
import 'shared/managers/admin_orders_manager.dart';
import 'shared/managers/admin_users_manager.dart';
import 'shared/managers/cart_manager.dart';
import 'shared/managers/home_manager.dart';
import 'shared/managers/orders_manager.dart';
import 'shared/managers/product_manager.dart';
import 'shared/models/order.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => ProductManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (context) => HomeManager(),
          lazy: false,
        ),
        ChangeNotifierProxyProvider<UserManager, CartManager>(
          update: (context, value, previous) => previous..updateUser(value),
          create: (_) => CartManager(),
          lazy: false,
        ),
        ChangeNotifierProxyProvider<UserManager, AdminUsersManager>(
          create: (_) => AdminUsersManager(),
          lazy: false,
          update: (_, userManager, adminUsersManager) =>
              adminUsersManager..updateUser(userManager),
        ),
        ChangeNotifierProxyProvider<UserManager, AdminOrdersManager>(
          create: (_) => AdminOrdersManager(),
          lazy: false,
          update: (_, userManager, adminOrdersManager) => adminOrdersManager
            ..updateAdmin(adminEnabled: userManager.adminEnabled),
        ),
        ChangeNotifierProxyProvider<UserManager, OrdersManager>(
          create: (_) => OrdersManager(),
          lazy: false,
          update: (_, userManager, ordersManager) =>
              ordersManager..updateUser(userManager.user),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Loja Virtual',
        themeMode: ThemeMode.light,
        theme: ThemeData(
          primaryColor: const Color.fromARGB(255, 4, 125, 141),
          scaffoldBackgroundColor: const Color.fromARGB(255, 4, 125, 141),
          appBarTheme: const AppBarTheme(elevation: 0),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/base',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/login':
              return MaterialPageRoute(builder: (_) => LoginPage());
            case '/signup':
              return MaterialPageRoute(builder: (_) => SignUpPage());
            case '/product':
              return MaterialPageRoute(
                builder: (_) => ProductDetailPage(
                  product: settings.arguments as Product,
                ),
              );
            case '/cart':
              return MaterialPageRoute(
                builder: (_) => CartPage(),
                settings: settings,
              );
            case '/address':
              return MaterialPageRoute(builder: (_) => AddressPage());
            case '/checkout':
              return MaterialPageRoute(builder: (_) => CheckoutPage());
            case '/edit_product':
              return MaterialPageRoute(
                builder: (_) =>
                    EditProductPage(p: settings.arguments as Product),
              );
            case '/select_product':
              return MaterialPageRoute(builder: (_) => SelectProductPage());
            case '/confirmation':
              return MaterialPageRoute(
                  builder: (_) =>
                      ConfirmationPage(settings.arguments as Order));
            case '/base':
            default:
              return MaterialPageRoute(
                builder: (_) => BasePage(),
                settings: settings,
              );
          }
        },
      ),
    );
  }
}
