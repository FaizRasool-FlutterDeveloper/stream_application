import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/latest_tv_controller.dart';
import '../widgets/movie_card.dart';
import '../routes/app_routes.dart';

class LatestTVSeriesPage extends GetView<LatestTVController> {
  const LatestTVSeriesPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Latest TV Series')),
      body: Obx(() {
        if (controller.isLoading.value) return const Center(child: CircularProgressIndicator());
        final shows = controller.latestTVSeries;
        if (shows.isEmpty) return const Center(child: Text('No TV series found.'));
        return Column(children: [
          Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Latest TV Series', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            TextButton(onPressed: () => Get.toNamed(AppRoutes.seeMore, arguments: {'title': 'Latest TV Series', 'movies': shows}), child: const Text('See More'))
          ])),
          Expanded(child: GridView.builder(padding: const EdgeInsets.all(8), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.7, crossAxisSpacing: 8, mainAxisSpacing: 8), itemCount: shows.length, itemBuilder: (c, i) {
            final show = shows[i];
            return GestureDetector(onTap: () => Get.toNamed(AppRoutes.cardsDetails, arguments: {'movie': show, 'isMovie': false}), child: MovieCard(movie: show));
          }))
        ]);
      }),
    );
  }
}
