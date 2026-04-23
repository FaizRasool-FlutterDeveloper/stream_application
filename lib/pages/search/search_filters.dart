import 'package:flutter/material.dart' hide SearchController;
import 'package:get/get.dart';
import '../../controllers/search_controller.dart';

class SearchFilters extends StatelessWidget {
  final SearchController controller;
  const SearchFilters({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        children: [
          _filterChip("all", "All"),
          _filterChip("movie", "Movies"),
          _filterChip("tv", "TV Shows"),
          _filterChip("person", "People"),
        ],
      ),
    );
  }

  Widget _filterChip(String key, String label) {
    return Obx(() {
      final selected = controller.filter.value == key;
      return Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: ChoiceChip(
          label: Text(label),
          selected: selected,
          onSelected: (_) => controller.changeFilter(key),
          selectedColor: Colors.yellow,
          backgroundColor: Colors.grey[800],
          labelStyle: TextStyle(
              color: selected ? Colors.black : Colors.white,
              fontWeight: FontWeight.bold),
        ),
      );
    });
  }
}
