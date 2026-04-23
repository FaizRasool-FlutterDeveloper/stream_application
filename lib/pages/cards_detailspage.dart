import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../controllers/cards_details_controller.dart';
import '../controllers/watchlist_controller.dart';
import 'trailer_page.dart'; // Import the new trailer page

class CardsDetailsPage extends GetView<CardsDetailsController> {
  const CardsDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final watchlist = Get.find<WatchlistController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          controller.movie['title'] ?? controller.movie['name'] ?? 'Details',
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 300,
                width: double.infinity,
                color: Colors.white,
              ),
            ),
          );
        }

        final movie = controller.movie;
        final poster = movie['poster_path'] != null
            ? 'https://image.tmdb.org/t/p/w500${movie['poster_path']}'
            : (movie['poster'] ?? '');
        final description =
            movie['overview'] ?? movie['description'] ?? 'No description';
        final releaseDate =
            movie['release_date'] ?? movie['first_air_date'] ?? 'N/A';
        final rating =
            movie['vote_average']?.toString() ?? movie['rating'] ?? 'N/A';

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (poster.isNotEmpty)
                Image.network(poster,
                    width: double.infinity, fit: BoxFit.cover),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie['title'] ?? movie['name'] ?? '',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text('Release Date: $releaseDate'),
                    Text('Ratings: ⭐ $rating'),
                    const SizedBox(height: 10),
                    Text(description),
                    const SizedBox(height: 20),

                    // 🎬 Watch Trailer Button
                    ElevatedButton(
                      onPressed: () {
                        final key = controller.youtubeTrailerKey.value;
                        if (key.isNotEmpty) {
                          Get.to(() => TrailerPage(videoKey: key));
                        } else {
                          Get.snackbar('Trailer', 'Trailer not available');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow,
                      ),
                      child: const Text(
                        'Watch Now',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // 🎞️ Watchlist Button
                    Obx(() {
                      final isSaved =
                          watchlist.isInWatchlist(controller.movie['id']);
                      return ElevatedButton.icon(
                        onPressed: () {
                          if (isSaved) {
                            watchlist.remove(controller.movie['id']);
                          } else {
                            watchlist.add(
                                Map<String, dynamic>.from(controller.movie));
                          }
                        },
                        icon: Icon(isSaved ? Icons.check : Icons.add),
                        label: Text(isSaved ? 'Saved' : 'Add to Watchlist'),
                      );
                    }),

                    const SizedBox(height: 20),

                    // 👥 Cast Section
                    if (controller.castList.isNotEmpty) ...[
                      const Text(
                        'Cast',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.castList.length,
                          itemBuilder: (c, i) {
                            final cast = controller.castList[i];
                            final img = cast['profile_path'] != null
                                ? 'https://image.tmdb.org/t/p/w200${cast['profile_path']}'
                                : '';
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                radius: 30,
                                backgroundImage:
                                    img.isNotEmpty ? NetworkImage(img) : null,
                                child: img.isEmpty
                                    ? const Icon(Icons.person)
                                    : null,
                              ),
                            );
                          },
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),

                    // 🎥 Related Section
                    if (controller.relatedList.isNotEmpty) ...[
                      const Text(
                        'Related',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.relatedList.length,
                          itemBuilder: (c, i) {
                            final r = controller.relatedList[i];
                            final img = r['poster_path'] != null
                                ? 'https://image.tmdb.org/t/p/w200${r['poster_path']}'
                                : (r['poster'] ?? '');
                            return GestureDetector(
                              onTap: () => Get.toNamed('/cards-details',
                                  arguments: {'movie': r, 'isMovie': true}),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    if (img.isNotEmpty)
                                      Image.network(
                                        img,
                                        width: 100,
                                        height: 140,
                                        fit: BoxFit.cover,
                                      ),
                                    const SizedBox(height: 6),
                                    SizedBox(
                                      width: 100,
                                      child: Text(
                                        r['title'] ?? r['name'] ?? 'Unknown',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
