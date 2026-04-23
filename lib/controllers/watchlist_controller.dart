import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WatchlistController extends GetxController {
  var watchlist = <Map<String, dynamic>>[].obs;
  static const String key = 'user_watchlist';

  SharedPreferences? _prefs;

  @override
  void onInit() {
    super.onInit();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    await load();
  }

  Future<void> load() async {
    final jsonString = _prefs?.getString(key);
    if (jsonString != null && jsonString.isNotEmpty) {
      try {
        final decoded = jsonDecode(jsonString) as List<dynamic>;
        watchlist.assignAll(decoded.map((e) => Map<String, dynamic>.from(e)));
      } catch (e) {
        print("Error loading watchlist: $e");
      }
    }
  }

  Future<void> add(Map<String, dynamic> item) async {
    final id = item['id'];
    final name = item['title'] ?? item['name'] ?? 'Unknown';

    if (!isInWatchlist(id)) {
      watchlist.add(item);
      await _save();
      Get.snackbar(
        'Added to Watchlist',
        '$name has been added successfully.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } else {
      Get.snackbar(
        'Already Added',
        '$name is already in your watchlist.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  Future<void> remove(dynamic id) async {
    final removedItem =
        watchlist.firstWhereOrNull((m) => m['id'] == id)?['title'] ??
            watchlist.firstWhereOrNull((m) => m['id'] == id)?['name'] ??
            'Item';
    watchlist.removeWhere((m) => m['id'] == id);
    await _save();

    Get.snackbar(
      'Removed from Watchlist',
      '$removedItem has been removed.',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  bool isInWatchlist(dynamic id) {
    return watchlist.any((m) => m['id'] == id);
  }

  Future<void> _save() async {
    await _prefs?.setString(key, jsonEncode(watchlist));
  }
}
