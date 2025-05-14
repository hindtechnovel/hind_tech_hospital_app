import 'package:get/get.dart';

import '../controllers/attendant_controller.dart';

class AttendantBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AttendantController>(
      () => AttendantController(),
    );
  }
}
