// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controllers/movies_controller.dart';

// class MoviesPage extends GetView<MoviesController> {
//   const MoviesPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Movies')),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         return ListView.builder(
//           itemCount: controller.movies.length,
//           itemBuilder: (context, index) {
//             final movie = controller.movies[index];
//             return ListTile(
//               title: Text(
//                 movie['title'],
//               ),
//               onTap: () => Get.toNamed('/cards-details',
//                   arguments: {'movie': movie, 'isMovie': true}),
//             );
//           },
//         );
//       }),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/movies_controller.dart';

class MoviesPage extends GetView<MoviesController> {
  const MoviesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Movies')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.movies.isEmpty) {
          return const Center(child: Text('No movies available.'));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 movies per row
            childAspectRatio: 0.65, // adjust height
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: controller.movies.length,
          itemBuilder: (context, index) {
            final movie = controller.movies[index];
            final poster = movie['poster_path'] != null
                ? 'https://image.tmdb.org/t/p/w500${movie['poster_path']}'
                : '';

            return GestureDetector(
              onTap: () => Get.toNamed('/cards-details',
                  arguments: {'movie': movie, 'isMovie': true}),
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
                    movie['title'] ?? 'No Title',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  if (movie['vote_average'] != null)
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.yellow, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          movie['vote_average'].toString(),
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
