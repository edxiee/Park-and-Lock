import 'package:flutter/material.dart';

import 'scanner_page.dart';
import 'helmets_page.dart';
import 'slots_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Park & Lock'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Image.asset(
              'assets/Logo.png',
              height: 80,
              errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.image, size: 80, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            _dashButton(context, 'Store Helmet', const ScannerPage()),
            _dashButton(context, 'Retrieve Helmet', const HelmetsPage()),
            _dashButton(context, 'Helmet Slots', const SlotsPage()),
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
}