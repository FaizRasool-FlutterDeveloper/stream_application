import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SearchService {
  final String? apiKey = dotenv.env['TMDB_API_KEY'];
  final String base = 'https://api.themoviedb.org/3';

  Future<List> fetchTrending({String type = 'movie', int count = 10}) async {
    if (apiKey == null) return [];
    final url = '$base/trending/$type/week?api_key=$apiKey';
    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      final j = jsonDecode(res.body);
      return (j['results'] ?? []).take(count).toList();
    }
    return [];
  }

  Future<List> fetchPopular({String type = 'movie', int page = 1}) async {
    if (apiKey == null) return [];
    final url = '$base/$type/popular?api_key=$apiKey&page=$page';
    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      final j = jsonDecode(res.body);
      return (j['results'] ?? []);
    }
    return [];
  }
}
