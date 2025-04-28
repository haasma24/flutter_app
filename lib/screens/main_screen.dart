import 'package:flutter/material.dart';
import 'package:recommendation_app/screens/WelcomeScreen.dart';
import 'package:recommendation_app/screens/app_routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Recommendation',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      onGenerateRoute: AppRoutes.generateRoute,
      home: WelcomeScreen(),
    );
  }
}