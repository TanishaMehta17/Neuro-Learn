import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neuro_learn/auth/screens/login.dart';
import 'package:neuro_learn/auth/services/authService.dart';
import 'package:neuro_learn/providers/userProvider.dart';
import 'package:neuro_learn/routes.dart';
import 'package:neuro_learn/splash_screen.dart';
import 'package:provider/provider.dart';

var globalMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    authService.getUserData(context);  
  }

  @override
  Widget build(BuildContext context) {
    print("User id ${Provider.of<UserProvider>(context).user.id}");
    bool isUserLoggedIn =
        Provider.of<UserProvider>(context).user.token.isNotEmpty;
    print("User is logged in or not ? $isUserLoggedIn");

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: isUserLoggedIn
          ? SplashScreen(email: Provider.of<UserProvider>(context).user.email)
          : LoginScreen(),
      onGenerateRoute: (settings) => generateRoute(settings),
    );
  }
}
