import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_projet/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<String> getEmailFromUsername(String username) async {
  var userSnapshot = await FirebaseFirestore.instance
      .collection('user')
      .where('username', isEqualTo: username)
      .get();

  if (userSnapshot.docs.isEmpty) {
    throw Exception("Nom d'utilisateur ou mot de passe incorrect");
  }

  return userSnapshot.docs.first.data()['email'];
}

Future<UserModel> getUserFromEmail(String email) async {
  var userSnapshot = await FirebaseFirestore.instance
      .collection('user')
      .where('email', isEqualTo: email)
      .get();

  if (userSnapshot.docs.isEmpty) {
    throw Exception("User not found");
  }

  return UserModel.fromMap(userSnapshot.docs.first.data());
}

Future<UserModel> putUser(UserModel user) async {
  try {
    var userSnapshot = await FirebaseFirestore.instance
        .collection('user')
        .where('email', isEqualTo: user.email)
        .get();

    if (userSnapshot.docs.isEmpty) {
      throw Exception("User not found");
    }

    await FirebaseFirestore.instance
        .collection('user')
        .doc(userSnapshot.docs.first.id)
        .update(user.toMap());

    User? firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null && firebaseUser.email == user.email) {
      await firebaseUser.updatePassword(user.password!);
    } else {
      throw Exception("Authentication user not found or email mismatch");
    }

    return user;
  } catch (e) {
    throw Exception("Une erreur est survenue lors de la sauvegarde.");
  }
}
