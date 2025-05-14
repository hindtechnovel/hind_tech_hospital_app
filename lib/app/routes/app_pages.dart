import 'package:get/get.dart';

import '../modules/Attendant/bindings/attendant_binding.dart';
import '../modules/Attendant/views/attendant_view.dart';
import '../modules/Doctor/bindings/doctor_binding.dart';
import '../modules/Doctor/views/doctor_view.dart';
import '../modules/Pharmacist/bindings/pharmacist_binding.dart';
import '../modules/Pharmacist/views/pharmacist_view.dart';
import '../modules/Reception/bindings/reception_binding.dart';
import '../modules/Reception/controllers/reception_controller.dart';
import '../modules/Reception/views/reception_view.dart';
import '../modules/chooserole/bindings/chooserole_binding.dart';
import '../modules/chooserole/views/chooserole_view.dart';
import '../modules/patient/bindings/patient_binding.dart';
import '../modules/patient/views/patient_view.dart';
import '../modules/phone_auth/controllers/phone_auth_controller.dart';
import '../modules/phone_auth/views/phone_auth_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.PHONE_AUTH;

  static final routes = [

    GetPage(
      name: _Paths.PHONE_AUTH,
      page: () => PhoneAuthView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<PhoneAuthController>(() => PhoneAuthController());
      }),
    ),
    GetPage(
      name: _Paths.CHOOSEROLE,
      page: () => ChooseroleView(),
      binding: ChooseroleBinding(),
    ),
    GetPage(
      name: _Paths.PATIENT,
      page: () => const PatientView(),
      binding: PatientBinding(),
    ),
    GetPage(
      name: _Paths.RECEPTION,
      page: () => ReceptionView(),
      binding: BindingsBuilder(() => Get.lazyPut(() => ReceptionController())),
    ),
    GetPage(
      name: _Paths.PHARMACIST,
      page: () => const PharmacistView(),
      binding: PharmacistBinding(),
    ),
    GetPage(
      name: _Paths.DOCTOR,
      page: () => const DoctorView(),
      binding: DoctorBinding(),
    ),
    GetPage(
      name: _Paths.ATTENDANT,
      page: () => const AttendantView(),
      binding: AttendantBinding(),
    ),
  ];
}
