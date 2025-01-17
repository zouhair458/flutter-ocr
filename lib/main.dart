import 'package:flutter/material.dart';
import 'screens/local_image_uploader.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';

void main() => runApp(ImageUploaderApp());

class ImageUploaderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/uploader': (context) => LocalImageUploader(),
      },
    );
  }
}
