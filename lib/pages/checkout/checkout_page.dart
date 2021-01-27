import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:loja_virtual/shared/managers/cart_manager.dart';
import 'package:loja_virtual/shared/managers/checkout_manager.dart';
import 'package:loja_virtual/shared/widgets/price_card.dart';
import 'package:provider/provider.dart';

import 'components/credit_card_widget.dart';

class CheckoutPage extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<CartManager, CheckoutManager>(
      create: (_) => CheckoutManager(),
      update: (_, cartManager, checkoutManager) =>
          checkoutManager..updateCart(cartManager),
      lazy: false,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Pagamento'),
          centerTitle: true,
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Consumer<CheckoutManager>(
            builder: (_, checkoutManager, __) {
              if (checkoutManager.loading) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Processando seu pagamento...',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                );
              }
              return Form(
                key: formKey,
                child: ListView(
                  children: <Widget>[
                    CreditCardWidget(),
                    PriceCard(
                      buttonText: 'Finalizar Pedido',
                      onPressed: () {
                        if (!formKey.currentState.validate()) return;
                        debugPrint('Válido');
                        // checkoutManager.checkout(
                        //   onStockFail: (error) => Navigator.of(context).popUntil(
                        //       (route) => route.settings.name == '/cart'),
                        //   onSuccess: (order) {
                        //     Navigator.of(context)
                        //         .popUntil((route) => route.settings.name == '/');
                        //     Navigator.of(context)
                        //         .pushNamed('/confirmation', arguments: order);
                        //   },
                        // );
                      },
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
