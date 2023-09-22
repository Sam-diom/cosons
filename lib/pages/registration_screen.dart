//packages

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosons/pages/login_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:loading_overlay/loading_overlay.dart';

//pages

import '../utils/constants.dart';
import './chat_screen.dart';
import '../widgets/rounded_button.dart';

class RegistrationScreen extends StatefulWidget {
  static String route = "/registation-screen";

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _username = TextEditingController();
  bool isLoading = false;
  String emailError = '';
  String passwordError = '';
  String usernameError = '';

  // Fonction pour valider les informations d'inscription
  bool validateRegistrationInfo() {
    bool isValid = true; // Variable pour suivre la validité globale

    // Vérifiez que l'adresse e-mail est valide
    if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
        .hasMatch(_email.text)) {
      setState(() {
        emailError = 'Adresse e-mail invalide';
      });
      isValid = false; // Marquez la validation globale comme invalide
    } else {
      emailError =
          ''; // Réinitialisez le message d'erreur si l'adresse e-mail est valide
    }

    // Vérifiez que le mot de passe a au moins 6 caractères
    if (_password.text.length < 6) {
      setState(() {
        passwordError = 'Le mot de passe doit avoir au moins 6 caractères';
      });
      isValid = false; // Marquez la validation globale comme invalide
    } else {
      passwordError =
          ''; // Réinitialisez le message d'erreur si le mot de passe est valide
    }

    // Vérifiez d'autres conditions si nécessaires
    // ...

    // Si toutes les validations passent, retournez true
    return isValid;
  }

  // Fonction pour afficher une boîte de dialogue de confirmation
  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Félicitations !'),
          content: Text('Vous vous êtes inscrit avec succès.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer la boîte de dialogue
                Navigator.pushNamed(context, LoginScreen.route);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
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
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                keyboardType: TextInputType.text,
                controller: _username,
                textAlign: TextAlign.center,
                decoration: kTextFieldDecoration.copyWith(
                    hintText: "Nom d'utilisateur"),
              ),
              Text(
                usernameError, // Affiche le message d'erreur du nom d'utilisateur
                style: TextStyle(color: Colors.red),
              ),
              const SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                title: 'Inscription',
                color: Colors.orange,
                onPressed: () async {
                  // Avant de créer un compte, validez les informations
                  if (validateRegistrationInfo()) {
                    setState(() {
                      isLoading = true; // Activez l'indicateur de chargement
                    });

                    try {
                      UserCredential userCredential = await FirebaseAuth
                          .instance
                          .createUserWithEmailAndPassword(
                        email: _email.text,
                        password: _password.text,
                      );

                      // Enregistrez d'autres informations associées à l'utilisateur dans Firebase Firestore.
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(userCredential.user!.uid)
                          .set({
                        'username': _username.text,
                        'email': _email.text,
                        'password': _password.text,
                        'registrationDate':
                            DateTime.now(), // Date et heure de création
                        // Ajoutez d'autres champs que vous souhaitez enregistrer ici.
                      });

                      setState(() {
                        isLoading =
                            false; // Désactivez l'indicateur de chargement après l'enregistrement réussi
                      });

                      _showConfirmationDialog(); // Afficher la boîte de dialogue de confirmation
                    } catch (error) {
                      print("Error: ${error.toString()}");
                      setState(() {
                        isLoading =
                            false; // Désactivez l'indicateur de chargement en cas d'erreur
                      });
                      // Gérez l'erreur ici (par exemple, affichez un message d'erreur)
                    }
                  }
                },
              ),
              const SizedBox(height: 10),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Avez vous déjà un compte? ',
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                  children: [
                    TextSpan(
                      text: 'Connexion',
                      style: const TextStyle(color: Colors.deepOrange),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Navigator.pushReplacementNamed(
                            context, LoginScreen.route),
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
