import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../widgets/custom_action_button.dart';
import 'payment_success_page.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key, required this.lockerId});

  final String lockerId;

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String? _selectedPaymentMethod;
  bool _isProcessing = false;
  double _calculatedAmount = 0.0;
  String _amountDisplay = '₱ 0.00';
  bool _isLoading = true;

  // Calculate payment based on updatedAt
  Future<void> _calculatePayment() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final helmetDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('helmets')
          .doc(widget.lockerId)
          .get();

      if (!helmetDoc.exists || !helmetDoc.data()!.containsKey('updatedAt')) {
        setState(() {
          _calculatedAmount = 0.0;
          _amountDisplay = '₱ 0.00';
          _isLoading = false;
        });
        return;
      }

      final Timestamp updatedAtTimestamp = helmetDoc['updatedAt'];
      final DateTime startTime = updatedAtTimestamp.toDate();
      final DateTime now = DateTime.now();

      final Duration difference = now.difference(startTime);
      final double minutesElapsed = difference.inMinutes.toDouble();

      double amount = 0.0;

      if (minutesElapsed > 10) {
        // First 10 minutes are free → charge ₱10 after grace period
        amount = 10.0;

        // Additional time beyond 10 minutes
        final double extraMinutes = minutesElapsed - 10;

        // Every 5 minutes after grace = +₱0.25
        final int fiveMinBlocks = (extraMinutes / 5).ceil();
        amount += fiveMinBlocks * 0.25;
      }
      // Else: within 10 mins → ₱0.00

      setState(() {
        _calculatedAmount = amount;
        _amountDisplay = '₱ ${_calculatedAmount.toStringAsFixed(2)}';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _calculatedAmount = 0.0;
        _amountDisplay = '₱ 0.00';
        _isLoading = false;
      });
    }
  }

  Future<void> _completeRetrieval() async {
    if (_selectedPaymentMethod == null || _isProcessing) {
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    final databaseUrl = Firebase.app().options.databaseURL;

    if (user == null || databaseUrl == null || databaseUrl.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to complete retrieval.')),
        );
      }
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final db = FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL: databaseUrl,
      );

      final lockerRef = db.ref('lockers/${widget.lockerId}');
      await lockerRef.child('command').set('OPEN');

      // Delete helmet record after successful retrieval
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('helmets')
          .doc(widget.lockerId)
          .delete();

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentSuccessPage(
              amount: _amountDisplay,
              paymentMethod: _selectedPaymentMethod!,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to complete retrieval.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

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
  void initState() {
    super.initState();
    _calculatePayment();
  }

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
              _isLoading
                  ? const Text(
                'Calculating...',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              )
                  : Text(
                _amountDisplay,
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),

              const SizedBox(height: 12),
              if (!_isLoading && _calculatedAmount == 0.0)
                const Text(
                  'Within 10-minute grace period — Free',
                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
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
                    final isSelected =
                        _selectedPaymentMethod == method['title'];

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

              // Continue Button
              SizedBox(
                width: double.infinity,
                child: CustomActionButton(
                  label: _isProcessing ? 'Processing...' : 'Continue',
                  bgColor: theme.colorScheme.primary,
                  textColor: theme.colorScheme.onPrimary,
                  onPressed: _selectedPaymentMethod == null ||
                      _isProcessing ||
                      _isLoading
                      ? null
                      : _completeRetrieval,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}