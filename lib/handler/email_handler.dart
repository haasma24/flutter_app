/*import 'dart:convert';
import 'package:http/http.dart' as http;

class EmailHandler {
  static const String apiKey = 're_5rX2yfbM_B8eoHBCpjAVmQcVAoQqWvt9s'; // Remplace avec ta clé API

  static Future<bool> sendVerificationEmail({
    required String userName,
    required String userEmail,
    required String verificationCode,
  }) async {
    final Uri url = Uri.parse('https://api.resend.com/emails');

    final Map<String, dynamic> data = {
      "from": "Your App <onboarding@resend.dev>",
      "to": [userEmail],
      "subject": "Code de vérification",
      "text": "Bonjour $userName,\n\nVoici votre code de vérification : $verificationCode"
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      return response.statusCode == 200 || response.statusCode == 202;
    } catch (e) {
      print('Erreur lors de l\'envoi du mail : $e');
      return false;
    }
  }
}*/


/*import 'dart:convert';
import 'package:http/http.dart' as http;

class EmailHandler {
  static const String apiKey = 're_5rX2yfbM_B8eoHBCpjAVmQcVAoQqWvt9s';
  //static const String apiKey = 're_dEGYTLCZ_Bx4SDnYESGKbW34rU9ggjkfo';

  static Future<bool> sendVerificationEmail({
    required String userName,
    required String userEmail,
    required String verificationCode,
  }) async {
    final Uri url = Uri.parse('https://api.resend.com/emails');

    final Map<String, dynamic> data = {
      "from": "onboarding@resend.dev", // ✅ format valide en sandbox
      "to": [  userEmail],
      "subject": "Code de vérification",
      "text": "Bonjour $userName,\n\nVoici votre code de vérification : $verificationCode"
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      return response.statusCode == 200 || response.statusCode == 202;
    } catch (e) {
      print('Erreur lors de l\'envoi du mail : $e');
      return false;
    }
  }
}*/









/*import 'dart:convert';
import 'package:http/http.dart' as http;

class EmailHandler {
  static const String apiKey = 're_5rX2yfbM_B8eoHBCpjAVmQcVAoQqWvt9s';

  static Future<bool> sendVerificationEmail({
    required String userName,
    required String userEmail,
    required String verificationCode,
  }) async {
    final Uri url = Uri.parse('https://api.resend.com/emails');

    final Map<String, dynamic> data = {
      "from": "onboarding@resend.dev",
      "to": ["asmahammami652@gmail.com"], // Envoi vers admin
      "subject": "Code de vérification pour un nouvel utilisateur",
      "text": "Un nouvel utilisateur ($userName) tente de s'inscrire avec l'adresse : $userEmail\n\n"
              "Voici le code de vérification généré : $verificationCode"
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      return response.statusCode == 200 || response.statusCode == 202;
    } catch (e) {
      print('Erreur lors de l\'envoi du mail : $e');
      return false;
    }
  }
}*/









import 'dart:convert';
import 'package:http/http.dart' as http;

class EmailHandler {
  static const String apiKey = 're_5rX2yfbM_B8eoHBCpjAVmQcVAoQqWvt9s';

  static Future<bool> sendVerificationEmail({
    required String userName,
    required String userEmail,
    required String verificationCode,
  }) async {
    final Uri url = Uri.parse('https://api.resend.com/emails');

    final Map<String, dynamic> data = {
      "from": "onboarding@resend.dev",
      "to": ["asmahammami652@gmail.com", userEmail], // Envoie à admin + utilisateur
      "subject": "Code de vérification pour $userName",
      "text": "Bonjour $userName,\n\n"
              "Voici votre code de vérification : $verificationCode\n\n"
              "-----------------------------\n"
              "Information administrateur :\n"
              "Nom : $userName\n"
              "Email : $userEmail\n"
              "Code généré : $verificationCode"
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      return response.statusCode == 200 || response.statusCode == 202;
    } catch (e) {
      print('Erreur lors de l\'envoi du mail : $e');
      return false;
    }
  }
}


