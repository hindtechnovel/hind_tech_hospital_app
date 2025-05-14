import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';


class SelectDepartmentDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('HindTechHospital/2025-26/Departments')
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

        var departments = snapshot.data!.docs.map((doc) => doc.id).toList();

        return SimpleDialog(
          title: Text('Select Department'),
          children: departments.map((dept) {
            return SimpleDialogOption(
              onPressed: () => Get.back(result: dept),
              child: Text(dept),
            );
          }).toList(),
        );
      },
    );
  }
}
