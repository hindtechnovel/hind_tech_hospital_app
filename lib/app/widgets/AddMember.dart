import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hind_tech_hospital/app/modules/patient/controllers/patient_controller.dart';

class AddMember {
  static void showAddMemberForm(BuildContext context, String patientphoneNumber) {

    final _nameController = TextEditingController();
    final _ageController = TextEditingController();
    final _genderController = TextEditingController();

  PatientController patientController = Get.find();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (_) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets.add(const EdgeInsets.all(20)),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('add_member'.tr, style: Theme.of(context).textTheme.headlineLarge),
                const SizedBox(height: 20),

                // Name
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'member_name'.tr),
                ),
                const SizedBox(height: 10),

                // Age
                TextField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'member_age'.tr),
                ),
                const SizedBox(height: 10),

                // Gender
                TextField(
                  controller: _genderController,
                  decoration: InputDecoration(labelText: 'member_gender'.tr),
                ),



                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () async {
                    if (_nameController.text.isEmpty ||
                        _ageController.text.isEmpty ||
                        _genderController.text.isEmpty == null) {
                      Get.snackbar('error'.tr, 'please_fill_all_fields'.tr);
                      return;
                    }

                    try {
                      final memberData = {
                        'name': _nameController.text.trim(),
                        'age': _ageController.text.trim(),
                        'gender': _genderController.text.trim(),
                      };



                      await FirebaseFirestore.instance
                          .collection('HindTechHospital')
                          .doc('2025-26')
                          .collection('Patients')
                          .doc(patientphoneNumber)
                          .collection('MyMembers')
                          .add(memberData);
                      Get.back(); // Close bottom sheet
                      Get.snackbar('success'.tr, 'member_added_successfully'.tr);
patientController.fetchMembers();


                    } catch (e) {
                      print('error is $patientphoneNumber');
                      print('failed ot add members $e');
                      Get.snackbar('error'.tr, 'failed_to_add_member'.tr);
                    }
                  },
                  child: Text('submit'.tr),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
