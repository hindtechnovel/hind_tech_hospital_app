import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class ReceptionController extends GetxController {
  final today = DateFormat('dd-MM-yyyy').format(DateTime.now());
  var allAppointments = <Map<String, dynamic>>[].obs;
  var selectedDepartment = ''.obs;
  var selectedDoctorId = ''.obs;
  var selectedDoctorIndex = 0.obs;
  final PageController pageController = PageController(viewportFraction: 0.9);

  var departments = <String>[].obs;
  var doctors = <Map<String, dynamic>>[].obs;
  var appointmentsByDoctor = <String, List<Map<String, dynamic>>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDepartmentsAndDoctors();
  }

  Future<void> fetchDepartmentsAndDoctors() async {
    departments.clear();
    final deptSnapshot = await FirebaseFirestore.instance
        .collection('HindTechHospital/2025-26/Departments')
        .get();
    departments.addAll(deptSnapshot.docs.map((doc) => doc.id));

    if (departments.isNotEmpty) {
      changeDepartment(departments.first);
    }
  }

  Future<void> changeDepartment(String deptName) async {
    selectedDepartment.value = deptName;
    doctors.clear();
    appointmentsByDoctor.clear();

    final doctorSnapshot = await FirebaseFirestore.instance
        .collection('HindTechHospital/2025-26/Departments/$deptName/Doctors')
        .get();

    for (var doc in doctorSnapshot.docs) {
      String docId = doc.id;
      String docName = doc['name'];
      doctors.add({'id': docId, 'name': docName});
      await fetchAppointmentsForDoctor(docId, docName);
    }

    if (doctors.isNotEmpty) {
      selectedDoctorId.value = doctors.first['id'];
      selectedDoctorIndex.value = 0;
    }
  }

  Future<void> fetchAppointmentsForDoctor(
      String doctorId, String doctorName) async {
    final today = DateFormat('dd-MM-yyyy').format(DateTime.now());
    final snapshot = await FirebaseFirestore.instance
        .collection(
            'HindTechHospital/2025-26/Departments/${selectedDepartment.value}/Doctors/$doctorId/appointments/$today/entries')
        .get();

    appointmentsByDoctor[doctorId] = snapshot.docs.map((doc) {
      return {
        'patientName': doc['member_name'],
        'token': doc['token'],
        'doctorId': doctorId,
        'doctorName': doctorName,
        'date': today,
        'age':doc['age'],
        'gender': doc['gender']=='Female'? 'F':'M',
        'phoneNumber':doc['phoneNumber']
      };
    }).toList();
  }

  void changeDoctor(int index, String doctorId) async {
    selectedDoctorIndex.value = index;
    selectedDoctorId.value = doctorId;

    print(
        'docto  changed: $index-$doctorId\n${selectedDoctorIndex.value} - ${selectedDoctorId.value}');

    // Animate to the selected page
    pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    // Fetch appointments if not already fetched
    if (!appointmentsByDoctor.containsKey(doctorId)) {
      String doctorName = doctors[index]['name'];
      await fetchAppointmentsForDoctor(doctorId, doctorName);
    }
  }

  void updateAppointmentStatus(
      {required doctorid, required appointmentId, required String newStatus}) {}
}
