import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../Providers/UserController.dart';

class PatientController extends GetxController {
  RxList<Map<String, dynamic>> members = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> appointments = <Map<String, dynamic>>[].obs;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final String patientPhone = UserController.to.phoneNumber.value; // you can fetch it dynamically also

  @override
  void onInit() {
    super.onInit();
    fetchMembers();
    fetchAppointments();
  }

  Future<void> fetchMembers() async {
    QuerySnapshot snapshot = await firestore
        .collection('HindTechHospital')
        .doc('2025-26')
        .collection('Patients')
        .doc(patientPhone)
        .collection('MyMembers')
        .get();

    members.value = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

 
  Future<void> fetchAppointments() async {
  try {
    print('Fetching appointments for patient: $patientPhone');

    // Start Firestore query
    QuerySnapshot snapshot = await firestore
        .collection('HindTechHospital')
        .doc('2025-26')
        .collection('Patients')
        .doc(patientPhone)
        .collection('appointments')
        .orderBy('time', descending: true)
        .get();

    print('Total appointments fetched: ${snapshot.docs.length}');

    // Convert documents to list
    appointments.value = snapshot.docs.map((doc) {
      print('Appointment Data: ${doc.data()}');
      return doc.data() as Map<String, dynamic>;
    }).toList();

    print('Appointments successfully stored in controller.');
  } catch (e) {
    print('Error while fetching appointments: $e');
  }
}

  Future<void> addDummyDepartmentsAndDoctors() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final hospitalDoc = firestore.collection('HindTechHospital').doc('2025-26');

    final departments = ['Cardiology', 'Neurology', 'Pediatrics', 'Dermatology', 'Orthopedics'];

    // Map department name to matching speciality
    final Map<String, String> departmentToSpeciality = {
      'Cardiology': 'Cardiologist',
      'Neurology': 'Neurologist',
      'Pediatrics': 'Pediatrician',
      'Dermatology': 'Dermatologist',
      'Orthopedics': 'Orthopedic Surgeon',
    };

    final List<Map<String, dynamic>> sampleDoctors = [
      // Cardiologists
      {'name': 'Dr. Arjun Malhotra', 'age': 52, 'experience': '25 years', 'gender': 'Male', 'qualification': 'MBBS, MD (Cardiology)', 'speciality': 'Cardiologist', 'shift': 1},
      {'name': 'Dr. Kavita Sharma', 'age': 45, 'experience': '20 years', 'gender': 'Female', 'qualification': 'MBBS, DM (Cardiology)', 'speciality': 'Cardiologist', 'shift': 2},
      {'name': 'Dr. Rohit Bansal', 'age': 38, 'experience': '12 years', 'gender': 'Male', 'qualification': 'MBBS, MD (Cardiology)', 'speciality': 'Cardiologist', 'shift': 1},

      // Neurologists
      {'name': 'Dr. Meenal Joshi', 'age': 41, 'experience': '15 years', 'gender': 'Female', 'qualification': 'MBBS, DM (Neurology)', 'speciality': 'Neurologist', 'shift': 2},
      {'name': 'Dr. Ashok Khanna', 'age': 50, 'experience': '22 years', 'gender': 'Male', 'qualification': 'MBBS, DM (Neuro)', 'speciality': 'Neurologist', 'shift': 1},
      {'name': 'Dr. Swati Mishra', 'age': 37, 'experience': '10 years', 'gender': 'Female', 'qualification': 'MBBS, DM (Neurology)', 'speciality': 'Neurologist', 'shift': 2},

      // Pediatricians
      {'name': 'Dr. Ankit Rawat', 'age': 36, 'experience': '10 years', 'gender': 'Male', 'qualification': 'MBBS, DCH', 'speciality': 'Pediatrician', 'shift': 2},
      {'name': 'Dr. Neha Verma', 'age': 40, 'experience': '14 years', 'gender': 'Female', 'qualification': 'MBBS, MD (Pediatrics)', 'speciality': 'Pediatrician', 'shift': 1},
      {'name': 'Dr. Rajesh Thakur', 'age': 44, 'experience': '18 years', 'gender': 'Male', 'qualification': 'MBBS, DNB (Pediatrics)', 'speciality': 'Pediatrician', 'shift': 2},

      // Dermatologists
      {'name': 'Dr. Priya Mathur', 'age': 39, 'experience': '13 years', 'gender': 'Female', 'qualification': 'MBBS, MD (Dermatology)', 'speciality': 'Dermatologist', 'shift': 2},
      {'name': 'Dr. Anjali Kapoor', 'age': 35, 'experience': '9 years', 'gender': 'Female', 'qualification': 'MBBS, MD (Skin)', 'speciality': 'Dermatologist', 'shift': 1},
      {'name': 'Dr. Mohit Arora', 'age': 42, 'experience': '17 years', 'gender': 'Male', 'qualification': 'MBBS, DDVL', 'speciality': 'Dermatologist', 'shift': 2},

      // Orthopedic Surgeons
      {'name': 'Dr. Vikram Sethi', 'age': 47, 'experience': '20 years', 'gender': 'Male', 'qualification': 'MBBS, MS (Orthopedics)', 'speciality': 'Orthopedic Surgeon', 'shift': 2},
      {'name': 'Dr. Ritu Chauhan', 'age': 43, 'experience': '18 years', 'gender': 'Female', 'qualification': 'MBBS, DNB (Orthopedics)', 'speciality': 'Orthopedic Surgeon', 'shift': 1},
      {'name': 'Dr. Karan Mehta', 'age': 39, 'experience': '14 years', 'gender': 'Male', 'qualification': 'MBBS, MS (Ortho)', 'speciality': 'Orthopedic Surgeon', 'shift': 2},
    ];

    for (final departmentName in departments) {
      final departmentDocRef = hospitalDoc.collection('Departments').doc(departmentName);

      // Create department doc
      await departmentDocRef.set({'name': departmentName});

      final speciality = departmentToSpeciality[departmentName];
      final doctorsInDept = sampleDoctors
          .where((doctor) => doctor['speciality'] == speciality)
          .toList();

      for (final doctor in doctorsInDept) {
        await departmentDocRef.collection('Doctors').add(doctor);
      }

      print("✅ Added ${doctorsInDept.length} doctors to $departmentName");
    }

    print("🎉 All dummy departments and doctors added successfully.");
  }





  // inside PatientController
  Future<void> refreshData() async {
    await fetchMembers();
    await fetchAppointments();
  }

}
