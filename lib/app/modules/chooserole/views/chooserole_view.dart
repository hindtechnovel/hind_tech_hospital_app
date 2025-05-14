import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../../routes/app_pages.dart';
import '../controllers/chooserole_controller.dart';

class ChooseroleView extends GetView<ChooseroleController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30,),
              // Add Lottie Animation
              Center(
                child: Lottie.asset(
                  'Assets/Lottie/chooseRole.json',
                  width: 250,
                  height: 250,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  'select_role'.tr,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  roleCard(
                    icon: Icons.local_hospital,
                    title: 'hospital_staff'.tr,
                    value: 'HospitalStaff',
                  ),
                  roleCard(
                    icon: Icons.person,
                    title: 'patient'.tr,
                    value: 'Patient',
                  ),
                ],
              ),
              SizedBox(height: 30),
              if (controller.selectedRoleType.value == 'HospitalStaff') ...[
                Center(
                  child: Text(
                    'select_staff_role'.tr,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 15,
                  runSpacing: 15,
                  children: [
                    staffRoleCard(Icons.receipt, 'reception'.tr, 'Reception'),
                    staffRoleCard(Icons.local_pharmacy, 'pharmacist'.tr, 'Pharmacist'),
                    staffRoleCard(Icons.medical_services, 'doctor'.tr, 'Doctor'),
                    staffRoleCard(Icons.people, 'attendant'.tr, 'Attendant'),
                  ],
                ),
              ],
            ],
          );
        }),
      ),
    );
  }

  Widget roleCard({required IconData icon, required String title, required String value}) {
    final isSelected = controller.selectedRoleType.value == value;
    return GestureDetector(
      onTap: () {
        controller.selectRoleType(value);
        if(value=='Patient')
          {
            Get.offAllNamed(Routes.PATIENT);
          }
      },
      child: Card(
        color: isSelected ? Colors.blueGrey : Colors.white,
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          width: 140,
          height: 140,
          padding: EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: isSelected ? Colors.white : Colors.blueGrey),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget staffRoleCard(IconData icon, String title, String value) {
    final isSelected = controller.selectedStaffRole.value == value;
    return GestureDetector(
      onTap: () {
        controller.selectStaffRole(value);
      },
      child: Card(
        color: isSelected ? Colors.blueGrey : Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          width: Get.width*0.4,
          height: Get.width*0.4,
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, color: isSelected ? Colors.white : Colors.blueGrey,size: 30,),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
