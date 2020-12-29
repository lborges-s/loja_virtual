import 'package:flutter/material.dart';
import 'package:loja_virtual/shared/models/product.dart';

import 'components/images_form.dart';
import 'components/sizes_form.dart';

class EditProductPage extends StatelessWidget {
  final Product product;

  EditProductPage({Key key, this.product}) : super(key: key);

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Editar Anúncio'),
        centerTitle: true,
      ),
      body: Form(
        key: formKey,
        child: ListView(
          children: [
            ImagesForm(product: product),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    initialValue: product.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Título',
                      border: InputBorder.none,
                    ),
                    validator: (name) {
                      if (name.isEmpty) {
                        return 'Título é obrigatório';
                      }
                      if (name.length < 6) {
                        return 'Título muito curto';
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'A partir de',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                  Text(
                    'R\$ ...',
                    style: TextStyle(
                      fontSize: 22,
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text(
                      'Descrição',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  TextFormField(
                    initialValue: product.description,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Descrição',
                      border: InputBorder.none,
                    ),
                    maxLines: null,
                    validator: (name) {
                      if (name.isEmpty) {
                        return 'Descrição é obrigatória';
                      }
                      if (name.length < 10) {
                        return 'Descrição muito curta';
                      }
                      return null;
                    },
                  ),
                  SizesForm(product),
                  RaisedButton(
                    color: primaryColor,
                    textColor: Colors.white,
                    onPressed: () {
                      if (!formKey.currentState.validate()) return;

                      debugPrint('Válido!!');
                    },
                    child: const Text(
                      'Salvar',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
