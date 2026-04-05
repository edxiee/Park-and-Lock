import 'package:flutter/material.dart';

import '../widgets/custom_action_button.dart';
import 'success_page.dart';

class ScannerPage extends StatelessWidget {
  const ScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Scan QR Code'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: theme.colorScheme.onSurface,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.surfaceContainerLowest,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Modern scanner frame with subtle shadow + corner accents
                  Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                      border: Border.all(
                        color: theme.colorScheme.outline.withValues(alpha: 0.6),
                        width: 1.5,
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Camera placeholder (replace with MobileScanner widget later)
                        Container(
                          width: 240,
                          height: 240,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: theme.colorScheme.primary.withValues(alpha: 0.3),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            size: 92,
                            color: Colors.black54,
                          ),
                        ),

                        // Scanner corner brackets (modern touch)
                        Positioned.fill(
                          child: CustomPaint(
                            painter: ScannerOverlayPainter(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Improved instruction text
                  Text(
                    'Scan the QR code on the slot',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 12),

                  Text(
                    'Position the QR code inside the frame',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 60),

                  // Enhanced button
                  CustomActionButton(
                    label: 'Open Camera',
                    bgColor: theme.colorScheme.primary,
                    textColor: theme.colorScheme.onPrimary,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SuccessPage(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // Optional helper text
                  Text(
                    'Make sure the QR is well-lit and not blurry',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Simple custom painter for scanner corner brackets
class ScannerOverlayPainter extends CustomPainter {
  final Color color;

  ScannerOverlayPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    const double cornerLength = 40;
    const double cornerRadius = 8;

    // Top-left
    canvas.drawLine(const Offset(30, 30), Offset(cornerLength + 30, 30), paint);
    canvas.drawLine(const Offset(30, 30), Offset(30, cornerLength + 30), paint);

    // Top-right
    canvas.drawLine(Offset(size.width - 30, 30), Offset(size.width - cornerLength - 30, 30), paint);
    canvas.drawLine(Offset(size.width - 30, 30), Offset(size.width - 30, cornerLength + 30), paint);

    // Bottom-left
    canvas.drawLine(Offset(30, size.height - 30), Offset(cornerLength + 30, size.height - 30), paint);
    canvas.drawLine(Offset(30, size.height - 30), Offset(30, size.height - cornerLength - 30), paint);

    // Bottom-right
    canvas.drawLine(
      Offset(size.width - 30, size.height - 30),
      Offset(size.width - cornerLength - 30, size.height - 30),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - 30, size.height - 30),
      Offset(size.width - 30, size.height - cornerLength - 30),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}