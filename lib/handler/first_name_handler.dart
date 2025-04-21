import 'package:recommendation_app/model/registration_context.dart';

class FirstNameHandler {
  void handle(RegistrationContext contextData, String firstName) {
    // Traitement pour le prénom
    contextData.firstName = firstName;
  }
}
