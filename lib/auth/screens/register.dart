import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:neuro_learn/auth/screens/login.dart';
import 'package:neuro_learn/auth/services/authService.dart';
import 'package:neuro_learn/common/colors.dart';
import 'package:neuro_learn/common/typography.dart';
import 'package:neuro_learn/utils/customTextFormField.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/sign-up';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

final AuthService authService = AuthService();
final TextEditingController nameController = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController confirmPasswordController = TextEditingController();
final TextEditingController phoneController = TextEditingController();

class _SignUpScreenState extends State<SignUpScreen> {
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  Future<bool> signup() async {
    bool result = await authService.signUp(
      username: nameController.text,
      email: emailController.text,
      password: passwordController.text,
      phone: phoneController.text,
    );
    if (result) {
      Navigator.pushNamed(context, LoginScreen.routeName);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(milliseconds: 800),
                builder: (context, double value, child) {
                  return Transform.scale(
                    scale: value,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: neonYellowGreen,
                      child: CircleAvatar(
                        radius: 56,
                        backgroundImage: AssetImage('assets/images/logo.jpeg'),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),
              Text(
                'Create Account',
                style: SCRTypography.heading.copyWith(
                  color: white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Let’s get started with GitGenie!',
                style: SCRTypography.subHeading.copyWith(
                  color: white,
                ),
              ),
              const SizedBox(height: 32),

              /// Name
              CustomTextField(
                controller: nameController,
                labelText: "Name",
                hintText: "Enter your name",
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 20),

              /// Email
              CustomTextField(
                controller: emailController,
                labelText: "Email",
                hintText: "Enter your email",
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: phoneController,
                labelText: "Phone Number",
                hintText: "Enter your phone number",
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 20),

              /// Password
              CustomTextField(
                controller: passwordController,
                labelText: "Password",
                hintText: "Enter your password",
                obscureText: !_passwordVisible,
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: neonYellowGreen,
                  ),
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),

              /// Confirm Password
              CustomTextField(
                controller: confirmPasswordController,
                labelText: "Confirm Password",
                hintText: "Re-enter your password",
                obscureText: !_confirmPasswordVisible,
                suffixIcon: IconButton(
                  icon: Icon(
                    _confirmPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: neonYellowGreen,
                  ),
                  onPressed: () {
                    setState(() {
                      _confirmPasswordVisible = !_confirmPasswordVisible;
                    });
                  },
                ),
              ),
              const SizedBox(height: 30),

              /// Sign Up Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: signup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: neonYellowGreen,
                    foregroundColor: black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Sign Up',
                    style: SCRTypography.subHeading.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              /// Already have an account
              RichText(
                text: TextSpan(
                  text: 'Already have an account? ',
                  style: SCRTypography.body.copyWith(color: white),
                  children: [
                    TextSpan(
                      text: 'Log In',
                      style: SCRTypography.body.copyWith(
                        color: neonYellowGreen,
                        fontWeight: FontWeight.w700,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(context, LoginScreen.routeName);
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
