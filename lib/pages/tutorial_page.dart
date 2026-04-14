import 'package:flutter/material.dart';

class TutorialPage extends StatefulWidget {
  const TutorialPage({super.key});

  @override
  State<TutorialPage> createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  int currentStep = 0;

  final List<TutorialStep> steps = [
    TutorialStep(
      icon: Icons.qr_code_scanner_rounded,
      title: 'Step 1: Store Your Helmet',
      description:
      'Go to any available slot, scan the QR code using the "Store Helmet" option. The locker will open automatically.',
      color: Colors.blue,
    ),
    TutorialStep(
      icon: Icons.lock_open_rounded,
      title: 'Step 2: Place Helmet Safely',
      description:
      'Place your helmet inside the locker properly and close the door. The system will register your helmet.',
      color: Colors.green,
    ),
    TutorialStep(
      icon: Icons.payment_rounded,
      title: 'Step 3: Retrieve Your Helmet',
      description:
      'Go to "Retrieve Helmet", select your slot and complete the payment to unlock the locker.',
      color: Colors.orange,
    ),
    TutorialStep(
      icon: Icons.grid_view_rounded,
      title: 'Step 4: Check Available Slots',
      description:
      'Use "Helmet Slots" to see real-time availability of all lockers in the parking area.',
      color: Colors.purple,
    ),
  ];

  void _next() {
    if (currentStep < steps.length - 1) {
      setState(() => currentStep++);
    } else {
      Navigator.pop(context); // Done - go back to dashboard
    }
  }

  void _previous() {
    if (currentStep > 0) {
      setState(() => currentStep--);
    }
  }

  @override
  Widget build(BuildContext context) {
    final step = steps[currentStep];
    final isLastStep = currentStep == steps.length - 1;

    return Scaffold(
      appBar: AppBar(
        title: const Text('How Park & Lock Works'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Progress Indicator (at the top)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  steps.length,
                      (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index == currentStep
                          ? step.color
                          : Colors.grey.shade300,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Main Content - Centered Vertically
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Big Icon
                        Icon(
                          step.icon,
                          size: 120,
                          color: step.color,
                        ),

                        const SizedBox(height: 40),

                        // Title
                        Text(
                          step.title,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 24),

                        // Description
                        Text(
                          step.description,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            height: 1.6,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Navigation Buttons (fixed at bottom)
              Row(
                children: [
                  // Previous Button (hidden on first step)
                  if (currentStep > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _previous,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text('Previous'),
                      ),
                    ),

                  if (currentStep > 0) const SizedBox(width: 12),

                  // Next / Done Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _next,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: step.color,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        isLastStep ? 'Done' : 'Next',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// Helper class for each tutorial step
class TutorialStep {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  TutorialStep({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}