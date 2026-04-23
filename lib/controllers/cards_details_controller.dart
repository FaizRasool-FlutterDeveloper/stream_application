import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CardsDetailsController extends GetxController {
  /// Reactive fields
  var isLoading = true.obs;
  var castList = <Map<String, dynamic>>[].obs;
  var relatedList = <Map<String, dynamic>>[].obs;
  var youtubeTrailerKey = ''.obs;

  /// Reactive movie data (so Obx updates correctly)
  var movie = <String, dynamic>{}.obs;

  /// Determines if it's a movie or TV show
  var isMovie = true.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};

    // Make movie reactive
    movie.value = Map<String, dynamic>.from(args['movie'] ?? {});
    isMovie.value = args['isMovie'] ?? true;

    fetchAll();
  }

  Future<void> fetchAll() async {
    final apiKey = dotenv.env['TMDB_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      isLoading.value = false;
      return;
    }

    try {
      isLoading.value = true;
      await Future.wait([
        fetchCast(),
        fetchRelated(),
        fetchTrailer(),
      ]);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchTrailer() async {
    final apiKey = dotenv.env['TMDB_API_KEY'];
    final id = movie['id'];
    final type = isMovie.value ? 'movie' : 'tv';
    final url = 'https://api.themoviedb.org/3/$type/$id/videos?api_key=$apiKey';

    try {
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final results = data['results'] ?? [];
        final trailer = results.firstWhere(
          (v) => v['type'] == 'Trailer' && v['site'] == 'YouTube',
          orElse: () => {},
        );
        youtubeTrailerKey.value = trailer['key'] ?? '';
      }
    } catch (e) {
      print('Error fetching trailer: $e');
    }
  }

  Future<void> fetchCast() async {
    final apiKey = dotenv.env['TMDB_API_KEY'];
    final id = movie['id'];
    final type = isMovie.value ? 'movie' : 'tv';
    final url =
        'https://api.themoviedb.org/3/$type/$id/credits?api_key=$apiKey';

    try {
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        castList.assignAll(
            List<Map<String, dynamic>>.from((data['cast'] ?? []).take(10)));
      }
    } catch (e) {
      print('Error fetching cast: $e');
    }
  }

  Future<void> fetchRelated() async {
    final apiKey = dotenv.env['TMDB_API_KEY'];
    final id = movie['id'];
    final type = isMovie.value ? 'movie' : 'tv';
    final url =
        'https://api.themoviedb.org/3/$type/$id/similar?api_key=$apiKey';

    try {
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        relatedList.assignAll(
            List<Map<String, dynamic>>.from((data['results'] ?? []).take(10)));
      }
    } catch (e) {
      print('Error fetching related movies: $e');
    }
  }
}
