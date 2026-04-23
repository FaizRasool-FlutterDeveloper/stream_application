import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';

class SeeMorePage extends StatelessWidget {
  const SeeMorePage({super.key});
  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final title = args['title'] ?? 'See More';
    final movies = args['movies'] as List<dynamic>? ?? [];

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: movies.isNotEmpty
          ? GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.7, crossAxisSpacing: 10, mainAxisSpacing: 10),
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return GestureDetector(
                  onTap: () => Get.toNamed(AppRoutes.cardsDetails, arguments: {'movie': movie, 'isMovie': (movie['media_type'] ?? 'movie') != 'tv' ? true : false}),
                  child: Column(children: [
                    Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.network(movie['poster_path'] != null ? 'https://image.tmdb.org/t/p/w500${movie['poster_path']}' : (movie['poster'] ?? ''), width: double.infinity, fit: BoxFit.cover))),
                    const SizedBox(height: 5),
                    Text(movie['title'] ?? movie['name'] ?? 'Unknown', maxLines: 2, overflow: TextOverflow.ellipsis),
                  ]),
                );
              })
          : const Center(child: Text('No data available')),
    );
  }
}
