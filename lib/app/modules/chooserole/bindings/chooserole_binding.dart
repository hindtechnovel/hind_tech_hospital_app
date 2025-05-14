import 'package:get/get.dart';
import '../controllers/chooserole_controller.dart';

class ChooseroleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChooseroleController>(() => ChooseroleController());
  }
}
