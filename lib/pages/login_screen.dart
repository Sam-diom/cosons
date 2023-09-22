import 'package:cosons/pages/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cosons/pages/registration_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../widgets/rounded_button.dart';
import '../utils/constants.dart';

class LoginScreen extends StatefulWidget {
  static String route = "/login-screen";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isLoading = false;
  String emailError = '';
  String passwordError = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: SizedBox(
                  height: 280.0,
                  child: Image.asset('assets/meta/chat.png'),
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                controller: _email,
                textAlign: TextAlign.center,
                decoration: kTextFieldDecoration.copyWith(hintText: 'Email'),
              ),
              Text(
                emailError, // Affiche le message d'erreur de l'e-mail
                style: TextStyle(color: Colors.red),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                controller: _password,
                textAlign: TextAlign.center,
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Mot de passe'),
              ),
              Text(
                passwordError, // Affiche le message d'erreur du mot de passe
                style: TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 24.0),
              RoundedButton(
                title: 'Connexion',
                color: Colors.orange,
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });

                  // Réinitialisez les messages d'erreur
                  setState(() {
                    emailError = '';
                    passwordError = '';
                  });

                  // Validez les informations avant la connexion
                  bool isValid = true;

                  // Vérifiez que l'adresse e-mail est valide
                  if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                      .hasMatch(_email.text)) {
                    setState(() {
                      emailError = 'Adresse e-mail invalide';
                    });
                    isValid = false;
                  }

                  // Vérifiez que le mot de passe a au moins 6 caractères
                  if (_password.text.length < 6) {
                    setState(() {
                      passwordError =
                          'Le mot de passe doit avoir au moins 6 caractères';
                    });
                    isValid = false;
                  }

                  if (isValid) {
                    await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: _email.text, password: _password.text)
                        .then((value) {
                      Navigator.pushReplacementNamed(context, ChatScreen.route);
                      print("Sign In Successfull.");
                    }).onError((error, stackTrace) {
                      print("Sign In Error: ${error.toString()}");
                    });
                  }

                  setState(() {
                    isLoading = false;
                  });
                },
              ),
              const SizedBox(height: 10),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Vous êtes nouveau sur COSONS? ',
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                  children: [
                    TextSpan(
                      text: 'Inscription',
                      style: const TextStyle(color: Colors.deepOrange),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Navigator.pushReplacementNamed(
                            context, RegistrationScreen.route),
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
