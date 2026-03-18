import 'package:flutter/material.dart';

void main() => runApp(const ParkAndLockApp());

class ParkAndLockApp extends StatelessWidget {
  const ParkAndLockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Removes the red "Debug" banner
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // SafeArea prevents the app from overlapping with the iPhone notch
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. Title
              const Text(
                'Park & Lock',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 30),

              // 2. Placeholder Logo (Using an Icon instead of Image)
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.redAccent,
                child: Icon(Icons.sports_motorsports, size: 60, color: Colors.white),
              ),
              const SizedBox(height: 40),

              // 3. Username Input
              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person_outline),
                  hintText: 'Username',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // 4. Password Input
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outline),
                  hintText: 'Password',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              // 5. Login Button
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    print("Login tapped");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Login', style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ),

              // 6. Forgot Password
              TextButton(
                onPressed: () {},
                child: const Text('Forgot Password?', style: TextStyle(color: Colors.blueGrey)),
              ),

              const SizedBox(height: 10),

              // 7. Create Account Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DashboardPage()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.black, width: 1.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Create Account', style: TextStyle(color: Colors.black, fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Park & Lock'), centerTitle: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundColor: Colors.redAccent,
                child: Icon(Icons.sports_motorsports, size: 40, color: Colors.white),
              ),
              const SizedBox(height: 40),
              _dashboardButton(context, 'Store Helmet', const ScannerPage()),
              _dashboardButton(context, 'Retrieve Helmet', null),
              _dashboardButton(context, 'Helmet Slots', null),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dashboardButton(BuildContext context, String label, Widget? target) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[800]),
          onPressed: () {
            if (target != null) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => target));
            }
          },
          child: Text(label, style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}

class ScannerPage extends StatelessWidget {
  const ScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const BackButton()),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
            child: const Icon(Icons.qr_code_scanner, size: 100),
          ),
          const SizedBox(height: 20),
          const Text('Scan QR of the slot'),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent[100]),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SuccessPage()));
                },
                child: const Text('Open', style: TextStyle(color: Colors.black)),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.sports_motorsports, size: 100, color: Colors.redAccent),
            const SizedBox(height: 20),
            const Text('Helmet Detected!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[800], padding: const EdgeInsets.symmetric(horizontal: 50)),
              onPressed: () {
                // Returns to the very first screen
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text('Home', style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}