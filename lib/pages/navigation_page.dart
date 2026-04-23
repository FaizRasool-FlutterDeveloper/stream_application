import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stream_application/pages/more_page.dart';
import 'package:stream_application/pages/movies_page.dart';
import 'package:stream_application/pages/tv_series_page.dart';
import 'package:stream_application/pages/watch_list_page.dart';
import '../controllers/navigation_controller.dart';

class NavigationPage extends GetView<NavigationController> {
  NavigationPage({super.key});

  final pages = const [
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
          index: controller.currentIndex.value,
          children: pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeIndex,
          backgroundColor: Colors.black,
          selectedItemColor: Colors.yellow,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.movie), label: 'Movies'),
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
