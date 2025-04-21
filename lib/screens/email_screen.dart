import 'dart:math';
import 'package:flutter/material.dart';
import 'package:recommendation_app/database/database_helper.dart';
import 'package:recommendation_app/handler/email_handler.dart';
import 'package:recommendation_app/model/registration_context.dart';
import 'package:recommendation_app/screens/password_screen.dart';

class EmailScreen extends StatefulWidget {
  final RegistrationContext contextData;

  const EmailScreen({super.key, required this.contextData});

  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  bool _codeSent = false;
  bool _isLoading = false;
  bool _hasError = false;
  String _generatedCode = '';
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String _generateVerificationCode() {
    return (100000 + Random().nextInt(900000)).toString();
  }

  Future<bool> isEmailAlreadyUsed(String email) async {
    final user = await DatabaseHelper.instance.getUser(email);
    return user != null;
  }

  Future<void> _sendVerificationCode() async {
    final email = _emailController.text.trim();
    final name = widget.contextData.firstName;

    if (email.isEmpty) {
      _showMessage('Please enter an email');
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      _showMessage('Please enter a valid email');
      return;
    }

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    final alreadyUsed = await isEmailAlreadyUsed(email);
    if (alreadyUsed) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
      _showMessage('This email is already in use.');
      return;
    }

    _generatedCode = _generateVerificationCode();

    final success = await EmailHandler.sendVerificationEmail(
      userName: name,
      userEmail: email,
      verificationCode: _generatedCode,
    );

    setState(() {
      _isLoading = false;
      _codeSent = success;
    });

    _showMessage(success ? 'Code sent to $email' : 'Failed to send code. Please try again.');
  }

  Future<void> _verifyCodeAndProceed() async {
    final enteredCode = _codeController.text.trim();
    
    if (enteredCode == _generatedCode) {
      widget.contextData.email = _emailController.text.trim();
      
      await DatabaseHelper.instance.insertUser({
        'firstName': widget.contextData.firstName,
        'lastName': widget.contextData.lastName,
        'email': widget.contextData.email,
        'gender': widget.contextData.gender,
        'password': widget.contextData.password,
      });

      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 600),
          pageBuilder: (_, __, ___) => PasswordScreen(contextData: widget.contextData),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(0.5, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
        ),
      );
    } else {
      _showMessage('Incorrect code');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
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
        title: Text('Email Verification', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF4B0000),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: _buildStepIndicator(currentStep: 3), // Step 4 of 5
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
            ScaleTransition(
              scale: _scaleAnimation,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedSwitcher(
                          duration: Duration(milliseconds: 300),
                          child: _codeSent
                              ? Column(
                                  children: [
                                    SizedBox(height: 20),
                                    Text(
                                      'Check your email',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF781D19)),
                                      ),
                                    SizedBox(height: 20),
                                    Icon(Icons.mark_email_read, 
                                        size: 80, 
                                        color: Color(0xFFD35612)),
                                    SizedBox(height: 30),
                                    Text(
                                      'We sent a verification code to:',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF5C3F3F)),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      _emailController.text.trim(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF1B0000)),
                                    ),
                                    SizedBox(height: 30),
                                  ],
                                )
                              : Column(
                                  children: [
                                    SizedBox(height: 20),
                                    Text(
                                      'Enter your email',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF781D19)),
                                      ),
                                    SizedBox(height: 20),
                                    Icon(Icons.email_outlined, 
                                        size: 80, 
                                        color: Color(0xFFD35612)),
                                    SizedBox(height: 30),
                                    Text(
                                      'We\'ll send a verification code',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF5C3F3F)),
                                    ),
                                    SizedBox(height: 30),
                                  ],
                                ),
                        ),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.9),
                            hintText: 'Enter your email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 18, horizontal: 20),
                            prefixIcon: Icon(Icons.email, 
                                color: Color(0xFFD35612)),
                            errorStyle: TextStyle(
                              color: Color(0xFFD35612),
                              fontSize: 14,
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                color: Color(0xFFD35612),
                                width: 1.5,
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: _isLoading
                              ? Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Color(0xFF781D19),
                                  ),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                        color: Colors.white),
                                  ),
                                )
                              : ElevatedButton(
                                  onPressed: _sendVerificationCode,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF781D19),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    elevation: 5,
                                    shadowColor: Color(0xFF781D19).withOpacity(0.3),
                                  ),
                                  child: Text(
                                    'Send Code',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ),
                        ),
                        if (_codeSent) ...[
                          SizedBox(height: 40),
                          TextFormField(
                            controller: _codeController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.9),
                              hintText: 'Enter verification code',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 18, horizontal: 20),
                              prefixIcon: Icon(Icons.lock, 
                                  color: Color(0xFFD35612)),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(height: 30),
                          ElevatedButton(
                            onPressed: _verifyCodeAndProceed,
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
                            child: Text(
                              'Verify and Continue',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
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












