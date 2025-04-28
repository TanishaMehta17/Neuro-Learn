import 'package:flutter/material.dart';
import 'package:neuro_learn/auth/screens/login.dart';
import 'package:neuro_learn/auth/screens/register.dart';
import 'package:neuro_learn/neuro_learn/screens/homeScreen.dart';
import 'package:neuro_learn/splash_screen.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case SignUpScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => SignUpScreen(),
      );
    case LoginScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => LoginScreen(),
      );
    case HomeScreen.routeName:
      final userName = routeSettings.arguments as String? ?? '';
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => HomeScreen(userName: userName),
      );

    case SplashScreen.routeName:
      final email = routeSettings.arguments as String? ?? '';
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => SplashScreen(email: email), // Pass the email argument
      );

    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => Scaffold(
          body: Center(
            child: Text('No route defined for ${routeSettings.name}'),
          ),
        ),
      );
  }
}
