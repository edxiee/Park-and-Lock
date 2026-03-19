import 'package:flutter/material.dart';

import '../widgets/custom_text_field.dart';
import '../widgets/custom_action_button.dart';
import '../widgets/custom_outline_button.dart';

import 'signup_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Park & Lock',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                Image.asset(
                  'assets/Logo.png',
                  height: 120,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.image, size: 80, color: Colors.grey);
                  },
                ),
                const SizedBox(height: 40),
                const CustomTextField(hint: 'Username', icon: Icons.person_outline),
                const SizedBox(height: 15),
                const CustomTextField(
                  hint: 'Password',
                  icon: Icons.lock_outline,
                  isPassword: true,
                ),
                const SizedBox(height: 30),
                CustomActionButton(
                  label: 'Login',
                  bgColor: Colors.black,
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/dashboard');
                  },
                ),
                CustomOutlineButton(
                  label: 'Create Account',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CreateAccountPage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}