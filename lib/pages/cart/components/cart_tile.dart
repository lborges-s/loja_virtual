import 'package:flutter/material.dart';
import 'package:loja_virtual/shared/models/cart_product.dart';
import 'package:loja_virtual/shared/widgets/custom_icon_button.dart';
import 'package:provider/provider.dart';

class CartTile extends StatelessWidget {
  final CartProduct cartProduct;

  const CartTile(this.cartProduct, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: cartProduct,
      child: InkWell(
        onTap: () => Navigator.of(context).pushNamed(
          '/product',
          arguments: cartProduct.product,
        ),
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                SizedBox(
                  height: 80,
                  width: 80,
                  child: Image.network(cartProduct.product.images.first),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cartProduct.product.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17.0,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Tamanho: ${cartProduct.size}',
                            style: const TextStyle(fontWeight: FontWeight.w300),
                          ),
                        ),
                        Consumer<CartProduct>(
                          builder: (_, cartProduct, __) {
                            if (cartProduct.hasStock) {
                              return Text(
                                'R\$ ${cartProduct.unitPrice.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }
                            return const Text(
                              'Sem estoque disponível',
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Consumer<CartProduct>(
                  builder: (_, cartProduct, __) => Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomIconButton(
                        iconData: Icons.add,
                        color: Theme.of(context).primaryColor,
                        onTap: cartProduct.increment,
                      ),
                      Text(
                        cartProduct.quantity.toString(),
                        style: const TextStyle(fontSize: 18),
                      ),
                      CustomIconButton(
                        iconData: Icons.remove,
                        color: cartProduct.quantity > 1
                            ? Theme.of(context).primaryColor
                            : Colors.red,
                        onTap: cartProduct.decrement,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
