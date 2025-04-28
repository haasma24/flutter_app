import 'package:flutter/material.dart';
import 'package:recommendation_app/screens/mood_selection_screen.dart';

enum SuccessType { login, registration }

class SuccessScreen extends StatelessWidget {
  final SuccessType successType;
  final String? userEmail; // Added for login case

  const SuccessScreen({super.key, required this.successType, this.userEmail});

  @override
  Widget build(BuildContext context) {
    final isLogin = successType == SuccessType.login;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF8F1E5),
              Color(0xFFF3E9D2),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFD4AF37).withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              bottom: -30,
              left: -30,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFD4AF37).withOpacity(0.1),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                        border: Border.all(
                          color: const Color(0xFFD4AF37),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        isLogin ? Icons.login : Icons.check_circle_outline,
                        size: 60,
                        color: isLogin ? const Color(0xFFD35612) : const Color(0xFF4B8B00),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      isLogin ? 'Welcome back!' : 'Registration Successful!',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF781D19),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      isLogin
                          ? 'You have successfully logged in to your account'
                          : 'Your account has been successfully created',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF5C3F3F),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {
                        if (isLogin) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MoodSelectionScreen(userEmail: userEmail ?? ''),
                            ),
                            (route) => false, // Remove all previous routes
                          );
                        } else {
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF781D19),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 16,
                        ),
                        elevation: 5,
                      ),
                      child: Text(
                        isLogin ? 'Continue' : 'Back to Home',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}