import 'package:get/get.dart';
import '../controllers/latest_tv_controller.dart';

class LatestTVBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LatestTVController());
  }
}
