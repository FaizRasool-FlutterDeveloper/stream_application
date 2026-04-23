import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stream_application/pages/movies_page.dart';
import '../controllers/home_controller.dart';
import '../controllers/navigation_controller.dart';
import '../routes/app_routes.dart';
import '../widgets/movie_card.dart';
import 'tv_series_page.dart';
import 'watch_list_page.dart';
import 'more_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final homeController = Get.put(HomeController());
  final navController = Get.put(NavigationController());

  final pages = [
    const HomeContentPage(),
    MoviesPage(),
    TvSeriesPage(),
    WatchListPage(),
    MorePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        body: IndexedStack(
          index: navController.currentIndex.value,
          children: pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: navController.currentIndex.value,
          onTap: navController.changeIndex,
          backgroundColor: Colors.black,
          selectedItemColor: Colors.yellow,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.tv), label: 'Movies'),
            BottomNavigationBarItem(icon: Icon(Icons.tv), label: 'TV Series'),
            BottomNavigationBarItem(
                icon: Icon(Icons.bookmark), label: 'Watchlist'),
            BottomNavigationBarItem(
                icon: Icon(Icons.more_horiz), label: 'More'),
          ],
        ),
      );
    });
  }
}

// ------------------- Home Content -------------------

class HomeContentPage extends GetView<HomeController> {
  const HomeContentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vortax'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Get.toNamed('/search'),
          ),
          IconButton(icon: const Icon(Icons.account_circle), onPressed: () {}),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (controller.trending.isNotEmpty)
                CarouselSection(items: controller.trending),
              if (controller.trending.isNotEmpty)
                Section(
                    title: 'Trending',
                    items: controller.trending,
                    previewCount: 20),
              if (controller.popular.isNotEmpty)
                Section(
                    title: 'Popular',
                    items: controller.popular,
                    previewCount: 20),
              if (controller.latestMovies.isNotEmpty)
                Section(
                    title: 'Latest Movies',
                    items: controller.latestMovies,
                    previewCount: 20),
              if (controller.latestTV.isNotEmpty)
                Section(
                    title: 'Latest TV Series',
                    items: controller.latestTV,
                    previewCount: 20),
            ],
          ),
        );
      }),
    );
  }
}

// ------------------- Widgets -------------------

// Carousel
class CarouselSection extends StatelessWidget {
  final List<dynamic> items;
  const CarouselSection({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: CarouselSlider.builder(
        itemCount: items.length,
        itemBuilder: (context, index, realIndex) {
          final movie = items[index];
          final poster = movie['poster_path'] != null
              ? 'https://image.tmdb.org/t/p/w500${movie['poster_path']}'
              : '';
          final title = movie['title'] ?? movie['name'] ?? 'Unknown';
          return CarouselItem(movie: movie, poster: poster, title: title);
        },
        options: CarouselOptions(
          height: Get.height * 0.48,
          autoPlay: true,
          enlargeCenterPage: true,
          viewportFraction: 0.8,
          enableInfiniteScroll: true,
        ),
      ),
    );
  }
}

class CarouselItem extends StatelessWidget {
  final dynamic movie;
  final String poster;
  final String title;
  const CarouselItem(
      {super.key,
      required this.movie,
      required this.poster,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.cardsDetails,
          arguments: {'movie': movie, 'isMovie': true}),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            poster.isNotEmpty
                ? Image.network(poster, fit: BoxFit.cover)
                : Container(color: Colors.grey),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                color: Colors.black54,
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Section widget
class Section extends StatelessWidget {
  final String title;
  final List<dynamic> items;
  final int previewCount;
  const Section(
      {super.key,
      required this.title,
      required this.items,
      this.previewCount = 20});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: title, items: items),
        HorizontalSection(items: items.take(previewCount).toList()),
        const SizedBox(height: 16),
      ],
    );
  }
}

// Section header
class SectionHeader extends StatelessWidget {
  final String title;
  final List<dynamic> items;
  const SectionHeader({super.key, required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          TextButton(
            onPressed: () => Get.toNamed('/see-more',
                arguments: {'title': title, 'movies': items}),
            child: const Text('See More'),
          ),
        ],
      ),
    );
  }
}

// Horizontal section
class HorizontalSection extends StatelessWidget {
  final List<dynamic> items;
  const HorizontalSection({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemBuilder: (context, index) {
          final movie = items[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: GestureDetector(
              onTap: () => Get.toNamed(
                AppRoutes.cardsDetails,
                arguments: {'movie': movie, 'isMovie': true},
              ),
              child: SizedBox(
                width: 140,
                child: MovieCard(movie: movie),
              ),
            ),
          );
        },
      ),
    );
  }
}
