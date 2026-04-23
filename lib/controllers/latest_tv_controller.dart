import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LatestTVController extends GetxController {
  var latestTVSeries = <dynamic>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLatestTV();
  }

  Future<void> fetchLatestTV() async {
    final apiKey = dotenv.env['TMDB_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      isLoading.value = false;
      return;
    }
    try {
      isLoading(true);
      final url =
          'https://api.themoviedb.org/3/discover/tv?api_key=$apiKey&language=en-US&sort_by=first_air_date.desc&page=1';
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        latestTVSeries.value = jsonDecode(res.body)['results'] ?? [];
      } else {
        Get.snackbar('Error', 'Failed to load latest TV series');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }
}
