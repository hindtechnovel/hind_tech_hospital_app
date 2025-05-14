import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Providers/FutureAppointmentsList.dart';
import '../../../widgets/AuthGate.dart';
import '../../../widgets/LanguagePickerWidget.dart';
import 'package:hind_tech_hospital/app/modules/Reception/controllers/reception_controller.dart';

class ReceptionView extends GetView<ReceptionController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Reception Dashboard"),
          actions: [
            LanguagePickerWidget(),
            IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Get.offAll(() => AuthGate());
              },
              icon: Icon(Icons.power_settings_new_rounded),
            )
          ],
        ),
        body: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Department Buttons
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.departments.length,
                  itemBuilder: (context, index) {
                    final dept = controller.departments[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Text(
                          dept,
                          style: GoogleFonts.aclonica(
                              color: controller.selectedDepartment.value == dept
                                  ? Colors.white
                                  : Colors.green.shade900),
                        ),
                        selectedColor: Colors.green.shade900,
                        selected: controller.selectedDepartment.value == dept,
                        onSelected: (_) => controller.changeDepartment(dept),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 10),

              // Doctor Buttons
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.doctors.length,
                  itemBuilder: (context, index) {
                    final doctor = controller.doctors[index];
                    print('index is: doc is $doctor ');
                    return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Obx(
                          () => ChoiceChip(
                            label: Text(
                              doctor['name'],
                              style: GoogleFonts.acme(
                                  color: controller.selectedDoctorIndex.value ==
                                          index
                                      ? Colors.white
                                      : Colors.green.shade900),
                            ),
                            selected: controller.selectedDoctorIndex == index,
                            selectedColor: Colors.green.shade900,
                            onSelected: (_) =>
                                controller.changeDoctor(index, doctor['id']),
                          ),
                        ));
                  },
                ),
              ),
              SizedBox(height: 10),

              // Appointment Cards
              Expanded(
                child: PageView.builder(
                  controller: controller.pageController,
                  onPageChanged: (index) {
                    controller.selectedDoctorIndex.value = index;
                    controller.selectedDoctorId.value =
                        controller.doctors[index]['id'];
                  },
                  itemCount: controller.doctors.length,
                  itemBuilder: (context, index) {
                    final doctor = controller.doctors[index];
                    final appts =
                        controller.appointmentsByDoctor[doctor['id']] ?? [];

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      margin: EdgeInsets.all(12),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("👨‍⚕️ Dr. ${doctor['name']}",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            Text(
                                "🏥 Department: ${controller.selectedDepartment.value}"),
                            SizedBox(height: 12),

                            // Patient list (scrollable)
                            Expanded(
                              child: ListView.builder(
                                itemCount: appts.length,
                                itemBuilder: (context, i) {
                                  final appt = appts[i];
                                  print('appointmetn is $appt');

                                  return Card(
                                    margin: EdgeInsets.symmetric(vertical: 6),
                                    elevation: 2,
                                    child: ListTile(
                                      leading: Icon(Icons.person),
                                      title: Text(
                                          "${appt['patientName']} | ${appt['age']}, ${appt['gender']}"),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("${appt['phoneNumber']}"),
                                        ],
                                      ),
                                      trailing: IconButton(
                                        icon: Icon(
                                          appt['status'] == 'done'
                                              ? Icons.check_circle
                                              : Icons.pending_actions,
                                          color: appt['status'] == 'done'
                                              ? Colors.green
                                              : Colors.orange,
                                        ),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (_) => AlertDialog(
                                              title: Text("Update Status"),
                                              content: Text(
                                                  "Mark as ${appt['status'] == 'done' ? 'Pending' : 'Done'}?"),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context),
                                                  child: Text("Cancel"),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    controller.updateAppointmentStatus(
                                                      doctorid: doctor['id'],
                                                      appointmentId: appt['id'],
                                                      newStatus: appt['status'] == 'done'
                                                          ? 'pending'
                                                          : 'done',
                                                    );
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("Confirm"),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                            // Token controls at the bottom
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove_circle,
                                      color: Colors.red),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: Text("Decrease Token"),
                                        content: Text(
                                            "Are you sure you want to decrease the token?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text("Cancel"),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              updateToken(
                                                context: context,
                                                department: controller
                                                    .selectedDepartment.value,
                                                doctorId: doctor['id'],
                                                appointmentDate:
                                                    DateTime.now().toString(),
                                                increment: false,
                                              );
                                              Navigator.pop(context);
                                            },
                                            child: Text("Yes"),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(width: 20),
                                IconButton(
                                  icon: Icon(Icons.add_circle,
                                      color: Colors.green),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: Text("Increase Token"),
                                        content: Text(
                                            "Are you sure you want to increase the token?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text("Cancel"),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              updateToken(
                                                context: context,
                                                department: controller
                                                    .selectedDepartment.value,
                                                doctorId: doctor['id'],
                                                appointmentDate:
                                                    DateTime.now().toString(),
                                                increment: true,
                                              );
                                              Navigator.pop(context);
                                            },
                                            child: Text("Yes"),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          );
        }));
  }

  Widget appointmentCard(BuildContext context, dynamic appt) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 260,
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("👨‍⚕️${appt['doctorName']}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text("🏥 Dept: ${appt['department']}"),
            SizedBox(height: 10),
            Text("👤 Patient: ${appt['patientName']}"),
            Text("🔢 Token: ${appt['token']}"),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.remove_circle_outline),
                  onPressed: () => updateToken(
                    context: context,
                    department: appt['department'],
                    doctorId: appt['doctorId'],
                    appointmentDate: appt['date'],
                    increment: false,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add_circle_outline),
                  onPressed: () => updateToken(
                    context: context,
                    department: appt['department'],
                    doctorId: appt['doctorId'],
                    appointmentDate: appt['date'],
                    increment: true,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> updateToken({
    required BuildContext context,
    required String department,
    required String doctorId,
    required String appointmentDate,
    required bool increment,
  }) async {
    final docRef = FirebaseFirestore.instance.doc(
      'HindTechHospital/2025-26/Departments/$department/Doctors/$doctorId/appointments/$appointmentDate',
    );

    final doc = await docRef.get();
    if (!doc.exists) {
      Get.snackbar("Error", "Token data not found for selected date.");
      return;
    }

    int currentToken = doc.data()?['currentToken'] ?? 0;
    int totalAppointments = doc.data()?['total_appointment_taken'] ?? 0;

    if (!increment && currentToken <= 0) {
      Get.snackbar("Warning", "No tokens to reduce.");
      return;
    }

    // Confirmation dialog
    bool? confirm = await Get.dialog(AlertDialog(
      title: Text(increment ? "Increase Token?" : "Decrease Token?"),
      content: Text(
          "Are you sure you want to ${increment ? 'increase' : 'decrease'} the token number?"),
      actions: [
        TextButton(
            onPressed: () => Get.back(result: false), child: Text("Cancel")),
        TextButton(onPressed: () => Get.back(result: true), child: Text("Yes")),
      ],
    ));

    if (confirm == true) {
      int updatedToken = increment ? currentToken + 1 : currentToken - 1;
      await docRef.update({'currentToken': updatedToken});
      Get.snackbar("Success", "Token updated to $updatedToken");
    }
  }

  void showFutureAppointmentsFlow(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2026),
    );

    if (selectedDate == null) return;
    String formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);

    String? selectedDepartment = await Get.dialog(SimpleDialog(
      title: Text("Select Department"),
      children: await getDepartments(),
    ));

    if (selectedDepartment == null) return;

    Map<String, String>? selectedDoctor = await Get.dialog(SimpleDialog(
      title: Text("Select Doctor"),
      children: await getDoctorsForDepartment(selectedDepartment),
    ));

    if (selectedDoctor == null) return;

    Get.to(() => FutureAppointmentsList(
          department: selectedDepartment,
          doctorId: selectedDoctor['id']!,
          doctorName: selectedDoctor['name']!,
          date: formattedDate,
        ));
  }

  Future<List<Widget>> getDepartments() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('HindTechHospital/2025-26/Departments')
        .get();
    return snapshot.docs.map((doc) {
      return SimpleDialogOption(
        onPressed: () => Get.back(result: doc.id),
        child: Text(doc.id),
      );
    }).toList();
  }

  Future<List<Widget>> getDoctorsForDepartment(String dept) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('HindTechHospital/2025-26/Departments/$dept/Doctors')
        .get();
    return snapshot.docs.map((doc) {
      return SimpleDialogOption(
        onPressed: () => Get.back(result: {'id': doc.id, 'name': doc['name']}),
        child: Text(doc['name']),
      );
    }).toList();
  }
}
