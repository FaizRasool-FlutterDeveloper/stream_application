import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/watchlist_controller.dart';
import '../routes/app_routes.dart';

class WatchListPage extends GetView<WatchlistController> {
  const WatchListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Watchlist')),
      body: Obx(() {
        final list = controller.watchlist;
        if (list.isEmpty) {
          return const Center(child: Text('No items in watchlist'));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.65,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: list.length,
          itemBuilder: (c, i) {
            final movie = list[i];
            final poster = movie['poster_path'] != null
                ? 'https://image.tmdb.org/t/p/w500${movie['poster_path']}'
                : (movie['poster'] ?? '');
            final title = movie['title'] ?? movie['name'] ?? 'Unknown';

            return GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.cardsDetails, arguments: {
                  'movie': movie,
                  'isMovie': movie.containsKey('title')
                });
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: poster.isNotEmpty
                              ? Image.network(poster,
                                  width: double.infinity, fit: BoxFit.cover)
                              : Container(color: Colors.grey),
                        ),
                        Positioned(
                          bottom: 4,
                          right: 4,
                          child: CircleAvatar(
                            backgroundColor: Colors.white.withOpacity(0.8),
                            radius: 16,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.delete, color: Colors.red),
                              iconSize: 20,
                              onPressed: () => controller.remove(movie['id']),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
