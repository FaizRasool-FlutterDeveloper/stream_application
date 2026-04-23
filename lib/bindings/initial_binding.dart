import 'package:get/get.dart';
import 'package:stream_application/controllers/more_controller.dart';
import 'package:stream_application/controllers/movies_controller.dart';
import 'package:stream_application/controllers/navigation_controller.dart';
import 'package:stream_application/controllers/tv_series_controller.dart';
import 'package:stream_application/controllers/watchlist_controller.dart';

import '../controllers/search_controller.dart' as app_ctrl;

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Core controllers
    Get.lazyPut(() => NavigationController());
    Get.lazyPut(() => WatchlistController());
    Get.lazyPut(() => MoviesController());
    Get.lazyPut(() => TvSeriesController());
    Get.lazyPut(() => MoreController());

    // Search functionality
    Get.lazyPut(() => app_ctrl.SearchController());
  }
}
