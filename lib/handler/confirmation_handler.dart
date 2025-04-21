import 'package:recommendation_app/model/registration_context.dart';

class ConfirmationHandler {
  void handle(RegistrationContext contextData) {
    // Traitement de la confirmation des données
    print('Confirmation des données :');
    print('Prénom: ${contextData.firstName}');
    print('Nom: ${contextData.lastName}');
    print('Email: ${contextData.email}');
    print('Genre: ${contextData.gender}');
    print('Mot de passe: ${contextData.password}');
  }
}
