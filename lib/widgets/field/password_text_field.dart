import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;
  @override
  PasswordFieldState createState() => PasswordFieldState();
}

class PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: TextField(
          obscureText: _obscureText,
          enableSuggestions: false,
          autocorrect: false,
          controller: widget.controller,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.password, color: Colors.purple),
            suffixIcon: IconButton(
              icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off,
                  color: Colors.purple),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            hintText: 'Mot de passe',
          ),
        ));
  }
}
