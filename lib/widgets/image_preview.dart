import 'package:flutter/material.dart';
import 'dart:io';

class ImagePreview extends StatelessWidget {
  final File? image;

  const ImagePreview({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: image == null
          ? Text(
              "Aucune image sélectionnée.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                image!,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
    );
  }
}
