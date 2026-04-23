// import 'package:get/get.dart';

// class MoviesController extends GetxController {
//   var movies = [].obs;
//   var isLoading = true.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     fetchMovies();
//   }

//   void fetchMovies() async {
//     await Future.delayed(const Duration(seconds: 1));
//     movies.assignAll([
//       {'title': 'Inception', 'id': 1},
//       {'title': 'The Dark Knight', 'id': 2},
//       {'title': 'Interstellar', 'id': 3},
//     ]);
//     isLoading.value = false;
//   }
// }
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MoviesController extends GetxController {
  var movies = <dynamic>[].obs;
  var isLoading = true.obs;

  final String apiKey = dotenv.env['TMDB_API_KEY'] ?? '';

  @override
  void onInit() {
    super.onInit();
    fetchMovies();
  }

  void fetchMovies() async {
    try {
      isLoading.value = true;

      final url =
          'https://api.themoviedb.org/3/movie/popular?api_key=$apiKey&language=en-US&page=1';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        movies.assignAll(data['results']);
      } else {
        print('Error fetching movies: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
