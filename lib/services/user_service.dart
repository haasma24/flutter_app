// user_service.dart
class UserService {
  static const Map<String, dynamic> currentUser = {
    'email': 'mariem@gmail.com',
    'userId': 1,
    'username': 'Mariem'
  };

  static int get userId => currentUser['userId'];
  static String get username => currentUser['username'];
  static String get email => currentUser['email'];
}