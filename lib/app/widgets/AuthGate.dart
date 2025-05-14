import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hind_tech_hospital/app/modules/chooserole/views/chooserole_view.dart';
import 'package:hind_tech_hospital/app/modules/patient/views/patient_view.dart';
import 'package:hind_tech_hospital/app/modules/reception/views/reception_view.dart';
import 'package:hind_tech_hospital/app/modules/pharmacist/views/pharmacist_view.dart';
import 'package:hind_tech_hospital/app/modules/doctor/views/doctor_view.dart';
import 'package:hind_tech_hospital/app/modules/attendant/views/attendant_view.dart';
import 'package:hind_tech_hospital/helperClasses/AppStorage.dart';
import '../modules/phone_auth/views/phone_auth_view.dart';

class AuthGate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData) {
          return FutureBuilder(
            future: Future.wait([
              AppStorage.getValue('userRole'),
              AppStorage.getValue('staffRole'),
            ]),
            builder: (context, AsyncSnapshot<List<dynamic>> roleSnapshot) {
              if (!roleSnapshot.hasData) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              String userRole = roleSnapshot.data![0] ?? '';
              String staffRole = roleSnapshot.data![1] ?? '';

              print('userRole: $userRole, staffRole: $staffRole');

              if (userRole == 'Patient') {
                return PatientView();
              } else if (userRole == 'HospitalStaff') {
                switch (staffRole) {
                  case 'Reception':
                    return ReceptionView();
                  case 'Pharmacist':
                    return PharmacistView();
                  case 'Doctor':
                    return DoctorView();
                  case 'Attendant':
                    return AttendantView();
                  default:
                    return ChooseroleView();
                }
              } else {
                return Scaffold(
                  body: Center(child: Text("Unknown Role")),
                );
              }
            },
          );
        } else {
          return PhoneAuthView();
        }
      },
    );
  }
}
