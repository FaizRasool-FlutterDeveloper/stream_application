import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/search_controller.dart' as app_ctrl;
import 'search_filters.dart';
import 'search_results_grid.dart';
import 'search_suggestions.dart';
import 'search_trending.dart';
import 'search_popular.dart';
import 'search_history.dart';

class SearchPage extends StatelessWidget {
  SearchPage({super.key});

  final controller = Get.put(app_ctrl.SearchController());
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        controller.loadMore();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: "Search movies, TV shows...",
            border: InputBorder.none,
            isDense: true,
          ),
          onChanged: (v) {
            controller.query.value = v;
            controller.updateSuggestions(v);
          },
        ),
        actions: [
          Obx(() {
            if (controller.query.value.isEmpty) {
              return IconButton(
                icon: const Icon(Icons.mic),
                onPressed: () {},
              );
            } else {
              return IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  controller.query.value = '';
                  controller.results.clear();
                },
              );
            }
          })
        ],
      ),
      body: Column(
        children: [
          SearchFilters(controller: controller),
          Expanded(
            child: Obx(() {
              if (controller.isQueryEmpty) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PopularSearchesGrid(controller: controller),
                      const SizedBox(height: 16),
                      TrendingKeywords(controller: controller),
                      const SizedBox(height: 16),
                      SearchHistory(controller: controller),
                    ],
                  ),
                );
              }

              if (controller.suggestions.isNotEmpty &&
                  controller.results.isEmpty) {
                return SearchSuggestions(controller: controller);
              }

              return SearchResultsGrid(
                controller: controller,
                scrollController: scrollController,
              );
            }),
          ),
        ],
      ),
    );
  }
}
