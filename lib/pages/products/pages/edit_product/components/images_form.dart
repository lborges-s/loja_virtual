import 'dart:io';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/shared/models/product.dart';

import 'image_source_sheet.dart';

class ImagesForm extends StatelessWidget {
  final Product product;

  const ImagesForm({Key key, @required this.product}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FormField<List<dynamic>>(
      initialValue: List.from(product.images),
      validator: (images) {
        if (images.isEmpty) return 'Insira ao menos uma imagem';
        return null;
      },
      onSaved: (images) => product.newImages = images,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (state) {
        void onImageSelected(File file) {
          state.value.add(file);
          state.didChange(state.value);
          Navigator.of(context).pop();
        }

        return Column(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Carousel(
                dotSize: 4.0,
                dotSpacing: 15,
                dotBgColor: Colors.transparent,
                dotIncreasedColor: Theme.of(context).primaryColor,
                autoplay: false,
                images: state.value.map<Widget>(
                  (image) {
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        // IMAGEM
                        if (image is String)
                          Image.network(image, fit: BoxFit.cover)
                        else
                          Image.file(image as File, fit: BoxFit.cover),

                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: const Icon(Icons.remove, color: Colors.red),
                            onPressed: () {
                              state.value.remove(image);
                              state.didChange(state.value);
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ).toList()
                  ..add(
                    Material(
                      color: Colors.grey[100],
                      child: IconButton(
                        icon: Icon(
                          Icons.add_a_photo,
                          color: Theme.of(context).primaryColor,
                          size: 50,
                        ),
                        onPressed: () {
                          if (Platform.isAndroid) {
                            showModalBottomSheet(
                              context: context,
                              builder: (_) => ImageSourceSheet(
                                onImageSelected: onImageSelected,
                              ),
                            );
                          } else {
                            showCupertinoModalPopup(
                              context: context,
                              builder: (_) => ImageSourceSheet(
                                onImageSelected: onImageSelected,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
              ),
            ),
            if (state.hasError)
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  state.errorText,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
