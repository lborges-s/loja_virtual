import 'package:brasil_fields/brasil_fields.dart';
import 'package:credit_card_type_detector/credit_card_type_detector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'card_text_field.dart';

class CardFront extends StatelessWidget {
  final VoidCallback finished;
  final FocusNode numberFocus;
  final FocusNode dateFocus;
  final FocusNode nameFocus;

  CardFront(
      {Key key,
      this.finished,
      this.numberFocus,
      this.dateFocus,
      this.nameFocus})
      : super(key: key);

  final dateFormatter = MaskTextInputFormatter(
    mask: '!#/####',
    filter: {'#': RegExp('[0-9]'), '!': RegExp('[0-1]')},
  );

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 16,
      child: Container(
        height: 200,
        color: const Color(0xFF1B4B52),
        padding: const EdgeInsets.all(24),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  CardTextField(
                    title: 'Número',
                    hint: '0000 0000 0000 0000',
                    textInputType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CartaoBancarioInputFormatter(),
                    ],
                    bold: true,
                    validator: (number) {
                      if (number.length != 19) {
                        return 'Inválido';
                      } else if (detectCCType(number) ==
                          CreditCardType.unknown) {
                        return 'Inválido';
                      }
                      return null;
                    },
                    onSubmitted: (_) => dateFocus.requestFocus(),
                    focusNode: numberFocus,
                  ),
                  CardTextField(
                    title: 'Validade',
                    hint: '11/2020',
                    textInputType: TextInputType.number,
                    inputFormatters: [dateFormatter],
                    validator: (date) {
                      if (date.length != 7) return 'Inválido';
                      return null;
                    },
                    onSubmitted: (_) => nameFocus.requestFocus(),
                    focusNode: dateFocus,
                  ),
                  CardTextField(
                    title: 'Titular',
                    hint: 'João da Silva',
                    textInputType: TextInputType.text,
                    bold: true,
                    validator: (name) {
                      if (name.isEmpty) return 'Inválido';
                      return null;
                    },
                    onSubmitted: (_) => finished(),
                    focusNode: nameFocus,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
