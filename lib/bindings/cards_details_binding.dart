import 'package:get/get.dart';
import '../controllers/cards_details_controller.dart';

class CardsDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CardsDetailsController());
  }
}
