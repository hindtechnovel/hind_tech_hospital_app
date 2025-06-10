import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hind_tech_hospital/app/widgets/LanguagePickerWidget.dart';
import '../../../Providers/UserController.dart';
import '../../../widgets/AddMember.dart';
import '../../../widgets/AuthGate.dart';
import '../../../widgets/SelectDepartmentDialog .dart';
import '../../../widgets/SelectDoctorDialog.dart';
import '../../../widgets/SelectMemberDialog.dart';
import '../controllers/patient_controller.dart';
import 'package:intl/intl.dart'; // for formatting timestamps

class PatientView extends GetView<PatientController> {
  const PatientView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('patient_dashboard'.tr),
        centerTitle: true,
        actions: [
          Row(
            children: [
              LanguagePickerWidget(),
              IconButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Get.offAll(() => AuthGate());
                     //
                     // controller.addDummyDepartmentsAndDoctors();
                  },
                  icon: Icon(Icons.power_settings_new_rounded))
            ],
          )
        ],
      ),
      body: RefreshIndicator(
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        edgeOffset: 10,
        backgroundColor: Colors.blue,
        color: Colors.white,
        displacement: 20,
        strokeWidth: 1,
        onRefresh: () async {
          print('tapped');
          await controller.refreshData();
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Center(
                    child: Text(
                      'my_family_members'.tr,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      AddMember.showAddMemberForm(
                          context,
                           UserController.to.phoneNumber.value);
                    },
                    icon: Icon(Icons.add_circle_outline),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Obx(() {
                if (controller.members.isEmpty) {
                  return Center(child: Text('no_members_found'.tr));
                }
                return SizedBox(
                  height: Get.height * 0.2,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.members.length,
                    itemBuilder: (context, index) {
                      var member = controller.members[index];
                      return Card(
                        color: index % 2 == 0
                            ? Colors.pink.shade50
                            : Colors.blue.shade50,
                        elevation: 4,
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        child: Container(
                          width: Get.width * 0.5,
                          padding: EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(member['name'] ?? '',
                                  style: Theme.of(context).textTheme.bodyLarge),
                              Text(
                                '${member['gender'] ?? ''},${member['age'] ?? ''}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              SizedBox(height: 8),
                              Text(
                                '${'last_visited'.tr}:',
                                style: TextStyle(fontSize: 12),
                              ),
                              if (member['last_visited'] == null)
                                Text(
                                  'Not Visited yet',
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                ),
                              if (member['last_visited'] != null)
                                Text(
                                  '${member['last_doctor_consulted'] ?? ''}',
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                ),
                              if (member['last_visited'] != null)
                                Text(
                                  '${formatTimestamp(member['last_visited'] ?? '')}',
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                ),
                              SizedBox(height: 4),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
              SizedBox(height: 20),
              Text(
                'recent_appointments'.tr,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              SizedBox(height: 10),
              Obx(() {
                if (controller.appointments.isEmpty) {
                  return Center(child: Text('no_appointments_found'.tr));
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.appointments.length,
                  itemBuilder: (context, index) {
                    var appointment = controller.appointments[index];

                    print('appointmnt is $appointment');
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        leading:
                            Icon(Icons.calendar_today, color: Colors.blueGrey),
                        title: Text(
                          appointment['member_name'] ?? '',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        subtitle: Text(
                          '${appointment['doctor']} - ${appointment['time']}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        trailing: !appointment['cancelled']
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      '${'bill'.tr}: ₹${appointment['billing_amount'] ?? ''}'),
                                  SizedBox(height: 4),
                                  InkWell(
                                    onTap: () {
                                      // open pdf link
                                    },
                                    child: Text(
                                      'view_prescription'.tr,
                                      style: TextStyle(
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline),
                                    ),
                                  ),
                                ],
                              )
                            : Text('cancelled'.tr,
                                style: TextStyle(color: Colors.red)),
                      ),
                    );
                  },
                );
              }),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final String phoneNumber =
                        UserController.to.phoneNumber.value;

                    // Step 1: Select Member
                    final member = await Get.dialog(
                        SelectMemberDialog(phoneNumber: phoneNumber));
                    if (member == null) return;

                    final memberName = member['name'];
                    final memberGender = member['gender'];
                    final memberAge = member['age'];
                    final memberId = member['id'];

                    // Step 2: Select Department
                    final department =
                        await Get.dialog(SelectDepartmentDialog());
                    if (department == null) return;

                    // Step 3: Select Doctor
                    final selectedDoctor  = await Get.dialog(
                        SelectDoctorDialog(department: department));
                    if (selectedDoctor  == null) return;


                    final doctorName=selectedDoctor['name'];
                    final doctorID= selectedDoctor['doctorId'];
                    // Step 4: Select Date
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(Duration(days: 60)),
                    );
                    if (selectedDate == null) return;

                    // Step 5: Get Token/Waiting Number
                    final token = await getWaitingNumber(
                        department, doctorName,doctorID, selectedDate);

                    // Step 6: Show Confirmation Dialog
                    bool? confirm = await Get.dialog(AlertDialog(
                      title: Row(
                        children: [
                          Icon(Icons.event_available, color: Colors.green.shade700),
                          const SizedBox(width: 8),
                          Expanded(
                            child: AutoSizeText(
                              'confirmAppointment'.tr,
                              style: GoogleFonts.acme(fontSize: 20),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      content: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoTile(Icons.person, 'member'.tr, memberName, Colors.blue),
                            _buildInfoTile(Icons.medical_services, 'doctor'.tr, doctorName, Colors.red),
                            _buildInfoTile(Icons.local_hospital, 'department'.tr, department, Colors.deepPurple),
                            _buildInfoTile(Icons.calendar_today, 'date'.tr, DateFormat('dd-MM-yyyy').format(selectedDate), Colors.teal),
                            _buildInfoTile(Icons.confirmation_number, 'tokenNumber'.tr, '$token', Colors.green),
                          ],
                        ),
                      ),
                      actions: [
                        Row(
                          children: [
                            Expanded(
                              child: TextButton.icon(
                                onPressed: () => Get.back(result: false),
                                icon: const Icon(Icons.cancel, color: Colors.red),
                                label: AutoSizeText(
                                  'cancel'.tr,
                                  style: const TextStyle(color: Colors.red),
                                  maxLines: 1,
                                  minFontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => Get.back(result: true),
                                icon: const Icon(Icons.check_circle, color: Colors.white),
                                label: AutoSizeText(
                                  'confirm'.tr,
                                  maxLines: 1,
                                  minFontSize: 10,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ));


                    // Step 7: Book Appointment
                    if (confirm == true) {
                      await bookAppointment(department, doctorName,doctorID, selectedDate,
                          token, memberName,memberAge,memberGender,phoneNumber,memberId);
                      Get.snackbar('Success',
                          'Appointment booked successfully for $memberName!',
                        backgroundColor: Colors.blueGrey,
                        colorText: Colors.white, // optional
                        snackPosition: SnackPosition.BOTTOM, );
                    }
                  },
                  icon: Icon(Icons.add_circle, size: 28),
                  label: Text('book_new_appointment'.tr,
                      style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return '';
    DateTime date = (timestamp as Timestamp).toDate();
    return DateFormat('dd-MM-yyyy').format(date);
  }

Future<int> getWaitingNumber(
    String department, String doctor, String doctorId, DateTime date) async {
  String formattedDate = DateFormat('dd-MM-yyyy').format(date);

  final firestore = FirebaseFirestore.instance;


  final collectionPath =
      'HindTechHospital/2025-26/Departments/$department/Doctors/$doctorId/appointments/$formattedDate/entries';

  var snapshot = await firestore.collection(collectionPath).get();


  int maxCounter = 0;

  for (var doc in snapshot.docs) {
    Map<String, dynamic> data = doc.data();
    int counter = data['token'] ?? 0;
    print('   Token found: $counter');

    if (counter > maxCounter) {
      maxCounter = counter;
    }
  }

  int waitingNumber = maxCounter + 1;
  print('✅ Final calculated waiting number: $waitingNumber');

  return waitingNumber;
}


Future<void> bookAppointment(
  String department,
  String doctor,
  String doctorId,
  DateTime date,
  int token,
  String member,
  String age,
  String gender,
  String phoneNumber,
  String memberId,
) async {
  final String formattedDate = DateFormat('dd-MM-yyyy').format(date);

  final Map<String, dynamic> appointmentData = {
    'member_name': member,
    'token': token,
    'fee': 'N-A',
    'paid': 'No',
    'slot': DateTime.now().millisecondsSinceEpoch,
    'department': department,
    'doctor': doctor,
    'doctorID': doctorId,
    'time': formattedDate,
    'cancelled': false,
    'age': age,
    'gender': gender,
    'phoneNumber': phoneNumber,
    'memberId': memberId
  };

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final DocumentReference dateDocRef = firestore.doc(
      'HindTechHospital/2025-26/Departments/$department/Doctors/$doctorId/appointments/$formattedDate');

  final CollectionReference appointmentsList = dateDocRef.collection('entries');

  try {
    log('\x1B[36m🔄 Checking if first appointment of the day...\x1B[0m');
    final QuerySnapshot snapshot = await appointmentsList.get();
    print('Found ${snapshot.docs.length} entries in appointmentsList');
    for (var entryDoc in snapshot.docs) {
      print('Entry: ${entryDoc.id}, Data: ${entryDoc.data()}');
    }
 log('---------snapshot -------\x1B[36m🔄 ${snapshot.docs}.\x1B[0m');
    if (snapshot.docs.isEmpty) {
      log('\x1B[33m📌 First appointment of the day! Initializing date document.\x1B[0m');
      await dateDocRef.set({
        'currentToken': 1,
        'total_appointment_taken': 0,
      });
    }

    log('\x1B[34m🗃️ Adding appointment to entries subcollection...\x1B[0m');
    await appointmentsList.add(appointmentData);

    log('\x1B[32m✅ Appointment added under doctor\'s schedule!\x1B[0m');

    log('\x1B[34m💾 Saving appointment to patient\'s personal record...\x1B[0m');
    await firestore
        .collection('HindTechHospital/2025-26/Patients/$phoneNumber/appointments')
        .add(appointmentData);

    log('\x1B[32m✅ Appointment also saved in patient record!\x1B[0m');

    log('\x1B[35m🔁 Triggering controller.fetchAppointments()...\x1B[0m');
    controller.fetchAppointments();
    log('\x1B[32m🏁 Appointment process completed successfully!\x1B[0m');
  } catch (e) {
    log('\x1B[31m❌ Error during appointment booking: $e\x1B[0m');
  }
}


  Widget _buildInfoTile(
      IconData icon, String label, String value, MaterialColor iconColor) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: iconColor),
      title: AutoSizeText(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold),
        maxLines: 1,
      ),
      subtitle: AutoSizeText(
        value,
        style: GoogleFonts.acme(color: iconColor.shade700),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
