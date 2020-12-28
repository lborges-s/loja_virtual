import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceSheet extends StatelessWidget {
  final Function(File) onImageSelected;
  ImageSourceSheet({Key key, this.onImageSelected}) : super(key: key);

  final ImagePicker picker = ImagePicker();
  Future<void> editImage(String path, BuildContext context) async {
    final file = await ImageCropper.cropImage(
      sourcePath: path,
      aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'Editar imagem',
        toolbarColor: Theme.of(context).primaryColor,
        toolbarWidgetColor: Colors.white,
      ),
      iosUiSettings: const IOSUiSettings(
        title: 'Editar Imagem',
        cancelButtonTitle: 'Cancelar',
        doneButtonTitle: 'Concluir',
      ),
    );
    if (file != null) {
      onImageSelected(file);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return BottomSheet(
        onClosing: () {},
        builder: (context) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FlatButton(
              onPressed: () => _openCamera(context),
              child: const Text('Câmera'),
            ),
            FlatButton(
              onPressed: () => _openGallery(context),
              child: const Text('Galeria'),
            ),
          ],
        ),
      );
    } else {
      return CupertinoActionSheet(
        title: const Text('Selecionar foto para o item'),
        message: const Text('Escolha a origem da foto'),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () => _openCamera(context),
            child: const Text('Câmera'),
          ),
          CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () => _openGallery(context),
            child: const Text('Galeria'),
          ),
        ],
      );
    }
  }

  Future<void> _openCamera(BuildContext context) async {
    final file = await picker.getImage(source: ImageSource.camera);
    if (file != null) await editImage(file.path, context);
  }

  Future<void> _openGallery(BuildContext context) async {
    final file = await picker.getImage(source: ImageSource.gallery);
    if (file != null) await editImage(file.path, context);
  }
}
