import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/custom_action_button.dart';
import 'payment_page.dart';

class HelmetsPage extends StatelessWidget {
  const HelmetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('My Helmets'),
          centerTitle: true,
          elevation: 0,
        ),
        body: const SafeArea(
          child: Center(
            child: Text('Please sign in again to view your stored helmets.'),
          ),
        ),
      );
    }

    final helmetRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('helmets')
        .doc('locker_01');

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Helmets'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: helmetRef.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                final errorText = snapshot.error?.toString() ?? 'Unknown error';
                return Center(
                  child: Text(
                    'Unable to load your helmets right now.\n$errorText',
                    textAlign: TextAlign.center,
                  ),
                );
              }

              final data = snapshot.data?.data();
              final isStored = data?['isStored'] == true;
              final storedAt = data?['updatedAt'];

              if (!isStored) {
                return _buildEmptyState(context, theme);
              }

              return _buildHelmetCard(
                context,
                theme: theme,
                storedAtText: _formatStoredAt(storedAt),
                onRetrievePressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const PaymentPage(lockerId: 'locker_01'),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.sports_motorsports_outlined,
            size: 96,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
          ),
          const SizedBox(height: 20),
          Text(
            'No helmet stored yet',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Store a helmet first, then it will appear here only for your account.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHelmetCard(
    BuildContext context, {
    required ThemeData theme,
    required String storedAtText,
    required VoidCallback onRetrievePressed,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Stored Helmets',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Tap on a helmet to retrieve it',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 40),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.07),
                blurRadius: 25,
                offset: const Offset(0, 10),
              ),
            ],
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.15),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.sports_motorsports_rounded,
                      size: 48,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Slot #1',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          storedAtText,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: CustomActionButton(
                  label: 'Retrieve Helmet',
                  bgColor: theme.colorScheme.primary,
                  textColor: theme.colorScheme.onPrimary,
                  onPressed: onRetrievePressed,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        Center(
          child: Text(
            'Only one helmet can be retrieved at a time',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  String _formatStoredAt(dynamic value) {
    if (value == null) {
      return 'Stored recently';
    }

    if (value is Timestamp) {
      final date = value.toDate();
      return 'Stored since ${date.month}/${date.day}/${date.year}';
    }

    return 'Stored recently';
  }
}
