import 'package:flutter/material.dart' hide SearchController;
import 'package:get/get.dart';
import '../../controllers/search_controller.dart';

class SearchSuggestions extends StatelessWidget {
  final SearchController controller;
  const SearchSuggestions({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.suggestions.isEmpty) return const SizedBox.shrink();

      return ListView.separated(
        itemCount: controller.suggestions.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (c, i) {
          final s = controller.suggestions[i];
          return ListTile(
            leading: const Icon(Icons.history),
            title: Text(s['text'] ?? ''),
            onTap: () {
              controller.query.value = s['text'] ?? '';
              controller.startSearch();
            },
          );
        },
      );
    });
  }
}
