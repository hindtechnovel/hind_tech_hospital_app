import 'package:get/get.dart';

import '../controllers/pharmacist_controller.dart';

class PharmacistBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PharmacistController>(
      () => PharmacistController(),
    );
  }
}
