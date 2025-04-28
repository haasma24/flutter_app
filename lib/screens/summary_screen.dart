import 'package:flutter/material.dart';
import 'package:recommendation_app/database/database_helper.dart';
import 'package:recommendation_app/model/registration_context.dart';
import 'package:recommendation_app/screens/success_screen.dart';

class SummaryScreen extends StatelessWidget {
  final RegistrationContext contextData;

  const SummaryScreen({super.key, required this.contextData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Summary', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF4B0000),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
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
            // Cercles décoratifs
            Positioned(
              top: -50,
              right: -50,
              child: _buildCircle(200),
            ),
            Positioned(
              bottom: -30,
              left: -30,
              child: _buildCircle(150),
            ),
            Positioned(
              top: 100,
              left: -60,
              child: _buildCircle(100),
            ),
            
            // Contenu principal
            SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20),
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      "Almost done!",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF781D19),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Review your information before completing registration",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF5C3F3F)),
                    ),
                    const SizedBox(height: 40),
                    
                    // Carte de résumé
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: Colors.white.withOpacity(0.9),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            _buildSummaryRow("First Name", contextData.firstName),
                            const Divider(color: Color(0xFFD4AF37)), 
                            const SizedBox(height: 15),
                            _buildSummaryRow("Last Name", contextData.lastName),
                            const Divider(color: Color(0xFFD4AF37)),
                            const SizedBox(height: 15),
                            _buildSummaryRow("Email", contextData.email),
                            const Divider(color: Color(0xFFD4AF37)),
                            const SizedBox(height: 15),
                            _buildSummaryRow("Gender", contextData.gender),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    
                    // Bouton de confirmation
                    Center(
                      child: ElevatedButton(
                        onPressed: () => _completeRegistration(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF781D19),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 16),
                          elevation: 5,
                        ),
                        child: const Text(
                          "Complete Registration",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Text(
            "$title:",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF330000)),
            ),
          ),
        Expanded(
          flex: 5,
          child: Text(
            value,
            style: TextStyle(color: Color(0xFF5C3F3F)),
          ),
        ),
      ],
    );
  }

  Widget _buildCircle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFD4AF37).withOpacity(0.1),
      ),
    );
  }

  void _completeRegistration(BuildContext context) async {
    final dbHelper = DatabaseHelper.instance;
    await dbHelper.insertUser({
      'firstName': contextData.firstName,
      'lastName': contextData.lastName,
      'email': contextData.email,
      'gender': contextData.gender,
      'password': contextData.password,
    });

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginSuccessScreen()),
    );
  }
}