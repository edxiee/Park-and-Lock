import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'success_page.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  static const String _allowedLockerId = 'locker_01';
  static const Duration _unlockCooldown = Duration(seconds: 8);

  final MobileScannerController _controller = MobileScannerController(
    autoStart: true,
    detectionSpeed: DetectionSpeed.noDuplicates,
    formats: const [BarcodeFormat.qrCode],
    // Desktop webcams on web usually map to the "front/user" camera.
    facing: kIsWeb ? CameraFacing.front : CameraFacing.back,
  );

  bool _isProcessing = false;
  String? _lastWarningKey;
  DateTime? _lastWarningAt;
  DateTime? _lastUnlockAt;

  void _showSingleWarning(BuildContext context, String key, String message) {
    final now = DateTime.now();
    final isDuplicate =
        _lastWarningKey == key &&
        _lastWarningAt != null &&
        now.difference(_lastWarningAt!) < const Duration(seconds: 2);

    if (isDuplicate) {
      return;
    }

    _lastWarningKey = key;
    _lastWarningAt = now;

    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      // Some networks block the default script host. Provide a stable fallback.
      MobileScannerPlatform.instance.setBarcodeLibraryScriptUrl(
        'https://unpkg.com/@zxing/library@0.21.3',
      );
    }
  }

  String? _extractLockerId(String rawValue) {
    final trimmed = rawValue.trim();
    final normalizedDirect = _normalizeLockerId(trimmed);
    if (normalizedDirect != null) {
      return normalizedDirect;
    }

    if (trimmed.startsWith('{') && trimmed.endsWith('}')) {
      try {
        final data = jsonDecode(trimmed);
        if (data is Map) {
          final lockerId =
              data['lockerId'] ?? data['locker_id'] ?? data['locker'];
          final normalized = _normalizeLockerId(lockerId?.toString());
          if (normalized != null) {
            return normalized;
          }
        }
      } catch (_) {
        // Fall back to plain-text format when JSON decode fails.
      }
    }

    if (trimmed.toUpperCase().startsWith('LOCKER:')) {
      final id = trimmed.substring(7).trim();
      final normalized = _normalizeLockerId(id);
      if (normalized != null) {
        return normalized;
      }
    }

    final prefixedMatch = RegExp(
      r'^locker\s*[:=]\s*([a-z0-9_-]+)$',
      caseSensitive: false,
    ).firstMatch(trimmed);
    if (prefixedMatch != null) {
      final normalized = _normalizeLockerId(prefixedMatch.group(1));
      if (normalized != null) {
        return normalized;
      }
    }

    final uri = Uri.tryParse(trimmed);
    if (uri != null) {
      final fromQuery = _normalizeLockerId(
        uri.queryParameters['lockerId'] ??
            uri.queryParameters['locker_id'] ??
            uri.queryParameters['locker'],
      );
      if (fromQuery != null) {
        return fromQuery;
      }
    }

    return null;
  }

  String? _normalizeLockerId(String? input) {
    if (input == null) {
      return null;
    }

    final cleaned = input.trim().toLowerCase().replaceAll('-', '_');
    if (cleaned.isEmpty) {
      return null;
    }

    final match = RegExp(r'^locker_?(\d+)$').firstMatch(cleaned);
    if (match == null) {
      return null;
    }

    final number = int.tryParse(match.group(1)!);
    if (number == null) {
      return null;
    }

    return 'locker_${number.toString().padLeft(2, '0')}';
  }

  Future<void> _handleBarcode(BuildContext context, String rawValue) async {
    if (_isProcessing) {
      return;
    }

    setState(() => _isProcessing = true);

    final lockerId = _extractLockerId(rawValue);
    if (lockerId == null) {
      _showSingleWarning(context, 'invalid_qr', 'Invalid QR format.');
      return;
    }

    if (lockerId != _allowedLockerId) {
      _showSingleWarning(
        context,
        'wrong_locker',
        'Wrong QR code. Please scan locker 01 only.',
      );
      return;
    }

    final now = DateTime.now();
    if (_lastUnlockAt != null &&
        now.difference(_lastUnlockAt!) < _unlockCooldown) {
      _showSingleWarning(
        context,
        'cooldown',
        'Please wait a few seconds before scanning again.',
      );
      return;
    }

    final databaseUrl = Firebase.app().options.databaseURL;
    if (databaseUrl == null || databaseUrl.isEmpty) {
      _showSingleWarning(
        context,
        'missing_db_url',
        'Realtime Database URL is not configured.',
      );
      return;
    }

    try {
      final db = FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL: databaseUrl,
      );

      final lockerRef = db.ref('lockers/$lockerId');
      final helmetInsideSnapshot = await lockerRef.child('helmet_inside').get();

      final raw = helmetInsideSnapshot.value;
      final isOccupied = raw is bool
          ? raw
          : raw?.toString().toLowerCase() == 'true';

      if (isOccupied) {
        if (mounted) {
          _showSingleWarning(
            context,
            'occupied_$lockerId',
            'Locker $lockerId is occupied. Cannot open.',
          );
        }
        return;
      }

      // ESP32 firmware expects /lockers/<id>/command as a plain string.
      await lockerRef.child('command').set('OPEN');
      _lastUnlockAt = DateTime.now();

      final user = FirebaseAuth.instance.currentUser;
      var savedToUserAccount = true;
      if (user != null) {
        try {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('helmets')
              .doc(lockerId)
              .set({
                'lockerId': lockerId,
                'status': 'stored',
                'isStored': true,
                'updatedAt': FieldValue.serverTimestamp(),
              }, SetOptions(merge: true));
        } catch (e) {
          savedToUserAccount = false;
          final details = e is FirebaseException
              ? '${e.code}: ${e.message ?? 'Unknown Firebase error'}'
              : e.toString();
          if (mounted) {
            _showSingleWarning(
              context,
              'save_firestore_failed',
              'Locker opened, but failed to save helmet. $details',
            );
          }
        }
      }

      if (!savedToUserAccount) {
        return;
      }

      if (mounted) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SuccessPage(lockerId: lockerId),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        _showSingleWarning(
          context,
          'process_error',
          'Failed to process QR. Please try again.',
        );
      }
    } finally {
      await Future<void>.delayed(const Duration(milliseconds: 900));
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: SizedBox(
                            width: 240,
                            height: 240,
                            child: MobileScanner(
                              controller: _controller,
                              onDetect: (capture) {
                                for (final barcode in capture.barcodes) {
                                  final rawValue = barcode.rawValue;
                                  if (rawValue == null || rawValue.isEmpty) {
                                    continue;
                                  }
                                  _handleBarcode(context, rawValue);
                                  break;
                                }
                              },
                            ),
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
                    _isProcessing
                        ? 'Processing scanned QR...'
                        : 'Scan the QR code on the slot',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 12),

                  Text(
                    'Supported format: LOCKER:locker_01 or {"lockerId":"locker_01"}',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 26),

                  if (_isProcessing) const CircularProgressIndicator(),

                  const SizedBox(height: 20),

                  TextButton.icon(
                    onPressed: _isProcessing
                        ? null
                        : () async {
                            await _controller.switchCamera();
                          },
                    icon: const Icon(Icons.cameraswitch_rounded),
                    label: const Text('Switch Camera'),
                  ),

                  const SizedBox(height: 8),

                  // Optional helper text
                  Text(
                    'Keep the QR centered and about 20-30 cm from the webcam',
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

    // Top-left
    canvas.drawLine(const Offset(30, 30), Offset(cornerLength + 30, 30), paint);
    canvas.drawLine(const Offset(30, 30), Offset(30, cornerLength + 30), paint);

    // Top-right
    canvas.drawLine(
      Offset(size.width - 30, 30),
      Offset(size.width - cornerLength - 30, 30),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - 30, 30),
      Offset(size.width - 30, cornerLength + 30),
      paint,
    );

    // Bottom-left
    canvas.drawLine(
      Offset(30, size.height - 30),
      Offset(cornerLength + 30, size.height - 30),
      paint,
    );
    canvas.drawLine(
      Offset(30, size.height - 30),
      Offset(30, size.height - cornerLength - 30),
      paint,
    );

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
