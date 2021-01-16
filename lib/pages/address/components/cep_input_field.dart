import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/shared/managers/cart_manager.dart';
import 'package:loja_virtual/shared/models/address.dart';
import 'package:loja_virtual/shared/widgets/custom_icon_button.dart';
import 'package:provider/provider.dart';

class CepInputField extends StatefulWidget {
  final Address address;

  const CepInputField({Key key, this.address}) : super(key: key);

  @override
  _CepInputFieldState createState() => _CepInputFieldState();
}

class _CepInputFieldState extends State<CepInputField> {
  final TextEditingController cepController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final cartManager = Provider.of<CartManager>(context, listen: false);
    final primaryColor = Theme.of(context).primaryColor;

    if (widget.address.zipCode == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextFormField(
            enabled: !cartManager.isLoading,
            controller: cepController,
            decoration: const InputDecoration(
              isDense: true,
              labelText: 'CEP',
              hintText: '12345-678',
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              CepInputFormatter(),
            ],
            keyboardType: TextInputType.number,
            validator: (cep) {
              if (cep.isEmpty) {
                return 'CEP obrigatório';
              } else if (cep.length != 10) {
                return 'CEP Inválido';
              }

              return null;
            },
          ),
          if (cartManager.isLoading)
            LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation(primaryColor),
              backgroundColor: Colors.transparent,
            ),
          RaisedButton(
            onPressed: !cartManager.isLoading
                ? () async {
                    if (!Form.of(context).validate()) return;

                    try {
                      await cartManager.getAddress(cepController.text);
                    } catch (e) {
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text(e.toString()),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                : null,
            textColor: Colors.white,
            color: primaryColor,
            disabledColor: primaryColor.withAlpha(100),
            child: const Text('Buscar CEP'),
          ),
        ],
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                'CEP: ${widget.address.zipCode}',
                style:
                    TextStyle(color: primaryColor, fontWeight: FontWeight.w600),
              ),
            ),
            CustomIconButton(
              iconData: Icons.edit,
              color: primaryColor,
              size: 20,
              onTap: () {
                context.read<CartManager>().removeAddress();
              },
            ),
          ],
        ),
      );
    }
  }
}
