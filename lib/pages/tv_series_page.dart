import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/tv_series_controller.dart';

class TvSeriesPage extends GetView<TvSeriesController> {
  const TvSeriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TV Series')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.tvSeries.isEmpty) {
          return const Center(child: Text('No TV series available.'));
        }

        // GridView inside Expanded to allow full scroll
        return GridView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: controller.tvSeries.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 series per row
            childAspectRatio: 0.65, // adjust height of each card
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            final show = controller.tvSeries[index];
            final poster = show['poster_path'] != null
                ? 'https://image.tmdb.org/t/p/w500${show['poster_path']}'
                : '';

            return GestureDetector(
              onTap: () => Get.toNamed('/cards-details',
                  arguments: {'movie': show, 'isMovie': false}),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  poster.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            poster,
                            fit: BoxFit.cover,
                            height: 180,
                            width: double.infinity,
                          ),
                        )
                      : Container(
                          height: 180,
                          width: double.infinity,
                          color: Colors.grey,
                        ),
                  const SizedBox(height: 8),
                  Text(
                    show['name'] ?? 'No Title',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  if (show['vote_average'] != null)
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.yellow, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          show['vote_average'].toString(),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
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
