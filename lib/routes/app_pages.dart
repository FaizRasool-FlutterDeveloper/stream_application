import 'package:get/get.dart';
import 'package:stream_application/controllers/cards_details_controller.dart';
import 'package:stream_application/pages/navigation_page.dart';
import 'package:stream_application/pages/search/search_page.dart';
import '../pages/home_page.dart';
import '../pages/popular_page.dart';
import '../pages/trending_movies_page.dart';
import '../pages/latest_movies_page.dart';
import '../pages/latest_tv_series_page.dart';
import '../pages/see_more_page.dart';
import '../pages/cards_detailspage.dart';
import '../pages/more_page.dart';
import '../pages/watch_list_page.dart';

import '../bindings/home_binding.dart';
import '../bindings/popular_binding.dart';
import '../bindings/trending_binding.dart';
import '../bindings/latest_movies_binding.dart';
import '../bindings/latest_tv_binding.dart';
import '../bindings/cards_details_binding.dart';
import '../bindings/more_binding.dart';
import '../bindings/watchlist_binding.dart';

import 'app_routes.dart';

class AppPages {
  static final pages = <GetPage>[
    GetPage(
        name: AppRoutes.home, page: () => HomePage(), binding: HomeBinding()),
    GetPage(
        name: AppRoutes.popular,
        page: () => const PopularPage(),
        binding: PopularBinding()),
    GetPage(
        name: AppRoutes.trending,
        page: () => const TrendingMoviesPage(),
        binding: TrendingBinding()),
    GetPage(
        name: AppRoutes.latestMovies,
        page: () => const LatestMoviesPage(),
        binding: LatestMoviesBinding()),
    GetPage(
        name: AppRoutes.latestTV,
        page: () => const LatestTVSeriesPage(),
        binding: LatestTVBinding()),
    GetPage(name: AppRoutes.seeMore, page: () => const SeeMorePage()),
    GetPage(
        name: AppRoutes.cardsDetails,
        page: () => const CardsDetailsPage(),
        binding: CardsDetailsBinding()),
    GetPage(
        name: AppRoutes.more,
        page: () => const MorePage(),
        binding: MoreBinding()),
    GetPage(
        name: AppRoutes.watchlist,
        page: () => const WatchListPage(),
        binding: WatchlistBinding()),
    GetPage(
      name: '/',
      page: () => NavigationPage(),
    ),
    GetPage(
      name: '/cards-details',
      page: () => const CardsDetailsPage(),
      binding: BindingsBuilder(() {
        Get.put(CardsDetailsController());
      }),
    ),
    GetPage(
      name: '/search',
      page: () => SearchPage(),
    ),
  ];
}
