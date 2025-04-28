import 'package:flutter/material.dart';
import 'package:recommendation_app/screens/forgot_password_screen.dart';
import 'package:recommendation_app/screens/home_screen.dart';
import 'package:recommendation_app/theme/theme.dart';

/*void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recommendation App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(), // Ton écran d'accueil
      routes: {
        '/forgotPassword': (context) => ForgotPasswordScreen(), // La route pour mot de passe oublié
      },
    );
  }
}*/

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music & Film Recommendations',
      theme: appTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/forgotPassword': (context) => ForgotPasswordScreen(),
        '/home': (context) => HomeScreen(), // Or whatever your home screen is
      },
    );
  }
}