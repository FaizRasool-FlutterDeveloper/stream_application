import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stream_application/services/search_services.dart';

class SearchController extends GetxController {
  final apiKey = dotenv.env['TMDB_API_KEY'];
  final SearchService _service = SearchService();

  // search
  var query = ''.obs;
  var results = <dynamic>[].obs;
  var isLoading = false.obs;
  var isLoadingMore = false.obs;

  var page = 1.obs;
  var hasMore = true.obs;

  // filter
  var filter = 'all'.obs;

  // extras
  var trending = <dynamic>[].obs;
  var popular = <dynamic>[].obs;
  var suggestions = <dynamic>[].obs;

  // search history using GetStorage
  GetStorage? _box;
  final String _historyKey = 'search_history';
  var history = <String>[].obs;
  final int historyLimit = 10;

  @override
  void onInit() {
    super.onInit();

    // Initialize storage safely
    _initStorage();

    // debounce typing
    debounce(query, (_) => startSearch(),
        time: const Duration(milliseconds: 350));

    // fetch popular/trending
    _loadTrendingAndPopular();
  }

  Future<void> _initStorage() async {
    try {
      if (GetStorage().hasData('initialized') == false) {
        await GetStorage.init();
      }
      _box = GetStorage();
      _loadHistory();
      _box?.write('initialized', true); // mark storage ready
      print("GetStorage ready in SearchController");
    } catch (e) {
      print("GetStorage failed in SearchController: $e");
      _box = null; // fallback: no storage
    }
  }

  // --- History ---
  void _loadHistory() {
    if (_box == null) return;
    final List? saved = _box!.read<List>(_historyKey);
    if (saved != null) {
      history.assignAll(saved.cast<String>());
    }
  }

  void addToHistory(String q) {
    if (q.trim().isEmpty || _box == null) return;
    final normalized = q.trim();
    history.removeWhere((e) => e.toLowerCase() == normalized.toLowerCase());
    history.insert(0, normalized);
    if (history.length > historyLimit) history.removeLast();
    _box!.write(_historyKey, history);
  }

  void clearHistory() {
    history.clear();
    _box?.remove(_historyKey);
  }

  // --- Trending & Popular ---
  Future<void> _loadTrendingAndPopular() async {
    try {
      final t = await _service.fetchTrending(type: 'movie', count: 12);
      trending.assignAll(t);

      final p = await _service.fetchPopular(type: 'movie', page: 1);
      popular.assignAll(p.take(12).toList());
    } catch (_) {}
  }

  // --- suggestions ---
  void updateSuggestions(String q) {
    if (q.trim().isEmpty) {
      suggestions.clear();
      return;
    }
    final lower = q.toLowerCase();
    final pool = <Map<String, dynamic>>[];

    for (final item in popular) {
      pool.add(
          {'type': 'popular', 'title': item['title'] ?? item['name'] ?? ''});
    }
    for (final item in trending) {
      pool.add(
          {'type': 'trending', 'title': item['title'] ?? item['name'] ?? ''});
    }

    final matches = pool
        .where((p) => (p['title'] as String).toLowerCase().contains(lower))
        .map((p) => p['title'])
        .toSet()
        .toList();

    final histMatches =
        history.where((h) => h.toLowerCase().contains(lower)).toList();

    suggestions.assignAll(
        [...histMatches, ...matches].map((e) => {'text': e}).toList());
  }

  // --- Search logic / pagination ---
  void changeFilter(String f) {
    filter.value = f;
    startSearch();
  }

  void startSearch() {
    page.value = 1;
    hasMore.value = true;
    results.clear();
    performSearch();
  }

  Future<void> performSearch() async {
    final q = query.value.trim();
    if (q.isEmpty) {
      results.clear();
      return;
    }

    updateSuggestions(q);

    if (!hasMore.value) return;

    if (page.value == 1) {
      isLoading(true);
    } else {
      isLoadingMore(true);
    }

    final base =
        filter.value == 'all' ? 'search/multi' : 'search/${filter.value}';
    final url =
        "https://api.themoviedb.org/3/$base?api_key=$apiKey&query=${Uri.encodeQueryComponent(q)}&page=${page.value}";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List newResults = data["results"] ?? [];
        if (page.value == 1) addToHistory(q);
        results.addAll(newResults);

        if (newResults.length < 20) {
          hasMore(false);
        } else {
          page.value++;
        }
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
      isLoadingMore(false);
    }
  }

  Future<void> loadMore() async {
    if (!isLoadingMore.value && hasMore.value) {
      await performSearch();
    }
  }

  bool get isQueryEmpty => query.value.trim().isEmpty;
}
