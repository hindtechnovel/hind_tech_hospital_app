import 'package:get/get.dart';

import '../../../../helperClasses/AppStorage.dart';
import '../../../routes/app_pages.dart';

class ChooseroleController extends GetxController {
  RxString selectedRoleType = ''.obs;
  RxString selectedStaffRole = ''.obs;

  void selectRoleType(String role) {
    selectedRoleType.value = role;
    AppStorage.saveValue('userRole', role);
    selectedStaffRole.value = ''; // Reset staff role when role type changes
  }

  void selectStaffRole(String role) {
    selectedStaffRole.value = role;
    AppStorage.saveValue('staffRole', role);

    // Navigate based on staff role
    switch (role) {
      case 'Reception':
        Get.offAllNamed(Routes.RECEPTION);
        break;
      case 'Pharmacist':
        Get.offAllNamed(Routes.PHARMACIST);
        break;
      case 'Doctor':
        Get.offAllNamed(Routes.DOCTOR);
        break;
      case 'Attendant':
        Get.offAllNamed(Routes.ATTENDANT);
        break;
    }
  }

}
