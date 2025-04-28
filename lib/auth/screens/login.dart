import 'package:flutter/material.dart';
import 'package:neuro_learn/auth/screens/register.dart';
import 'package:neuro_learn/common/colors.dart';
import 'package:neuro_learn/common/typography.dart';
import 'package:neuro_learn/providers/userProvider.dart';
import 'package:neuro_learn/splash_screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

 
  void signin(BuildContext context) {
  authService.login(
    email: _emailController.text,
    password: _passwordController.text,
    callback: (bool success) {
      if (success) {
        print("Login Successful with email ${_emailController.text}");
        
        final userProvider = Provider.of<UserProvider>(context, listen: false);
          final userId = userProvider.user.id;
          final username = userProvider.user.name;

          print("User id: $userId");
          print("User name: $username");

        Navigator.pushNamed(
          context,
          SplashScreen.routeName,
          arguments: _emailController.text, 
        );
      } else {
        print("Password is Incorrect");
      }
    },
  );
}


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Circle Avatar Logo
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
              const SizedBox(height: 24),

              // Centered Headings
              Center(
                child: Text(
                  'Welcome Back!',
                  style: SCRTypography.h1.copyWith(
                    color: primaryText,
                    fontSize: 28,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Login to your account',
                  style: SCRTypography.body.copyWith(
                    color: white,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),

              // Email Field
              TextField(
                controller: _emailController,
                style: SCRTypography.body.copyWith(color: primaryText),
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle:
                      SCRTypography.body.copyWith(color: neonYellowGreen),
                  filled: true,
                  fillColor: inputBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: neonYellowGreen),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: black10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: neonYellowGreen, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Password Field
              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                style: SCRTypography.body.copyWith(color: primaryText),
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle:
                      SCRTypography.body.copyWith(color: neonYellowGreen),
                  filled: true,
                  fillColor: inputBackground,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: iconColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: neonYellowGreen),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: black10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: neonYellowGreen, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Forgot Password?',
                    style: SCRTypography.body.copyWith(
                      color: accent,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Login Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    signin(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: button,
                    foregroundColor: onButton,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    'Login',
                    style: SCRTypography.button.copyWith(fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Sign Up
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: SCRTypography.body.copyWith(
                      color: white,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, SignUpScreen.routeName);
                    },
                    child: Text(
                      'Sign Up',
                      style: SCRTypography.body.copyWith(
                        color: accent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
