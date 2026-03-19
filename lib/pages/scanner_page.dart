import 'package:flutter/material.dart';

import '../widgets/custom_action_button.dart';
import 'success_page.dart';

class ScannerPage extends StatelessWidget {
  const ScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const BackButton()),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
              child: const Icon(Icons.camera_alt, size: 100, color: Colors.black87),
            ),
            const SizedBox(height: 20),
            const Text('Scan QR of the slot'),
            const SizedBox(height: 40),
            CustomActionButton(
              label: 'Open',
              bgColor: Colors.tealAccent,
              textColor: Colors.black,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SuccessPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}