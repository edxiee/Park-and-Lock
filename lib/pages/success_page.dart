import 'package:flutter/material.dart';

import '../widgets/custom_action_button.dart';

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/Logo.png',
              height: 100,
              errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.check_circle, size: 100, color: Colors.green),
            ),
            const SizedBox(height: 20),
            const Icon(Icons.check_circle, size: 60, color: Colors.green),
            const SizedBox(height: 20),
            const Text(
              'Action Successful!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            CustomActionButton(
              label: 'Back to Dashboard',
              bgColor: Colors.black,
              textColor: Colors.white,
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/dashboard',
                      (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}