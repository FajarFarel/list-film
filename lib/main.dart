import 'package:flutter/material.dart';
import 'package:movie/about.dart';
import 'package:movie/home.dart';
import 'package:movie/profil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animations/animations.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:movie/like_controller.dart';
import 'package:movie/splashscreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(LikeController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MovieMate App',
      theme: ThemeData(
        brightness: Brightness.dark,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const SplashScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  final String email;
  final String name;
  final String password;

  const MainScreen({Key? key, required this.email, required this.name, required this.password  }) : super(key: key);

  // Future<Widget> _getinitialPage() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final name = prefs.getString('userName') ?? '';
  //   final email = prefs.getString('userEmail') ?? '';
  //   final password = prefs.getString('userPassword') ?? '';
  //   return HomePage(name: name, email: email, password: password);
  // }

  // @override
  // Widget build(BuildContext contex) {
  //   return MaterialApp(
  //     debugShowCheckedModeBanner: false,
  //     title: 'MovieMate App',
  //     theme: ThemeData(
  //       brightness: Brightness.dark,
  //       textTheme: GoogleFonts.poppinsTextTheme(),
  //     ),
  //   )
  // }

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _pages = [
    const HomePage(name: '', email: '', password: ''),
    const ProfilePage(name: '', email: '', password: ''),
    const AboutPage(),
  ];

  // Data film dan tanggal tayang
  final List<Map<String, dynamic>> movies = [
    {
      "title": "Film A",
      "releaseDate": DateTime(2025, 2, 20),
    },
    {
      "title": "Film B",
      "releaseDate": DateTime(2025, 2, 25),
    },
    {
      "title": "Film C",
      "releaseDate": DateTime(2025, 2, 18),
    },
  ];

  bool _showPopup = false;
  String _popupMessage = "";

  @override
  void initState() {
    super.initState();
    _checkForTodayOrUpcomingRelease();
  }

  void _checkForTodayOrUpcomingRelease() {
    for (var movie in movies) {
      final releaseDate = movie["releaseDate"] as DateTime;
      final now = DateTime.now();
      final difference = releaseDate.difference(now).inDays;

      if (releaseDate.year == now.year &&
          releaseDate.month == now.month &&
          releaseDate.day == now.day) {
        // Tayang Hari Ini
        setState(() {
          _popupMessage = "${movie["title"]} Tayang Hari Ini!";
          _showPopup = true;
        });
      } else if (difference > 0 && difference <= 7) {
        // Countdown untuk film yang tayang dalam 7 hari ke depan
        setState(() {
          _popupMessage = "${movie["title"]} Tayang $difference hari lagi!";
          _showPopup = true;
        });
      }

      if (_showPopup) {
        Timer(const Duration(seconds: 20), () {
          setState(() {
            _showPopup = false;
          });
        });
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return PageTransitionSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation, secondaryAnimation) {
                  return FadeThroughTransition(
                    animation: animation,
                    secondaryAnimation: secondaryAnimation,
                    child: child,
                  );
                },
                child: _pages[index],
              );
            },
            itemCount: _pages.length,
          ),

          // Pop-up Countdown
          if (_showPopup)
            Positioned(
              bottom: 20,
              right: 20,
              child: Material(
                color: Colors.transparent,
                child: AnimatedOpacity(
                  opacity: _showPopup ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 500),
                  child: Container(
                    width: 250,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey[800],
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Notifikasi Film',
                                style: TextStyle(
                                  color: Colors.deepPurpleAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _popupMessage,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _showPopup = false;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.deepPurpleAccent,
        unselectedItemColor: Colors.grey,
        elevation: 10,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.movie, size: 28),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 28),
            label: 'Me',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info, size: 28),
            label: 'About',
          ),
        ],
      ),
    );
  }
}