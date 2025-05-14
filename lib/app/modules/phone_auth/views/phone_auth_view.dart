import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../../../widgets/languagepickerwidget.dart';
import '../controllers/phone_auth_controller.dart';

class PhoneAuthView extends GetView<PhoneAuthController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Obx(
          () => SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),

                // Lottie Animation
                Lottie.asset(
                  'Assets/Lottie/introductionScreen.json',
                  height: 200,
                ),

                const SizedBox(height: 20),

                // Title Text
                Text(
                  controller.isOTPScreen.value
                      ? "enter_otp".tr
                      : "hospital_name".tr,
                  style: GoogleFonts.aBeeZee(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[800],
                  ),
                ),

                const SizedBox(height: 20),

                // Phone Input or OTP Input
                controller.isOTPScreen.value
                    ? _buildOTPInput(context)
                    : _buildPhoneInput(context),

                const SizedBox(height: 30),

                // Info Text
                Text(
                  "privacy_note".tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.blueGrey[500],
                    fontSize: 14,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LanguagePickerWidget(),
                    Text(
                      'change_language'.tr,
                      style: GoogleFonts.acme(color: Colors.green),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Phone Input Widget
  Widget _buildPhoneInput(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              CountryCodePicker(
                onChanged: (code) =>
                    controller.countryCode.value = code.dialCode ?? "+91",
                initialSelection: 'IN',
                favorite: ['+91', 'IN'],
                showCountryOnly: false,
                alignLeft: false,
                padding: EdgeInsets.zero,
              ),
              Expanded(
                child: TextField(
                  controller: controller.phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "enter_phone".tr,
                    hintStyle: TextStyle(color: Colors.blueGrey[400]),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        Obx(
              () => ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueGrey[700],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
            ),
            onPressed: controller.isLoading.value ? null : controller.sendOTP,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.sms, color: Colors.white),
                const SizedBox(width: 10),
                Text(
                  controller.isLoading.value ? "Sending OTP..." : "send_otp".tr,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ],
            ),
          ),
        )

      ],
    );
  }

  // OTP Input Widget
  Widget _buildOTPInput(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller.otpController,
          keyboardType: TextInputType.number,
          maxLength: 6,
          decoration: InputDecoration(
            hintText: "enter_otp".tr,
            counterText: "",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueGrey.shade700, width: 2),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
          ),
        ),
        const SizedBox(height: 20),
        Obx(
          () =>  ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 40),
                  ),
                  onPressed: controller.verifyOTP,
                  icon: const Icon(Icons.check_circle, color: Colors.white),
                  label: Text(controller.isLoading.value ? "Verifying..." :"verify_otp".tr,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
        )
      ],
    );
  }
}
