import 'package:flutter/material.dart';

import '../widgets/custom_action_button.dart';
import 'payment_success_page.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String? _selectedPaymentMethod;

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'icon': Icons.credit_card,
      'title': 'Credit Card',
      'subtitle': 'Visa, Mastercard, JCB',
    },
    {
      'icon': Icons.credit_card_outlined,
      'title': 'Debit Card',
      'subtitle': 'Any local or international debit card',
    },
    {
      'icon': Icons.account_balance_wallet_rounded,
      'title': 'GCash',
      'subtitle': 'Pay via GCash wallet',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Payment Amount
              Text(
                'Payment Amount',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '₱ 50.00',
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),

              const SizedBox(height: 40),

              // Section Title
              Text(
                'Choose Payment Method',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 16),

              // Payment Options List
              Expanded(
                child: ListView.builder(
                  itemCount: _paymentMethods.length,
                  itemBuilder: (context, index) {
                    final method = _paymentMethods[index];
                    final isSelected = _selectedPaymentMethod == method['title'];

                    return Card(
                      elevation: 0,
                      color: isSelected
                          ? theme.colorScheme.primaryContainer.withValues(alpha: 0.6)
                          : theme.colorScheme.surfaceContainerLowest,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.outline.withValues(alpha: 0.2),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                        leading: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.surfaceContainer,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            method['icon'] as IconData,
                            color: isSelected
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.primary,
                            size: 28,
                          ),
                        ),
                        title: Text(
                          method['title'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          method['subtitle'],
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        trailing: Radio<String>(
                          value: method['title'],
                          groupValue: _selectedPaymentMethod,
                          activeColor: theme.colorScheme.primary,
                          onChanged: (value) {
                            setState(() {
                              _selectedPaymentMethod = value;
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Continue Button - Fixed & Clean
              SizedBox(
                width: double.infinity,
                child: CustomActionButton(
                  label: 'Continue',
                  bgColor: theme.colorScheme.primary,
                  textColor: theme.colorScheme.onPrimary,
                  onPressed: _selectedPaymentMethod == null
                      ? null
                      : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PaymentSuccessPage(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}