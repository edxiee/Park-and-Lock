import 'package:flutter/material.dart';

class SlotsPage extends StatelessWidget {
  const SlotsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Helmet Slots'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: 6,
            itemBuilder: (context, index) {
              final slotNumber = index + 1;
              final isOccupied = index % 3 == 0;

              return _buildMinimalSlotCard(
                context,
                slotNumber: slotNumber,
                isOccupied: isOccupied,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMinimalSlotCard(
      BuildContext context, {
        required int slotNumber,
        required bool isOccupied,
      }) {
    final theme = Theme.of(context);

    return Container(
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

          // Slot Number
          Text(
            'Slot $slotNumber',
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
            isOccupied ? 'Occupied' : 'Available',
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