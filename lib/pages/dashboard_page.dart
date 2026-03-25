import 'package:flutter/material.dart';

import 'scanner_page.dart';
import 'helmets_page.dart';
import 'slots_page.dart';
import 'login_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Park & Lock'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Logout',
            onPressed: () {
              _showLogoutConfirmation(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Image.asset(
              'assets/Logo.png',
              height: 200,
              errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.image, size: 200, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            _dashButton(context, 'Store Helmet', const ScannerPage()),
            _dashButton(context, 'Retrieve Helmet', const HelmetsPage()),
            _dashButton(context, 'Helmet Slots', const SlotsPage()),

            const Spacer(), // ← pushes logout button to bottom

            _logoutButton(context),
          ],
        ),
      ),
    );
  }

  Widget _dashButton(BuildContext context, String label, Widget target) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[850]),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => target),
            );
          },
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget _logoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red[700],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            _showLogoutConfirmation(context);
          },
          child: const Text(
            'Logout',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
