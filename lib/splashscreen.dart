import 'dart:async';
import 'package:flutter/material.dart';
import 'package:movie/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:movie/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Inisialisasi Animation Controller
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    // Pengecekan login setelah splash screen selesai
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 4)); // Delay animasi splash

    final prefs = await SharedPreferences.getInstance();
    final String? name = prefs.getString('userName');
    final String? email = prefs.getString('userEmail');
    final String? password = prefs.getString('userPassword');

    // Jika user sudah login, pindah ke ProfilePage
    if (name != null && email != null && password != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(
            name: name,
            email: email,
            password: password,
          ),
        ),
      );
    } else {
      // Jika belum login, pindah ke LoginPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.movie_filter,
                color: Colors.red,
                size: 100,
              ),
              const SizedBox(height: 20),
              const Text(
                'MovieMate',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
