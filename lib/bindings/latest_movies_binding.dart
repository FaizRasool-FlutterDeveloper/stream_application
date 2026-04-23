import 'package:get/get.dart';
import '../controllers/latest_movies_controller.dart';

class LatestMoviesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LatestMoviesController());
  }
}
