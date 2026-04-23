import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HomeController extends GetxController {
  final apiKey = dotenv.env['TMDB_API_KEY'];

  var trending = <dynamic>[].obs;
  var popular = <dynamic>[].obs;
  var latestMovies = <dynamic>[].obs;
  var latestTV = <dynamic>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAll();
  }

  Future<void> fetchAll() async {
    if (apiKey == null || apiKey!.isEmpty) {
      isLoading.value = false;
      return;
    }
    isLoading(true);
    try {
      final trendingUrl =
          'https://api.themoviedb.org/3/trending/movie/week?api_key=$apiKey';
      final popularUrl =
          'https://api.themoviedb.org/3/movie/popular?api_key=$apiKey';
      final latestMoviesUrl =
          'https://api.themoviedb.org/3/movie/now_playing?api_key=$apiKey';
      final latestTVUrl =
          'https://api.themoviedb.org/3/tv/on_the_air?api_key=$apiKey';

      final responses = await Future.wait([
        http.get(Uri.parse(trendingUrl)),
        http.get(Uri.parse(popularUrl)),
        http.get(Uri.parse(latestMoviesUrl)),
        http.get(Uri.parse(latestTVUrl)),
      ]);

      trending.value = _parse(responses[0]);
      popular.value = _parse(responses[1]);
      latestMovies.value = _parse(responses[2]);
      latestTV.value = _parse(responses[3]);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  List<dynamic> _parse(http.Response res) {
    try {
      if (res.statusCode == 200) {
        final json = jsonDecode(res.body);
        return json['results'] ?? [];
      }
    } catch (_) {}
    return [];
  }
}
