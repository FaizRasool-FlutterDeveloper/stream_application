import 'package:flutter/material.dart' hide SearchController;
import 'package:get/get.dart';
import '../../controllers/search_controller.dart';

class TrendingKeywords extends StatelessWidget {
  final SearchController controller;
  const TrendingKeywords({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.trending.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Trending',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: controller.trending.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final t = controller.trending[i];
                final title = t['title'] ?? t['name'] ?? '';
                return ActionChip(
                  label: Text(title, overflow: TextOverflow.ellipsis),
                  onPressed: () {
                    controller.query.value = title;
                    controller.startSearch();
                  },
                );
              },
            ),
          ),
        ],
      );
    });
  }
}
