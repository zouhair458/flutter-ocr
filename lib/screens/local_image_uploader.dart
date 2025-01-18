import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import '../services/ocr_service.dart';

class LocalImageUploader extends StatefulWidget {
  final Function onLogout; // Callback pour gérer la déconnexion

  const LocalImageUploader({Key? key, required this.onLogout}) : super(key: key);



  @override
  _LocalImageUploaderState createState() => _LocalImageUploaderState();
}

class _LocalImageUploaderState extends State<LocalImageUploader> {
  File? _selectedImage;
  final OcrService _ocrService = OcrService();
  final ImagePicker _imagePicker = ImagePicker();
  String? _analysisResult;
  bool _isAnalyzing = false;

  // Fonction pour sélectionner une image depuis le stockage local
  Future<void> _pickImageFromLocal() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedImage = File(result.files.single.path!);
        _analysisResult = null; // Réinitialise le résultat précédent
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
        _analysisResult = null; // Réinitialise le résultat précédent
      });
    } else {
      _showSnackBar("Aucune photo prise.");
    }
  }

  // Fonction pour analyser l'image avec l'API OCR
  Future<void> _analyzeImage() async {
    if (_selectedImage == null) {
      _showSnackBar("Veuillez sélectionner une image.");
      return;
    }

    setState(() {
      _isAnalyzing = true;
      _analysisResult = null;
    });

    try {
      final result = await _ocrService.analyzeImage(_selectedImage!.path);
      setState(() {
        _analysisResult = result;
      });
    } catch (e) {
      _showSnackBar("Erreur lors de l'analyse OCR : ${e.toString()}");
    } finally {
      setState(() {
        _isAnalyzing = false;
      });
    }
  }

  // Fonction pour afficher une notification en bas de l'écran
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Fonction pour effacer l'image sélectionnée
  void _clearImage() {
    setState(() {
      _selectedImage = null;
      _analysisResult = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("OCR - Carte d'identité marocaine"),
         actions: [
          IconButton(
            icon: Icon(Icons.door_front_door, size: 24.0), // Icône porte ouverte
            onPressed: () {
              widget.onLogout(); // Appelle la fonction de déconnexion
            },
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF5F7FA), Color(0xFFC3CFE2)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView( // Permet de faire défiler la page
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Moroccan OCR - Identity Card",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A148C),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                "Upload or take a photo of a Moroccan identity card for advanced text recognition using OCR.",
                style: TextStyle(fontSize: 14, color: Color(0xFF555555)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              if (_selectedImage != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    _selectedImage!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 200,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: _analyzeImage,
                  icon: Icon(Icons.analytics),
                  label: Text(
                      _isAnalyzing ? "Analyse en cours..." : "Analyser"),
                ),
              ],
              if (_analysisResult != null) ...[
                const SizedBox(height: 20),
                Text(
                  "Résultat de l'analyse :",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF1E88E5),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        spreadRadius: 2,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    _analysisResult!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF333333),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 20),
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
              if (_selectedImage != null)
                ElevatedButton.icon(
                  onPressed: _clearImage,
                  icon: Icon(Icons.delete),
                  label: Text("Effacer l'image"),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
