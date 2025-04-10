import 'package:flutter/material.dart';
import 'package:movie/favorit.dart';
import 'package:movie/pengaturan.dart';
import 'package:movie/regist.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

class ProfilePage extends StatefulWidget {
  final String name;
  final String email;
  final String password;

  const ProfilePage({
    super.key,
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? userName;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _loadLoginData();
  }

  Future<void> _loadLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? widget.name;
      userEmail = prefs.getString('userEmail') ?? widget.email;
    });
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Arahkan ke halaman Login dan hapus riwayat navigasi
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        automaticallyImplyLeading: false, // Menghilangkan tombol back
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 90, color: Colors.grey),
              ),
              const SizedBox(height: 15),

              // Jika belum login
              if (userName == null || userEmail == null) ...[
                const Text(
                  'Anda belum login',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                _buildAuthButtons(),
              ]

              // Jika sudah login
              else ...[
                Text(
                  userName!,
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Text(
                  userEmail!,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 20),

                // Tombol Logout
                ElevatedButton(
                  onPressed: _logout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 12),
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                const SizedBox(height: 30),

                // Menu Tambahan: Film Favorit & Pengaturan
                _buildProfileOptions(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // Widget Tombol Login & Register
  Widget _buildAuthButtons() {
    return Column(
      children: [
        _buildButton(
          text: 'Login',
          color: Colors.blue,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          },
        ),
        const SizedBox(height: 10),
        _buildButton(
          text: 'Register',
          color: Colors.green,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RegisterPage()),
            );
          },
        ),
      ],
    );
  }

// Widget untuk Menampilkan Film Favorit & Pengaturan
  Widget _buildProfileOptions() {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.favorite, color: Colors.red),
          title: const Text(
            'Film Favorit',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          onTap: () {
            // Pindah ke halaman FavoritePage dengan mengirimkan likedFilms
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FavoritePage(),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.settings, color: Colors.grey),
          title: const Text(
            'Pengaturan',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SettingsPage(),
              ),
            );
            // Navigasi ke halaman pengaturan (Tambahkan halaman pengaturan jika diperlukan)
          },
        ),
      ],
    );
  }

  // Widget untuk Membuat Tombol dengan Warna & Teks
  Widget _buildButton(
      {required String text,
      required Color color,
      required VoidCallback onPressed}) {
    return SizedBox(
      width: 200,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
