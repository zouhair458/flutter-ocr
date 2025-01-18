import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  String? _email;
  String? _password;
  bool _isLoading = false;

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      setState(() => _isLoading = true);

      try {
        final user = await _authService.login(_email!, _password!);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Bienvenue, ${user['username']}!")),
        );
        Navigator.pushNamed(context, '/uploader', arguments: user);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Connexion")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Email"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Veuillez entrer une adresse e-mail valide." : null,
                onSaved: (value) => _email = value,
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(labelText: "Mot de passe"),
                obscureText: true,
                validator: (value) =>
                    value == null ? "Le mot de passe doit contenir au moins 6 caractères." : null,
                onSaved: (value) => _password = value,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Se connecter"),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: Text("Créer un compte"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
