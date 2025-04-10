import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LikeController extends GetxController {
  var likedFilms = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadLikedFilms();
  }

  Future<void> loadLikedFilms() async {
    final prefs = await SharedPreferences.getInstance();
    likedFilms.value = prefs.getStringList('likedFilms') ?? [];
  }

  Future<void> toggleLike(String judulFilm) async {
    final prefs = await SharedPreferences.getInstance();

    if (likedFilms.contains(judulFilm)) {
      likedFilms.remove(judulFilm);
    } else {
      likedFilms.add(judulFilm);
    }

    await prefs.setStringList('likedFilms', likedFilms);
    likedFilms.refresh(); // Refresh untuk update UI
  }

  bool isLiked(String judulFilm) {
    return likedFilms.contains(judulFilm);
  }
}
