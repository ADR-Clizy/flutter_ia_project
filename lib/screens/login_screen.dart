import 'package:app_projet/api/user_api.dart';
import 'package:app_projet/screens/home_screen.dart';
import 'package:app_projet/widgets/field/miage_text_field.dart';
import 'package:app_projet/widgets/field/password_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String errorMessage = "";
  bool isLoading = false;

  Future<void> signInWithUsernameAndPassword(
      String username, String password) async {
    try {
      setState(() {
        isLoading = true;
      });
      String email = await getEmailFromUsername(username);

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (e) {
      setState(() {
        errorMessage = "Nom d'utilisateur ou mot de passe incorrect";
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(errorMessage),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.purple,
        title: const Text("Acti Miage"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "Bienvenue sur Acti Miage",
                  style: TextStyle(fontSize: 20),
                )),
            MiageTextField(
              text: 'Identifiant',
              icon: Icons.person,
              controller: usernameController,
            ),
            PasswordField(controller: passwordController),
            Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                ),
                onPressed: isLoading
                    ? null
                    : () async {
                        await signInWithUsernameAndPassword(
                            usernameController.text, passwordController.text);
                      },
                child: const Text('Se connecter'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
