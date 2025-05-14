import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserController extends GetxController {
  static UserController get to => Get.find(); // easy access globally

  RxString phoneNumber = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUser();
  }

  void loadUser() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      phoneNumber.value = user.phoneNumber ?? '';
    }
  }
}
