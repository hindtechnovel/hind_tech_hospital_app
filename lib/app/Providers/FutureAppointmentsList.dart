import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class FutureAppointmentsList extends StatelessWidget {
  final String department;
  final String doctorId;
  final String doctorName;
  final String date;

  const FutureAppointmentsList({
    required this.department,
    required this.doctorId,
    required this.doctorName,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Appointments on $date")),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('HindTechHospital/2025-26/Departments/$department/Doctors/$doctorId/records/appointments/$date')
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final appts = snapshot.data!.docs;

          if (appts.isEmpty) return Center(child: Text("No Appointments"));

          return ListView(
            children: appts.map((doc) {
              return ListTile(
                title: Text("👤 ${doc['member_name']}"),
                subtitle: Text("🔢 Token: ${doc['token']}"),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
