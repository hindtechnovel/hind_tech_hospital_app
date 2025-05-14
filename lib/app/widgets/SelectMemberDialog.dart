import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectMemberDialog extends StatelessWidget {
  final String phoneNumber;

  const SelectMemberDialog({Key? key, required this.phoneNumber})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final membersRef = FirebaseFirestore.instance
        .collection('HindTechHospital')
        .doc('2025-26')
        .collection('Patients')
        .doc(phoneNumber)
        .collection('MyMembers');

    return AlertDialog(
      title: const Text('Select Member'),
      content: StreamBuilder<QuerySnapshot>(
        stream: membersRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Text('No members found.');
          }

          final docs = snapshot.data!.docs;

          return SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: docs.length,
                itemBuilder: (context, index) {
                  final data = docs[index].data() as Map<String, dynamic>;
                  final name = data['name'] ?? 'Unknown';
                  final gender = data['gender'] ?? 'N/A';
                  final age = data['age']?.toString() ?? 'N/A';

                  return Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.green.shade100,
                          child: Text('${index + 1}', style: TextStyle(color: Colors.black)),
                        ),
                        title: Text(name),
                        subtitle: Text('$gender - $age', style: GoogleFonts.acme(color: Colors.green)),
                        onTap: () => Get.back(result: {
                          'id': docs[index].id,
                          'name': name,
                          'gender': gender,
                          'age': age,
                        }),
                      ),
                      Divider(thickness: 1, color: Colors.grey.shade300),
                    ],
                  );
                }

            ),
          );
        },
      ),
    );
  }
}
