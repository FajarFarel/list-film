import 'package:flutter/material.dart';
import 'package:movie/datafilm.dart'; // Pastikan import ini benar
import 'package:get/get.dart';
import 'package:movie/like_controller.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final LikeController likeController = Get.find<LikeController>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadFavoriteFilms();
  }

  void _loadFavoriteFilms() {
    likeController.loadLikedFilms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Film Favorit'),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Obx(() {
        final likedFilms = likeController.likedFilms;
        final favoriteMovies =
            films.where((movie) => likedFilms.contains(movie.judul)).toList();

        if (favoriteMovies.isEmpty) {
          return const Center(
            child: Text(
              'Belum ada film favorit',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        return ListView.builder(
          itemCount: favoriteMovies.length,
          itemBuilder: (context, index) {
            final movie = favoriteMovies[index];
            return ListTile(
              onTap: () {
                // Tambahkan navigasi ke detail film jika diperlukan
              },
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  movie.networkimage,
                  width: 50,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(   
                movie.judul,
                style: const TextStyle(color: Colors.white),
              ),  
              subtitle: Text(
                movie.genre,
                style: const TextStyle(color: Colors.white70),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  likeController.toggleLike(movie.judul);
                },
              ),
            );
          },
        );
      }),
    );
  }
}
