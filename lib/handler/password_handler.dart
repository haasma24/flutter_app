import 'package:recommendation_app/model/registration_context.dart';

class PasswordHandler {
  void handle(RegistrationContext contextData, String password) {
    // Traitement pour le mot de passe
    contextData.password = password;
  }
}
