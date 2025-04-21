import 'package:flutter/material.dart';
import 'package:recommendation_app/model/registration_context.dart';
import 'summary_screen.dart';

class PasswordScreen extends StatefulWidget {
  final RegistrationContext contextData;

  const PasswordScreen({super.key, required this.contextData});

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  String _passwordStrength = '';
  Color _strengthColor = Colors.grey;
  bool _isPasswordVisible = false;
  bool _isConfirmVisible = false;
  bool _hasError = false;

  void _checkPasswordStrength(String password) {
    String strength = 'Weak';
    Color color = Color(0xFFD35612); // Orange for weak

    if (password.length >= 8 &&
        RegExp(r'[A-Z]').hasMatch(password) &&
        RegExp(r'[a-z]').hasMatch(password) &&
        RegExp(r'[0-9]').hasMatch(password) &&
        RegExp(r'[!@#\$&*~]').hasMatch(password)) {
      strength = 'Strong';
      color = Color(0xFF4B8B00); // Green for strong
    } else if (password.length >= 6 &&
        RegExp(r'[A-Za-z]').hasMatch(password) &&
        RegExp(r'[0-9]').hasMatch(password)) {
      strength = 'Medium';
      color = Color(0xFFD4AF37); // Gold for medium
    }

    setState(() {
      _passwordStrength = strength;
      _strengthColor = color;
    });
  }

  void _validateAndProceed() {
    final password = _passwordController.text.trim();
    final confirm = _confirmController.text.trim();

    if (password.isEmpty || confirm.isEmpty) {
      setState(() => _hasError = true);
      _showMessage('Please enter and confirm your password');
      return;
    }

    if (password != confirm) {
      setState(() => _hasError = true);
      _showMessage('Passwords do not match');
      return;
    }

    if (_passwordStrength == 'Weak') {
      _showMessage('Password is too weak');
      return;
    }

    widget.contextData.password = password;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SummaryScreen(contextData: widget.contextData),
      ),
    );
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: Color(0xFF781D19),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Password', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF4B0000),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: _buildStepIndicator(currentStep: 4), // Step 5 of 5
        ),
      ),
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
            // Decorative circles
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
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 20),
                      Text(
                        'Secure Your Account',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF781D19),
                        ),
                      ),
                      SizedBox(height: 20),
                      Icon(Icons.lock_outline, 
                          size: 80, 
                          color: Color(0xFFD35612)),
                      SizedBox(height: 30),
                      Text(
                        'Create a strong password to protect your account',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF5C3F3F)),
                      ),
                      SizedBox(height: 40),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        onChanged: _checkPasswordStrength,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.9),
                          hintText: 'Enter your password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 18, horizontal: 20),
                          prefixIcon: Icon(Icons.lock, 
                              color: Color(0xFFD35612)),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible 
                                  ? Icons.visibility 
                                  : Icons.visibility_off,
                              color: Color(0xFFD35612)),
                            onPressed: () => setState(
                                () => _isPasswordVisible = !_isPasswordVisible),
                          ),
                          errorStyle: TextStyle(
                            color: Color(0xFFD35612),
                            fontSize: 14,
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Text(
                            'Password Strength: ',
                            style: TextStyle(
                              color: Color(0xFF5C3F3F),
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            _passwordStrength,
                            style: TextStyle(
                              color: _strengthColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        controller: _confirmController,
                        obscureText: !_isConfirmVisible,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.9),
                          hintText: 'Confirm your password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 18, horizontal: 20),
                          prefixIcon: Icon(Icons.lock_outline, 
                              color: Color(0xFFD35612)),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isConfirmVisible 
                                  ? Icons.visibility 
                                  : Icons.visibility_off,
                              color: Color(0xFFD35612)),
                            onPressed: () => setState(
                                () => _isConfirmVisible = !_isConfirmVisible),
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF781D19),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 16),
                          elevation: 5,
                          shadowColor: Color(0xFF781D19).withOpacity(0.3),
                        ),
                        onPressed: _validateAndProceed,
                        child: Text(
                          'Complete Registration',
                          style: TextStyle(
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
            ),
          ],
        ),
      ),
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

  Widget _buildStepIndicator({required int currentStep}) {
    final steps = ['Name', 'Last Name', 'Gender', 'Email', 'Password'];
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
      child: Column(
        children: [
          Row(
            children: List.generate(steps.length * 2 - 1, (index) {
              if (index.isOdd) {
                return Expanded(
                  child: Container(
                    height: 3,
                    color: (index ~/ 2) < currentStep
                        ? Color(0xFFD4AF37)
                        : Colors.grey[300],
                  ),
                );
              } else {
                int stepIndex = index ~/ 2;
                final isCompleted = stepIndex < currentStep;
                final isActive = stepIndex == currentStep;

                return Column(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? Color(0xFFD4AF37)
                            : isActive
                                ? Colors.white
                                : Colors.grey[300],
                        border: Border.all(
                          color: Color(0xFFD4AF37),
                          width: isActive ? 3 : 1,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: isActive
                            ? [
                                BoxShadow(
                                  color: Color(0x55D4AF37),
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                ),
                              ]
                            : [],
                      ),
                      child: Center(
                        child: isCompleted
                            ? Icon(Icons.check, color: Colors.white)
                            : Text(
                                '${stepIndex + 1}',
                                style: TextStyle(
                                  color: isActive
                                      ? Color(0xFFD4AF37)
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      steps[stepIndex],
                      style: TextStyle(
                        fontSize: 12,
                        color: isCompleted || isActive
                            ? Color(0xFFD4AF37)
                            : Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                );
              }
            }),
          ),
        ],
      ),
    );
  }
}