import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'registration_screen.dart';
import '../widgets/rounded_button.dart';

class WelcomeScreen extends StatefulWidget {
  static String route = "/welcome-screen";

  const WelcomeScreen({required Key key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  // Le reste du code que vous avez déjà fourni pour votre écran de bienvenue
  // ...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    child: Hero(
                  tag: 'logo',
                  child: SizedBox(
                    height: 270.0,
                    child: Image.asset('assets/meta/chat.png'),
                  ),
                )),
              ],
            ),
            const SizedBox(
              height: 28.0,
            ),
            RoundedButton(
              title: 'Connexion',
              color: Colors.orange,
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.route);
              },
            ),
            RoundedButton(
              title: 'Créer un compte',
              color: Colors.deepOrange,
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.route);
              },
            ),
          ],
        ),
      ),
    );
  }
}
