import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'pages/welcom_screen.dart'; // Importez votre écran de bienvenue ici
import 'pages/login_screen.dart';
import 'pages/registration_screen.dart';
import 'pages/chat_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(CosonsApp());
}

class CosonsApp extends StatelessWidget {
  const CosonsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      initialRoute: WelcomeScreen.route,
      routes: {
        ChatScreen.route: (context) => ChatScreen(key: GlobalKey()),
        LoginScreen.route: (context) => LoginScreen(),
        RegistrationScreen.route: (context) => RegistrationScreen(),
        WelcomeScreen.route: (context) => WelcomeScreen(
              key: GlobalKey(),
            ),
      },
    );
  }
}
