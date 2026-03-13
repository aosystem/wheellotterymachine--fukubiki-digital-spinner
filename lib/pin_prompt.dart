import 'package:flutter/material.dart';

class PinPrompt {
  static Future<bool> show(BuildContext context, {required String correctPin}) async {
    final c = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('PIN'),
        content: TextField(
          controller: c,
          keyboardType: TextInputType.number,
          obscureText: true,
          decoration: const InputDecoration(hintText: 'Enter PIN'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('OK'),
          ),
        ],
      ),
    );
    if (ok != true) {
      return false;
    }
    return c.text == correctPin;
  }
}
