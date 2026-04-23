import 'package:flutter/material.dart' hide SearchController;
import 'package:get/get.dart';
import '../../controllers/search_controller.dart';

class SearchHistory extends StatelessWidget {
  final SearchController controller;
  const SearchHistory({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.history.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Recent Searches',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: controller.clearHistory,
                child: const Text('Clear'),
              )
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: controller.history
                .map((h) => ActionChip(
                      label: Text(h),
                      onPressed: () {
                        controller.query.value = h;
                        controller.startSearch();
                      },
                    ))
                .toList(),
          ),
        ],
      );
    });
  }
}
