import 'package:flutter/material.dart';
import 'package:loja_virtual/shared/managers/cart_manager.dart';
import 'package:loja_virtual/shared/widgets/price_card.dart';
import 'package:provider/provider.dart';

import 'components/address_card.dart';

class AddressPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entrega'),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          AddressCard(),
          Consumer<CartManager>(
            builder: (_, cartManager, __) {
              return PriceCard(
                buttonText: 'Continuar para o Pagamento',
                onPressed: cartManager.isAddressValid ? () {} : null,
              );
            },
          ),
        ],
      ),
    );
  }
}
