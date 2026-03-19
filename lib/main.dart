import 'package:flutter/material.dart';
// ayvan joined
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
                const Text('Park & Lock',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                const SizedBox(height: 30),

                // --- LOGO ---
                Image.asset('assets/Logo.png', height: 120,
                    errorBuilder: (context, error, stackTrace) {
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
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => const CreateAccountPage()));
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
      appBar: AppBar(
          title: const Text('Park & Lock'),
          centerTitle: true,
          automaticallyImplyLeading: false
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Image.asset('assets/Logo.png', height: 80,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.image, size: 80, color: Colors.grey)),
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
          onPressed: () => Navigator.push(context, MaterialPageRoute(
              builder: (context) => target)),
          child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 16)),
        ),
      ),
    );
  }
}

// --- 3. CREATE ACCOUNT PAGE ---
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
              const Text('Join Park & Lock',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text('Enter your details to register',
                  style: TextStyle(color: Colors.grey)),
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
            Image.asset('assets/Logo.png', height: 100,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.check_circle, size: 100, color: Colors.green)),
            const SizedBox(height: 20),
            const Icon(Icons.check_circle, size: 60, color: Colors.green),
            const SizedBox(height: 20),
            const Text('Action Successful!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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

// --- 5. STORE FLOW: SCANNER ---
class ScannerPage extends StatelessWidget {
  const ScannerPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const BackButton()),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200, height: 200,
              decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
              child: const Icon(Icons.camera_alt, size: 100, color: Colors.black87),
            ),
            const SizedBox(height: 20),
            const Text('Scan QR of the slot'),
            const SizedBox(height: 40),
            _actionButton(context, 'Open', Colors.tealAccent[400]!, Colors.black, () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => const SuccessPage()));
            }),
          ],
        ),
      ),
    );
  }
}

// --- 6. RETRIEVE FLOW: HELMETS & PAYMENT ---
class HelmetsPage extends StatelessWidget {
  const HelmetsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Helmets')),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(30),
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Slot #1',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              _actionButton(context, 'Retrieve', Colors.green, Colors.white, () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => const PaymentPage()));
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Payment amount', style: TextStyle(color: Colors.grey)),
            const Text('₱ 50.00',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            const Text('Choose payment method',
                style: TextStyle(fontWeight: FontWeight.bold)),
            _payTile(Icons.credit_card, 'Credit or Debit Card'),
            _payTile(Icons.account_balance_wallet, 'GCash'),
            _payTile(Icons.payments, 'Cash'),
            const Spacer(),
            _actionButton(context, 'Continue', Colors.green, Colors.white, () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => const SuccessPage()));
            }),
          ],
        ),
      ),
    );
  }

  Widget _payTile(IconData icon, String title) {
    return Card(child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        trailing: const Icon(Icons.circle_outlined, size: 20)));
  }
}

// --- 7. SLOTS GRID PAGE ---
class SlotsPage extends StatelessWidget {
  const SlotsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Slots')),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 15, mainAxisSpacing: 15),
        itemCount: 6,
        itemBuilder: (context, index) {
          bool isOccupied = index % 3 == 0;
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: isOccupied ? Colors.red : Colors.green, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                isOccupied ? 'Occupied' : 'Available',
                style: TextStyle(
                    color: isOccupied ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
    );
  }
}

// --- HELPERS ---
Widget _textField(String hint, IconData icon, {bool isPassword = false}) {
  return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hint,
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none)));
}

Widget _actionButton(BuildContext context, String label, Color bg, Color txt, VoidCallback onPressed) {
  return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: bg,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          onPressed: onPressed,
          child: Text(label, style: TextStyle(color: txt, fontSize: 18))));
}

Widget _outlineButton(BuildContext context, String label, VoidCallback onPressed) {
  return Padding(
    padding: const EdgeInsets.only(top: 10),
    child: SizedBox(
        width: double.infinity,
        height: 55,
        child: OutlinedButton(
            style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.black),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            onPressed: onPressed,
            child: Text(label, style: const TextStyle(color: Colors.black, fontSize: 18)))),
  );
}