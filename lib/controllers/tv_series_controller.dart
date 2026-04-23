import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TvSeriesController extends GetxController {
  var tvSeries = <dynamic>[].obs;
  var isLoading = true.obs;

  final String apiKey = dotenv.env['TMDB_API_KEY'] ?? '';

  @override
  void onInit() {
    super.onInit();
    fetchTvSeries();
  }

  void fetchTvSeries() async {
    try {
      isLoading.value = true;

      // Fetch popular TV series
      final url =
          'https://api.themoviedb.org/3/tv/popular?api_key=$apiKey&language=en-US&page=1';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        tvSeries.assignAll(data['results']);
      } else {
        print('Error fetching TV series: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
