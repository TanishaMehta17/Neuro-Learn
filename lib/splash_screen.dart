import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:neuro_learn/common/colors.dart';
import 'package:neuro_learn/common/typography.dart';
import 'package:neuro_learn/neuro_learn/screens/homeScreen.dart';
import 'package:neuro_learn/providers/userProvider.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  static const routeName = '/splash';
  final String email;

  // Constructor to accept email
  const SplashScreen({required this.email});

  @override
  Widget build(BuildContext context) {
    String name = Provider.of<UserProvider>(context).user.name;
    return Scaffold(
      backgroundColor: black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Spacer(flex: 3),
            AnimatedBuilder(
              animation: Listenable.merge([Provider.of<UserProvider>(context)]),
              builder: (context, child) {
                return Transform.rotate(
                  angle: 0.05,
                  child: Lottie.asset(
                    'assets/lottie/ai_hand_waving.json',
                    height: 350,
                    width: 350,
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Welcome, $name! Say goodbye to boring study routines — Neuro-Learn uses AI to supercharge your learning experience and help you achieve more in less time!",
                textAlign: TextAlign.center,
                style: SCRTypography.subHeading
                    .copyWith(color: neonYellowGreen, fontSize: 18),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, HomeScreen.routeName);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: neonYellowGreen,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                "Get Started",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: black,
                ),
              ),
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
