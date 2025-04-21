import 'package:recommendation_app/model/registration_context.dart';

class GenderHandler {
  void handle(RegistrationContext contextData, String gender) {
    // Traitement pour le genre
    contextData.gender = gender;
  }
}
