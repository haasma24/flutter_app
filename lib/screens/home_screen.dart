import 'package:flutter/material.dart';
import 'package:recommendation_app/model/registration_context.dart';
import 'first_name_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
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
            // Decorative elements
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFD4AF37).withOpacity(0.1),
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
                  color: Color(0xFFD4AF37).withOpacity(0.1),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Premium logo with fallback
                  _buildLogoWidget(),

                  SizedBox(height: 30),

                  // App title with gold accent
                  Column(
                    children: [
                      Text(
                        'CINÉMUSIC',
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF781D19),
                          letterSpacing: 1.5,
                        ),
                      ),
                      Container(
                        height: 4,
                        width: 60,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Color(0xFFD4AF37),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Text(
                        'Premium Recommendations',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFFD35612),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 40),

                  // Premium features with gold icons
                  _buildFeatureList(),
                  
                  // Register button
                  _buildRegisterButton(context),

                  SizedBox(height: 25),

                  // Login text
                  _buildLoginButton(context),

                  SizedBox(height: 40),


                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoWidget() {
    try {
      return Container(
        height: 350, // Increased size
        width: 350,  // Increased size
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,  // Enhanced shadow
              spreadRadius: 5,
            ),
          ],
        ),
        child: ClipOval(
          child: Image.asset(
            'assets/images/premium.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.star, color: Color(0xFFD4AF37), size: 70);
            },
          ),
        ),
      );
    } catch (e) {
      return Container(
        height: 200,  // Increased size
        width: 200,   // Increased size
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFFD4AF37).withOpacity(0.2),
        ),
        child: Icon(Icons.star, color: Color(0xFFD4AF37), size: 40),
      );
    }
  }

    Widget _buildFeatureList() {
    return Column(
      children: [
        FeatureRow(icon: Icons.personal_video, text: "Personalized recommendations"),
        FeatureRow(icon: Icons.verified_user, text: "Exclusive content"),
        FeatureRow(icon: Icons.no_accounts, text: "Ad-free experience"),
      ],
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.7,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            colors: [
              Color(0xFFD35612),
              Color(0xFF781D19),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFD35612).withOpacity(0.3),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () {
              RegistrationContext contextData = RegistrationContext(
                firstName: '',
                lastName: '',
                email: '',
                gender: '',
                password: '',
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FirstNameScreen(contextData: contextData),
                ),
              );
            },
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star, color: Color(0xFFD4AF37)),
                  SizedBox(width: 10),
                  Text(
                    "Register Now",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "Already a member? ",
              style: TextStyle(
                color: Color(0xFF761C1C).withOpacity(0.8),
              ),
            ),
            TextSpan(
              text: "Sign In",
              style: TextStyle(
                color: Color(0xFFD35612),
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }


}

class FeatureRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const FeatureRow({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Color(0xFFD4AF37),
            size: 20,
          ),
          SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              color: Color(0xFF330000),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
