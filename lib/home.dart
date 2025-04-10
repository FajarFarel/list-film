import 'package:flutter/material.dart';
import 'package:movie/film.dart';
import 'datafilm.dart';
import 'package:movie/like_controller.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  final String name;
  final String email;
  final String password;

  const HomePage({
    super.key,
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Film> _films = films;
  String _searchQuery = '';
  final FocusNode _searchFocusNode = FocusNode();
  final LikeController likeController = Get.find<LikeController>();

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Mengelompokkan film berdasarkan genre atau hasil pencarian
    Map<String, List<Film>> filmsByGenre = {};
    List<Film> filteredFilms = _films.where((film) {
      return film.judul.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    // Jika tidak dalam pencarian, kelompokkan berdasarkan genre
    if (_searchQuery.isEmpty) {
      for (var film in _films) {
        if (!filmsByGenre.containsKey(film.genre)) {
          filmsByGenre[film.genre] = [];
        }
        filmsByGenre[film.genre]!.add(film);
      }
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: (_searchQuery.isNotEmpty || _searchFocusNode.hasFocus)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _searchQuery = '';
                    _searchFocusNode.unfocus();
                  });
                },
              )
            : null,
        title: const Text(
          'Movie List',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                focusNode: _searchFocusNode,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[800],
                  prefixIcon: const Icon(Icons.search, color: Colors.white70),
                  hintText: 'Search...',
                  hintStyle: const TextStyle(color: Colors.white54),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
            // List Film
            if (_searchFocusNode.hasFocus && _searchQuery.isEmpty)
              const SizedBox.shrink()
            else if (_searchQuery.isNotEmpty)
              // Hasil Pencarian
              Column(
                children: filteredFilms.map((film) {
                  return ListTile(
                    onTap: () => _showFilmDetail(context, film),
                    leading: Image.network(
                      film.networkimage,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(
                      film.judul,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      film.genre,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  );
                }).toList(),
              )
            else
              // List Film Berdasarkan Genre
              Column(
                children: filmsByGenre.entries.map((entry) {
                  String genre = entry.key;
                  List<Film> filmsInGenre = entry.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          genre,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ), 
                // /List Film
                      SizedBox(
                        height: 250,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: filmsInGenre.length,
                          itemBuilder: (context, index) {
                            Film film = filmsInGenre[index];
                            return Container(
                              width: 160,
                              margin: const EdgeInsets.only(right: 12),
                              child: InkWell(
                                onTap: () => _showFilmDetail(context, film),
                                borderRadius: BorderRadius.circular(16),
                                splashColor: Colors.black26,
                                child: Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: Image.network(
                                          film.networkimage,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned.fill(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.bottomCenter,
                                              end: Alignment.topCenter,
                                              colors: [
                                                Colors.black.withOpacity(0.7),
                                                Colors.transparent
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 12,
                                        left: 12,
                                        right: 12,
                                        child: Text(
                                          film.judul,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            shadows: [
                                              Shadow(
                                                  blurRadius: 3,
                                                  color: Colors.black),
                                            ],
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  void _showFilmDetail(BuildContext context, Film film) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gambar Film
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      film.networkimage,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Judul Film
                  Text(
                    film.judul,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  // Genre Film
                  Text(
                    film.genre,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Sinopsis Film
                  Text(
                    film.deskripsi,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Tombol Like
                  Center(
                    child: Obx(() {
                      final isLiked = likeController.isLiked(film.judul);
                      return IconButton(
                        icon: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? Colors.red : Colors.white,
                          size: 30,
                        ),
                        onPressed: () {
                          likeController.toggleLike(film.judul);
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
