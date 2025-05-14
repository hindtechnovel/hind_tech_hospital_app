import 'package:get/get.dart';

import '../controllers/reception_controller.dart';

class ReceptionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReceptionController>(
      () => ReceptionController(),
    );
  }
}
