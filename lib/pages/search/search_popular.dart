import 'package:flutter/material.dart' hide SearchController;
import 'package:get/get.dart';
import '../../controllers/search_controller.dart';

class PopularSearchesGrid extends StatelessWidget {
  final SearchController controller;
  const PopularSearchesGrid({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.popular.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Popular Searches',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.popular.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.55,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemBuilder: (c, i) {
              final item = controller.popular[i];
              final title = item['title'] ?? item['name'] ?? '';
              final poster = item['poster_path'] != null
                  ? 'https://image.tmdb.org/t/p/w500${item['poster_path']}'
                  : '';
              return GestureDetector(
                onTap: () {
                  controller.query.value = title;
                  controller.startSearch();
                },
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
                    const SizedBox(height: 6),
                    Text(title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12)),
                  ],
                ),
              );
            },
          ),
        ],
      );
    });
  }
}
