import 'dart:math';
import 'package:flutter/material.dart';
import 'package:recommendation_app/database/database_helper.dart';
import 'package:recommendation_app/handler/email_handler.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> 
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _codeSent = false;
  bool _isLoading = false;
  bool _hasError = false;
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  String _generatedCode = '';
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
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

  Future<bool> doesEmailExist(String email) async {
    final user = await DatabaseHelper.instance.getUser(email);
    return user != null;
  }

  Future<void> _sendVerificationCode() async {
    final email = _emailController.text.trim();

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

    final exists = await doesEmailExist(email);
    if (!exists) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
      _showMessage('No account found with this email');
      return;
    }

    _generatedCode = _generateVerificationCode();

    final success = await EmailHandler.sendVerificationEmail(
      userName: '', // We don't have the name in forgot password flow
      userEmail: email,
      verificationCode: _generatedCode,
    );

    setState(() {
      _isLoading = false;
      _codeSent = success;
    });

    _showMessage(success ? 'Code sent to $email' : 'Failed to send code. Please try again.');
  }

  Future<void> _verifyCodeAndResetPassword() async {
    final enteredCode = _codeController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();
    
    if (enteredCode != _generatedCode) {
      _showMessage('Incorrect verification code');
      return;
    }

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      _showMessage('Please enter and confirm your new password');
      return;
    }

    if (newPassword != confirmPassword) {
      _showMessage('Passwords do not match');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await DatabaseHelper.instance.updateUser(
        _emailController.text.trim(),
        {'password': newPassword},
      );

      _showMessage('Password updated successfully!', isError: false);
      Navigator.pop(context);
    } catch (e) {
      _showMessage('Failed to update password. Please try again.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showMessage(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: isError ? const Color(0xFF781D19) : const Color(0xFF4B8B00),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
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
                          duration: const Duration(milliseconds: 300),
                          child: _codeSent
                              ? Column(
                                  children: [
                                    const SizedBox(height: 20),
                                    Text(
                                      'Check your email',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF781D19),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Icon(
                                      Icons.mark_email_read, 
                                      size: 80, 
                                      color: Color(0xFFD35612),
                                    ),
                                    const SizedBox(height: 30),
                                    Text(
                                      'We sent a verification code to:',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF5C3F3F),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      _emailController.text.trim(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF1B0000),
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                  ],
                                )
                              : Column(
                                  children: [
                                    const SizedBox(height: 20),
                                    Text(
                                      'Reset your password',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF781D19),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Icon(
                                      Icons.lock_reset, 
                                      size: 80, 
                                      color: Color(0xFFD35612),
                                    ),
                                    const SizedBox(height: 30),
                                    Text(
                                      'We\'ll send a verification code to your email',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF5C3F3F),
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                  ],
                                ),
                        ),
                        if (!_codeSent) ...[
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
                                vertical: 18, 
                                horizontal: 20,
                              ),
                              prefixIcon: Icon(
                                Icons.email, 
                                color: Color(0xFFD35612),
                              ),
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
                        ],
                        if (_codeSent) ...[
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
                                vertical: 18, 
                                horizontal: 20,
                              ),
                              prefixIcon: Icon(
                                Icons.lock, 
                                color: Color(0xFFD35612),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: _newPasswordController,
                            obscureText: !_showPassword,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.9),
                              hintText: 'New password',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 18, 
                                horizontal: 20,
                              ),
                              prefixIcon: Icon(
                                Icons.lock_outline, 
                                color: Color(0xFFD35612),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _showPassword 
                                      ? Icons.visibility 
                                      : Icons.visibility_off,
                                  color: Color(0xFFD35612),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _showPassword = !_showPassword;
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: !_showConfirmPassword,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.9),
                              hintText: 'Confirm new password',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 18, 
                                horizontal: 20,
                              ),
                              prefixIcon: Icon(
                                Icons.lock_outline, 
                                color: Color(0xFFD35612),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _showConfirmPassword 
                                      ? Icons.visibility 
                                      : Icons.visibility_off,
                                  color: Color(0xFFD35612),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _showConfirmPassword = !_showConfirmPassword;
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                        ],
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
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              : ElevatedButton(
                                  onPressed: _codeSent 
                                      ? _verifyCodeAndResetPassword 
                                      : _sendVerificationCode,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF781D19),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    elevation: 5,
                                    shadowColor: Color(0xFF781D19).withOpacity(0.3),
                                  ),
                                  child: Text(
                                    _codeSent ? 'Reset Password' : 'Send Code',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ),
                        ),
                        SizedBox(height: 20),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Back to Login',
                            style: TextStyle(
                              color: Color(0xFFD35612),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
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
}