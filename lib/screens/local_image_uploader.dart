import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class LocalImageUploader extends StatefulWidget {
  @override
  _LocalImageUploaderState createState() => _LocalImageUploaderState();
}

class _LocalImageUploaderState extends State<LocalImageUploader> {
  File? _selectedImage;
  final ImagePicker _imagePicker = ImagePicker();

  // Fonction pour sélectionner une image depuis le disque local
  Future<void> _pickImageFromLocal() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'], // Autorise uniquement les images
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedImage = File(result.files.single.path!);
      });
    } else {
      _showSnackBar("Aucun fichier sélectionné ou format incorrect.");
    }
  }

  // Fonction pour prendre une photo avec l'appareil photo
  Future<void> _takePhoto() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    } else {
      _showSnackBar("Aucune photo prise.");
    }
  }

  // Fonction pour effacer l'image sélectionnée
  void _clearImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  // Afficher une notification en bas de l'écran
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Uploader une image ou prendre une photo"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Section de prévisualisation
            Expanded(
              child: _selectedImage == null
                  ? Center(
                      child: Text(
                        "Aucune image sélectionnée.",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        _selectedImage!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
            ),
            const SizedBox(height: 20),
            // Bouton pour choisir une image
            ElevatedButton.icon(
              onPressed: _pickImageFromLocal,
              icon: Icon(Icons.folder),
              label: Text("Choisir une image"),
            ),
            ElevatedButton.icon(
              onPressed: _takePhoto,
              icon: Icon(Icons.camera_alt),
              label: Text("Prendre une photo"),
            ),
            const SizedBox(height: 10),
            if (_selectedImage != null)
              ElevatedButton.icon(
                onPressed: _clearImage,
                icon: Icon(Icons.delete),
                label: Text("Effacer l'image"),
              ),
          ],
        ),
      ),
    );
  }
}
