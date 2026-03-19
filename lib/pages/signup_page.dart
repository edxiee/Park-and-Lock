import 'package:flutter/material.dart';

import '../widgets/custom_text_field.dart';
import '../widgets/custom_action_button.dart';

class CreateAccountPage extends StatelessWidget {
  const CreateAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        leading: const BackButton(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              const Text(
                'Join Park & Lock',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Enter your details to register',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 30),
              const CustomTextField(hint: 'Full Name', icon: Icons.person_outline),
              const SizedBox(height: 15),
              const CustomTextField(hint: 'Email Address', icon: Icons.email_outlined),
              const SizedBox(height: 15),
              const CustomTextField(
                hint: 'Password',
                icon: Icons.lock_outline,
                isPassword: true,
              ),
              const SizedBox(height: 15),
              const CustomTextField(
                hint: 'Confirm Password',
                icon: Icons.lock_reset_outlined,
                isPassword: true,
              ),
              const SizedBox(height: 30),
              CustomActionButton(
                label: 'Register Now',
                bgColor: Colors.black,
                textColor: Colors.white,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Account created successfully! Please login.')),
                  );
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}