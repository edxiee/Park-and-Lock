import 'package:flutter/material.dart';

import '../widgets/custom_text_field.dart';
import '../widgets/custom_action_button.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isLoading = false;

  Future<void> signUpUser(
    String email,
    String password,
    String fullName,
  ) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      // Save additional user details to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user?.uid)
          .set({
            'fullName': fullName,
            'email': email,
            'createdAt': FieldValue.serverTimestamp(),
          });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Success! User UID: \\${credential.user?.uid}'),
          ),
        );
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      String msg = '';
      if (e.code == 'weak-password') {
        msg = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        msg = 'The account already exists for that email.';
      } else {
        msg = e.message ?? 'Signup failed.';
      }
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(msg)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted)
        setState(() {
          _isLoading = false;
        });
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

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
              CustomTextField(
                hint: 'Full Name',
                icon: Icons.person_outline,
                controller: _fullNameController,
              ),
              const SizedBox(height: 15),
              CustomTextField(
                hint: 'Email Address',
                icon: Icons.email_outlined,
                controller: _emailController,
              ),
              const SizedBox(height: 15),
              CustomTextField(
                hint: 'Password',
                icon: Icons.lock_outline,
                isPassword: true,
                controller: _passwordController,
              ),
              const SizedBox(height: 15),
              CustomTextField(
                hint: 'Confirm Password',
                icon: Icons.lock_reset_outlined,
                isPassword: true,
                controller: _confirmPasswordController,
              ),
              const SizedBox(height: 30),
              _isLoading
                  ? const CircularProgressIndicator()
                  : CustomActionButton(
                      label: 'Register Now',
                      bgColor: Colors.black,
                      textColor: Colors.white,
                      onPressed: () {
                        final email = _emailController.text.trim();
                        final password = _passwordController.text;
                        final confirmPassword = _confirmPasswordController.text;
                        if (email.isEmpty || password.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Email and password are required.'),
                            ),
                          );
                          return;
                        }
                        if (password != confirmPassword) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Passwords do not match.'),
                            ),
                          );
                          return;
                        }
                        final fullName = _fullNameController.text.trim();
                        if (fullName.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Full name is required.'),
                            ),
                          );
                          return;
                        }
                        signUpUser(email, password, fullName);
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
