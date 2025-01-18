import 'dart:convert';
import 'package:http/http.dart' as http;

class OcrService {
  final String apiUrl = 'https://api.ocr.space/parse/image'; // URL de l'API OCR.Space
  final String apiKey = 'K87189417088957'; // Remplacez par votre clé API

  // Fonction pour envoyer une image à l'API OCR.Space pour analyse
  Future<String> analyzeImage(String imagePath) async {
    final uri = Uri.parse(apiUrl);
    final request = http.MultipartRequest('POST', uri)
      ..headers['apikey'] = apiKey
      ..files.add(await http.MultipartFile.fromPath('file', imagePath))
      ..fields['language'] = 'fre'; // Définit la langue sur français.

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(responseBody);
      if (jsonResponse['IsErroredOnProcessing'] == true) {
        throw Exception('Erreur OCR : ${jsonResponse['ErrorMessage'] ?? 'Non spécifiée'}');
      }
      return jsonResponse['ParsedResults'][0]['ParsedText'] ?? 'Aucun texte détecté.';
    } else {
      throw Exception('Erreur réseau : ${response.reasonPhrase}');
    }
  }
}
