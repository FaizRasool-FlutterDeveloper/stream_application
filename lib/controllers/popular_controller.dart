import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PopularController extends GetxController {
  var popularMovies = <dynamic>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPopular();
  }

  Future<void> fetchPopular() async {
    final apiKey = dotenv.env['TMDB_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      isLoading.value = false;
      return;
    }
    try {
      isLoading(true);
      final url =
          'https://api.themoviedb.org/3/movie/popular?api_key=$apiKey&language=en-US&page=1';
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        popularMovies.value = jsonDecode(res.body)['results'] ?? [];
      } else {
        Get.snackbar('Error', 'Failed to load popular movies');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }
}
