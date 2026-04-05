import 'package:flutter/material.dart';

import '../widgets/custom_action_button.dart';

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Success illustration area
                Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.primaryContainer.withValues(alpha: 0.15),
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    size: 92,
                    color: theme.colorScheme.primary,
                  ),
                ),

                const SizedBox(height: 40),

                // Success message
                Text(
                  'Action Successful!',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 12),

                Text(
                  'Your QR scan was completed successfully.\nThe slot has been updated.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 60),

                // Modern button
                SizedBox(
                  width: double.infinity,
                  child: CustomActionButton(
                    label: 'Back to Dashboard',
                    bgColor: theme.colorScheme.primary,
                    textColor: theme.colorScheme.onPrimary,
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/dashboard',
                            (route) => false,
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // Optional secondary action
                TextButton(
                  onPressed: () {
                    // You can add another action here (e.g., scan again)
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Scan Another Code',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}