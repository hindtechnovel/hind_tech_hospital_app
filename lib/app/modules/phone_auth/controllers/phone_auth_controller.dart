import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hind_tech_hospital/app/routes/app_pages.dart'; // update this according to your path

class PhoneAuthController extends GetxController {
  FirebaseAuth _auth = FirebaseAuth.instance;

  var isLoading = false.obs;

  var phoneNumber = ''.obs;
  var countryCode = '+91'.obs;
  var otpCode = ''.obs;
  var verificationId = ''.obs;
  var isOTPScreen = false.obs;

  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  void sendOTP() async {

    if (phoneController.text.isEmpty || phoneController.text.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(phoneController.text)) {
      Get.snackbar("Invalid Number", "Please enter a valid 10-digit phone number");
      return;
    }
    print('inside send OTP and ${isLoading.value}');

    isLoading.value = true;
    // Simulate network delay
    await Future.delayed(Duration(seconds: 2));
    print('inside send OTP2 and ${isLoading.value}');
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: '${countryCode.value}${phoneController.text.trim()}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          Get.offAllNamed(Routes.HOME); // Navigate to home
        },
        verificationFailed: (FirebaseAuthException e) {
          Get.snackbar('Error', e.message ?? "Phone verification failed");
        },
        codeSent: (String verId, int? resendToken) {
          verificationId.value = verId;
          isOTPScreen.value = true;
        },
        codeAutoRetrievalTimeout: (String verId) {
          verificationId.value = verId;
        },
      );
    } finally {
      isLoading.value = false;
    }


  }

  void verifyOTP() async {


    isLoading.value = true;

    await Future.delayed(Duration(seconds: 2));

    print('inside verify OTP and ${isLoading.value}');
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId.value,
        smsCode: otpController.text.trim(),
      );

      try {
        UserCredential userCredential = await _auth.signInWithCredential(credential);
        String phoneNumber = userCredential.user!.phoneNumber!; // keep +91

        final userDocRef = FirebaseFirestore.instance
            .collection('HindTechHospital/2025-26/Patients')
            .doc(phoneNumber);

        // Check if document exists
        final doc = await userDocRef.get();
        if (!doc.exists) {
          await userDocRef.set({
            'phone': phoneNumber,
            'createdAt': DateTime.now().toIso8601String(),
            'role': '',
          });
        }

        resetAuthState();
        Get.offAllNamed(Routes.CHOOSEROLE);
      } catch (e) {
        Get.snackbar('Error', 'Invalid OTP');
      }
    } finally {
      isLoading.value = false;
    }



  }

  void resetAuthState() {
    isOTPScreen.value = false;
    phoneController.clear();
    otpController.clear();
  }

}
