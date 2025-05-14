import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class SelectDoctorDialog extends StatelessWidget {
  final String department;

  SelectDoctorDialog({required this.department});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('HindTechHospital/2025-26/Departments/$department/Doctors')
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

        var doctorDocs = snapshot.data!.docs;


        return SimpleDialog(
          title: Text('Select Doctor'),
          children: doctorDocs.map((doc) {
            String doctorName = doc['name'] ?? 'Unnamed';
            String doctorId = doc.id;
            return SimpleDialogOption(
              onPressed: (){
                Get.back(result: {
                  'doctorId': doctorId,
                  'name': doctorName,
                });
              },
              child: Text(doctorName),
            );
          }).toList(),
        );
      },
    );
  }
}
