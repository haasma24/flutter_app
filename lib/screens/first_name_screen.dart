import 'package:flutter/material.dart';
import 'package:recommendation_app/model/registration_context.dart';
import 'last_name_screen.dart';

class FirstNameScreen extends StatefulWidget {
  final RegistrationContext contextData;

  const FirstNameScreen({super.key, required this.contextData});

  @override
  _FirstNameScreenState createState() => _FirstNameScreenState();
}

class _FirstNameScreenState extends State<FirstNameScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("First Name", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF4B0000),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: _buildStepIndicator(currentStep: 0),
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
            // Main content
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 20),
                      Text(
                        'Your First Name',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF781D19),
                        ),
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        controller: _firstNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            setState(() => _hasError = true);
                            return 'Please enter your first name';
                          }
                          setState(() => _hasError = false);
                          return null;
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.9),
                          hintText: 'Enter your first name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 18, horizontal: 20),
                          prefixIcon: Icon(Icons.person, 
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
                      ),
                      if (_hasError) SizedBox(height: 10),
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
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            widget.contextData.firstName = _firstNameController.text;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => LastNameScreen(
                                    contextData: widget.contextData),
                              ),
                            );
                          }
                        },
                        child: Text(
                          'Next',
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