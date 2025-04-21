import 'package:flutter/material.dart';
import 'package:recommendation_app/model/registration_context.dart';
import 'email_screen.dart';

class GenderScreen extends StatefulWidget {
  final RegistrationContext contextData;

  const GenderScreen({super.key, required this.contextData});

  @override
  _GenderScreenState createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  String? _selectedGender;
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gender", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF4B0000),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: _buildStepIndicator(currentStep: 2), // Step 3 of 5
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      'Your Gender',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF781D19),
                      ),
                    ),
                    SizedBox(height: 30),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: _selectedGender,
                          hint: Text('Select your gender', 
                              style: TextStyle(color: Colors.grey[600])),
                          icon: Icon(Icons.arrow_drop_down, 
                              color: Color(0xFFD35612)),
                          items: ['Male', 'Female'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF330000))),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value;
                              widget.contextData.gender = value!;
                              _hasError = false;
                            });
                          },
                        ),
                      ),
                    ),
                    if (_hasError)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Please select your gender',
                          style: TextStyle(
                            color: Color(0xFFD35612),
                            fontSize: 14,
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
                      onPressed: () {
                        if (_selectedGender == null) {
                          setState(() => _hasError = true);
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EmailScreen(
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