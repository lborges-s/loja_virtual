import 'package:flutter/material.dart';
import 'package:loja_virtual/shared/managers/orders_manager.dart';
import 'package:loja_virtual/shared/widgets/custom_drawer/custom_drawer.dart';
import 'package:loja_virtual/shared/widgets/empty_card.dart';
import 'package:loja_virtual/shared/widgets/login_card.dart';
import 'package:provider/provider.dart';

import '../../shared/widgets/order/order_tile.dart';

class OrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Pedidos'),
        centerTitle: true,
      ),
      drawer: CustomDrawer(),
      body: Consumer<OrdersManager>(
        builder: (_, ordersManager, __) {
          if (ordersManager.user == null) {
            return LoginCard();
          }
          if (ordersManager.orders.isEmpty) {
            return const EmptyCard(
              title: 'Nenhuma compra encontrada!',
              iconData: Icons.border_clear,
            );
          }
          return ListView.builder(
            itemCount: ordersManager.orders.length,
            itemBuilder: (_, index) {
              return OrderTile(ordersManager.orders.reversed.toList()[index]);
            },
          );
        },
      ),
    );
  }
}
