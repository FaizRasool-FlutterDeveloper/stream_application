import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/popular_controller.dart';
import '../widgets/movie_card.dart';
import '../routes/app_routes.dart';

class PopularPage extends GetView<PopularController> {
  const PopularPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Popular')),
      body: Obx(() {
        if (controller.isLoading.value) return const Center(child: CircularProgressIndicator());
        final movies = controller.popularMovies;
        if (movies.isEmpty) return const Center(child: Text('No popular movies found.'));
        return Column(children: [
          Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Popular Movies', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            TextButton(onPressed: () => Get.toNamed(AppRoutes.seeMore, arguments: {'title': 'Popular Movies', 'movies': movies}), child: const Text('See More'))
          ])),
          Expanded(child: GridView.builder(padding: const EdgeInsets.all(8), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.7, crossAxisSpacing: 8, mainAxisSpacing: 8), itemCount: movies.length, itemBuilder: (c, i) {
            final movie = movies[i];
            return GestureDetector(onTap: () => Get.toNamed(AppRoutes.cardsDetails, arguments: {'movie': movie, 'isMovie': true}), child: MovieCard(movie: movie));
          }))
        ]);
      }),
    );
  }
}
