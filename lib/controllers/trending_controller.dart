import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TrendingController extends GetxController {
  var trendingMovies = <dynamic>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTrending();
  }

  Future<void> fetchTrending() async {
    final apiKey = dotenv.env['TMDB_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      isLoading.value = false;
      return;
    }
    try {
      isLoading(true);
      final url =
          'https://api.themoviedb.org/3/trending/movie/week?api_key=$apiKey';
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        trendingMovies.value = jsonDecode(res.body)['results'] ?? [];
      } else {
        Get.snackbar('Error', 'Failed to load trending movies');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }
}
