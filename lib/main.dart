import 'package:flutter/material.dart';

void main() => runApp(const ParkAndLockApp());

class ParkAndLockApp extends StatelessWidget {
  const ParkAndLockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/dashboard': (context) => const DashboardPage(),
      },
    );
  }
}

// --- 1. LOGIN PAGE ---
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Park & Lock', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                const SizedBox(height: 30),
                Image.asset('assets/Logo.png', height: 120, errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image, size: 80, color: Colors.grey);
                }),
                const SizedBox(height: 40),
                _textField('Username', Icons.person_outline),
                const SizedBox(height: 15),
                _textField('Password', Icons.lock_outline, isPassword: true),
                const SizedBox(height: 30),
                _actionButton(context, 'Login', Colors.black, Colors.white, () {
                  Navigator.pushReplacementNamed(context, '/dashboard');
                }),
                _outlineButton(context, 'Create Account', () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateAccountPage()));
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- 2. DASHBOARD PAGE ---
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Park & Lock'), centerTitle: true, automaticallyImplyLeading: false),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Image.asset('assets/Logo.png', height: 80, errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, size: 80)),
            const SizedBox(height: 40),
            _dashButton(context, 'Store Helmet', const ScannerPage()),
            _dashButton(context, 'Retrieve Helmet', const HelmetsPage()),
            _dashButton(context, 'Helmet Slots', const SlotsPage()),
          ],
        ),
      ),
    );
  }

  Widget _dashButton(BuildContext context, String label, Widget target) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[850]),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => target)),
          child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 16)),
        ),
      ),
    );
  }
}

// --- 3. CREATE ACCOUNT PAGE (FIXED) ---
class CreateAccountPage extends StatelessWidget {
  const CreateAccountPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account'), leading: const BackButton()),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              const Text('Join Park & Lock', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text('Enter your details to register', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 30),
              _textField('Full Name', Icons.person_outline),
              const SizedBox(height: 15),
              _textField('Email Address', Icons.email_outlined),
              const SizedBox(height: 15),
              _textField('Password', Icons.lock_outline, isPassword: true),
              const SizedBox(height: 15),
              _textField('Confirm Password', Icons.lock_reset_outlined, isPassword: true),
              const SizedBox(height: 30),
              _actionButton(context, 'Register Now', Colors.black, Colors.white, () {
                // Show a success message and go back to login
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Account created successfully! Please login.')),
                );
                Navigator.pop(context);
              }),
            ],
          ),
        ),
      ),
    );
  }
}

// --- 4. SUCCESS PAGE ---
class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/Logo.png', height: 100, errorBuilder: (context, error, stackTrace) => const Icon(Icons.check_circle, size: 100, color: Colors.green)),
            const SizedBox(height: 20),
            const Icon(Icons.check_circle, size: 60, color: Colors.green),
            const SizedBox(height: 20),
            const Text('Action Successful!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            _actionButton(context, 'Back to Dashboard', Colors.black, Colors.white, () {
              Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
            }),
          ],
        ),
      ),
    );
  }
}

// --- REMAINDER OF PAGES ---
class ScannerPage extends StatelessWidget {
  const ScannerPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Scan QR')), body: Center(child: _actionButton(context, 'Open', Colors.tealAccent[400]!, Colors.black, () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SuccessPage())))));
}

class HelmetsPage extends StatelessWidget {
  const HelmetsPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Helmets')), body: Center(child: _actionButton(context, 'Retrieve Slot #1', Colors.green, Colors.white, () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentPage())))));
}

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Payment')), body: Center(child: _actionButton(context, 'Pay ₱ 50.00', Colors.green, Colors.white, () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SuccessPage())))));
}

class SlotsPage extends StatelessWidget {
  const SlotsPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Slots')), body: const Center(child: Text('Slots Grid View')));
}

// --- SHARED HELPERS ---
Widget _textField(String hint, IconData icon, {bool isPassword = false}) {
  return TextField(obscureText: isPassword, decoration: InputDecoration(prefixIcon: Icon(icon), hintText: hint, filled: true, fillColor: Colors.grey[100], border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)));
}

Widget _actionButton(BuildContext context, String label, Color bg, Color txt, VoidCallback onPressed) {
  return SizedBox(width: double.infinity, height: 55, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: bg, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), onPressed: onPressed, child: Text(label, style: TextStyle(color: txt, fontSize: 18))));
}

Widget _outlineButton(BuildContext context, String label, VoidCallback onPressed) {
  return Padding(
    padding: const EdgeInsets.only(top: 10),
    child: SizedBox(width: double.infinity, height: 55, child: OutlinedButton(style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.black), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), onPressed: onPressed, child: Text(label, style: const TextStyle(color: Colors.black, fontSize: 18)))),
  );
}

Widget _payTile(IconData icon, String title) {
  return Card(child: ListTile(leading: Icon(icon, color: Colors.blue), title: Text(title), trailing: const Icon(Icons.circle_outlined, size: 20)));
}