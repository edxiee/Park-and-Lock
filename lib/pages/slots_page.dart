import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class SlotsPage extends StatelessWidget {
  const SlotsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final databaseUrl = Firebase.app().options.databaseURL;

    if (databaseUrl == null || databaseUrl.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Helmet Slots'),
          centerTitle: true,
          elevation: 0,
        ),
        body: const SafeArea(
          child: Center(
            child: Text(
              'Realtime Database URL is missing.\n'
              'Set databaseURL in firebase_options.dart.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    final lockerStatusRef = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: databaseUrl,
    ).ref('lockers/locker_01/helmet_inside');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Helmet Slots'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: StreamBuilder<DatabaseEvent>(
              stream: lockerStatusRef.onValue,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return _buildSingleSlotCard(
                    context,
                    isOccupied: false,
                    statusLabel: 'Error loading status',
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                final value = snapshot.data?.snapshot.value;
                final helmetInside = value is bool
                    ? value
                    : value?.toString().toLowerCase() == 'true';

                return _buildSingleSlotCard(
                  context,
                  isOccupied: helmetInside,
                  statusLabel: helmetInside ? 'Occupied' : 'Available',
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSingleSlotCard(
    BuildContext context, {
    required bool isOccupied,
    required String statusLabel,
  }) {
    final theme = Theme.of(context);

    return Container(
      width: 260,
      height: 260,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isOccupied
              ? theme.colorScheme.error.withValues(alpha: 0.5)
              : theme.colorScheme.primary.withValues(alpha: 0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Lock Icon
          Icon(
            isOccupied ? Icons.lock_rounded : Icons.lock_open_rounded,
            size: 48,
            color: isOccupied
                ? theme.colorScheme.error
                : theme.colorScheme.primary,
          ),

          const SizedBox(height: 16),

          // Locker label
          Text(
            'Locker 01',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: isOccupied
                  ? theme.colorScheme.error
                  : theme.colorScheme.onSurface,
            ),
          ),

          const SizedBox(height: 4),

          // Minimal Status
          Text(
            statusLabel,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isOccupied
                  ? theme.colorScheme.error.withValues(alpha: 0.8)
                  : theme.colorScheme.primary.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
