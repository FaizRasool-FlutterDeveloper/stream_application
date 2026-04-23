import 'package:flutter/material.dart' hide SearchController;
import 'package:get/get.dart';
import '../../controllers/search_controller.dart';
import 'search_grid_item.dart';

class SearchResultsGrid extends StatelessWidget {
  final SearchController controller;
  final ScrollController scrollController;
  const SearchResultsGrid(
      {super.key, required this.controller, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.results.isEmpty) {
        return const Center(child: Text("No results found"));
      }

      return GridView.builder(
        controller: scrollController,
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.55,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemCount: controller.results.length +
            (controller.isLoadingMore.value ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == controller.results.length) {
            return const Center(child: CircularProgressIndicator());
          }

          final item = controller.results[index];
          final poster = item['poster_path'] != null
              ? 'https://image.tmdb.org/t/p/w500${item['poster_path']}'
              : '';
          final title = item['title'] ?? item['name'] ?? 'Unknown';

          return AnimatedGridItem(
            index: index,
            child: GestureDetector(
              onTap: () => Get.toNamed('/details', arguments: {'movie': item}),
              child: Column(
                children: [
                  Expanded(
                    child: poster.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              poster,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[900],
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                  ),
                  const SizedBox(height: 5),
                  Text(title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
