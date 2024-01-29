import 'package:flutter/material.dart';

class MiageDropdownField extends StatelessWidget {
  const MiageDropdownField({
    super.key,
    required this.icon,
    required this.text,
    required this.controller,
  });

  final String text;
  final IconData icon;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.purple),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          hintText: text,
        ),
      ),
    );
  }
}
