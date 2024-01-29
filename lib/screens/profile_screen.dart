import 'package:app_projet/api/user_api.dart';
import 'package:app_projet/models/user.dart';
import 'package:app_projet/screens/login_screen.dart';
import 'package:app_projet/widgets/field/miage_text_field.dart';
import 'package:app_projet/widgets/field/password_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  UserModel? currentUser;

  bool isLoading = true;

  Future<void> _signOut(BuildContext context) async {
    try {
      setState(() {
        isLoading = true;
      });
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      const snackBar = SnackBar(content: Text('Erreur lors de la déconnexion'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void _saveProfileData() async {
    setState(() {
      isLoading = true;
    });
    try {
      UserModel userToUpdate = UserModel(
          username: loginController.text,
          email: currentUser!.email,
          password: passwordController.text,
          birthday: birthdayController.text,
          address: addressController.text,
          postalCode: postalCodeController.text,
          city: cityController.text);
      await putUser(userToUpdate);
      final scaffoldContext = context;
      Future.delayed(Duration.zero, () {
        ScaffoldMessenger.of(scaffoldContext).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text("Utilisateur enregistré avec succès."),
            duration: Duration(seconds: 3),
          ),
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Une erreur est survenue lors de la sauvegarde."),
          duration: Duration(seconds: 3),
        ),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final User? user = await FirebaseAuth.instance.authStateChanges().first;

      if (user != null && user.email != null) {
        final UserModel userModel = await getUserFromEmail(user.email!);

        setState(() {
          currentUser = userModel;
          loginController.text = userModel.username!;
          passwordController.text = userModel.password!;
          birthdayController.text =
              userModel.birthday == null ? '' : userModel.birthday!;
          addressController.text =
              userModel.address == null ? '' : userModel.address!;
          postalCodeController.text =
              userModel.postalCode == null ? '' : userModel.postalCode!;
          cityController.text = userModel.city == null ? '' : userModel.city!;
          isLoading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
              "Une erreur est survenue lors de la récupération de l'utilisateur."),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        title: const Text('Profil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: isLoading ? null : () => _signOut(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: isLoading
              ? [const Center(child: CircularProgressIndicator())]
              : [
                  MiageTextField(
                    text: 'Login',
                    icon: Icons.person,
                    controller: loginController,
                  ),
                  PasswordField(
                    controller: passwordController,
                  ),
                  MiageTextField(
                      icon: Icons.cake,
                      text: 'Anniversaire',
                      controller: birthdayController),
                  MiageTextField(
                      icon: Icons.home,
                      text: 'Adresse',
                      controller: addressController),
                  MiageTextField(
                      icon: Icons.place,
                      text: 'Code postal',
                      controller: postalCodeController),
                  MiageTextField(
                      icon: Icons.location_city,
                      text: 'Ville',
                      controller: cityController),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: isLoading ? null : _saveProfileData,
                    child: const Text('Valider'),
                  ),
                ],
        ),
      ),
    );
  }
}
