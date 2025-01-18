import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class AuthService {
  final String baseUrl = "http://10.0.2.2:8080/user";

  // Inscription
  Future<void> register(String username, String email, String password) async {
    final url = Uri.parse('$baseUrl/register');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Erreur d'inscription : ${response.body}");
    }
  }

  // Connexion
  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {"email": email, "password": password},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Renvoie les données utilisateur
    } else {
      throw Exception("Erreur de connexion : ${response.body}");
    }
  }

  // Déconnexion
  Future<void> logout(String email) async {
    final url = Uri.parse('$baseUrl/logout');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {"email": email},
    );

    if (response.statusCode != 200) {
      throw Exception("Erreur de déconnexion : ${response.body}");
    }
  }
}
