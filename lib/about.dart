import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About This App', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        centerTitle: true,
        elevation: 4,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo atau Icon
            Icon(Icons.movie, size: 80, color: Colors.deepPurple),
            const SizedBox(height: 10),
            
            // Judul
            Text(
              "About This App",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                foreground: Paint()
                  ..shader = LinearGradient(
                    colors: [Colors.deepPurple, Colors.purpleAccent],
                  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 50.0)),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            
            // Deskripsi Aplikasi
            const Text(
              "Selamat datang di Film App, aplikasi katalog film yang menyediakan berbagai genre untuk Anda nikmati. "
              "Temukan film favorit Anda dengan mudah dan dapatkan informasi terbaru tentang film pilihan.",
              style: TextStyle(fontSize: 16, height: 1.5,
              color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Divider untuk pemisah
            const Divider(thickness: 1.2, color: Colors.grey),
            const SizedBox(height: 20),

            // Informasi Developer dalam Card
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      "Dikembangkan oleh",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "SagiScorp",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
                      color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "© 2025 SagiScorp. All Rights Reserved.",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
