import 'package:flutter/material.dart';

import '../widgets/custom_action_button.dart';
import 'success_page.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Payment amount', style: TextStyle(color: Colors.grey)),
            const Text(
              '₱ 50.00',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            const Text('Choose payment method', style: TextStyle(fontWeight: FontWeight.bold)),
            _payTile(Icons.credit_card, 'Credit or Debit Card'),
            _payTile(Icons.account_balance_wallet, 'GCash'),
            _payTile(Icons.payments, 'Cash'),
            const Spacer(),
            CustomActionButton(
              label: 'Continue',
              bgColor: Colors.green,
              textColor: Colors.white,
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

  Widget _payTile(IconData icon, String title) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        trailing: const Icon(Icons.circle_outlined, size: 20),
      ),
    );
  }
}