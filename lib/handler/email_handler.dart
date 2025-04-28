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
      "to": ["asmahammami652@gmail.com", userEmail], // Sends to admin + user
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