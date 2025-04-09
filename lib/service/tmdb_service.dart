// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../film.dart';

// class TMDBService {
//   static const String apiKey = 'GANTI_DENGAN_API_KEY_KAMU';
//   static const String baseUrl = 'https://api.themoviedb.org/3';

//   static Future<List<Film>> getPopularMovies() async {
//     final response = await http.get(
//       Uri.parse('$baseUrl/movie/popular?api_key=$apiKey&language=en-US&page=1'),
//     );

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       List<dynamic> results = data['results'];
//       return results.map((json) => Film.fromJson(json)).toList();
//     } else {
//       throw Exception('Gagal mengambil data dari TMDb');
//     }
//   }
// }
