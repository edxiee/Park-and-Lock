import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'scanner_page.dart';
import 'helmets_page.dart';
import 'slots_page.dart';
import 'tutorial_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Park & Lock'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Logout',
            onPressed: () => _showLogoutConfirmation(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // Logo with modern styling
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerLowest,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Image.asset(
                  'assets/Logo.png',
                  height: 140,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.shield_rounded,
                    size: 140,
                    color: theme.colorScheme.primary.withValues(alpha: 0.6),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              Text(
                'Welcome back!',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'What would you like to do today?',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 50),

              // Action Buttons
              _buildActionButton(
                context,
                label: 'Store Helmet',
                icon: Icons.add_box_rounded,
                color: theme.colorScheme.primary,
                onTap: () => _navigateTo(context, const ScannerPage()),
              ),

              const SizedBox(height: 16),

              _buildActionButton(
                context,
                label: 'Retrieve Helmet',
                icon: Icons.undo_rounded,
                color: theme.colorScheme.secondary,
                onTap: () => _navigateTo(context, const HelmetsPage()),
              ),

              const SizedBox(height: 16),

              _buildActionButton(
                context,
                label: 'Helmet Slots',
                icon: Icons.grid_view_rounded,
                color: Colors.teal,
                onTap: () => _navigateTo(context, const SlotsPage()),
              ),

              const SizedBox(height: 16),

              // NEW: Tutorial Button
              _buildActionButton(
                context,
                label: 'How to Use (Tutorial)',
                icon: Icons.help_outline_rounded,
                color: Colors.orange,
                onTap: () => _navigateTo(context, const TutorialPage()),
              ),

              const Spacer(),

              // Logout Button (more subtle & modern)
              _buildLogoutButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 68,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: color.withValues(alpha: 0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
        onPressed: onTap,
        child: Row(
          children: [
            Icon(icon, size: 28),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton.icon(
        icon: const Icon(Icons.logout_rounded, size: 22),
        label: const Text(
          'Logout',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: theme.colorScheme.error,
          side: BorderSide(
            color: theme.colorScheme.error.withValues(alpha: 0.6),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: () => _showLogoutConfirmation(context),
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      if (context.mounted) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/login', (route) => false);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to logout. Please try again.')),
        );
      }
    }
  }

  void _showLogoutConfirmation(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _logout(context);
            },
            child: Text(
              'Logout',
              style: TextStyle(color: theme.colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}
