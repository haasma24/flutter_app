import 'package:recommendation_app/model/registration_context.dart';

class LastNameHandler {
  void handle(RegistrationContext contextData, String lastName) {
    // Traitement pour le nom
    contextData.lastName = lastName;
  }
}
