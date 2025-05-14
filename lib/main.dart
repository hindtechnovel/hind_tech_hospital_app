import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';  // <<< ADD THIS
import 'package:google_fonts/google_fonts.dart';
import 'package:hind_tech_hospital/app/modules/Reception/controllers/reception_controller.dart';
import 'package:hind_tech_hospital/app/modules/chooserole/controllers/chooserole_controller.dart';
import 'package:hind_tech_hospital/app/modules/patient/controllers/patient_controller.dart';
import 'package:hind_tech_hospital/app/modules/phone_auth/controllers/phone_auth_controller.dart';

import 'app/Providers/UserController.dart';
import 'app/routes/app_pages.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

import 'app/translations/translations.dart';
import 'app/widgets/AuthGate.dart';
import 'helperClasses/AppStorage.dart';  // ADD this

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(ChooseroleController());
  Get.put(PhoneAuthController());
  Get.put(UserController());
  Get.put(PatientController());
  Get.put(ReceptionController());

  // Initialize FCM
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Request permissions for iOS (optional but recommended)
  await messaging.requestPermission();

  runApp(
      GetMaterialApp(
        title: "HindTech Hospital",
        translations: AppTranslations(),
        locale: await AppStorage.getValue('locale') != null
            ? Locale(await AppStorage.getValue('locale'))
            : Get.deviceLocale,// 👈 Add this
        fallbackLocale: Locale('en', 'US'),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.deepPurple, // Main app color
          scaffoldBackgroundColor: Colors.white, // Background of screens
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            elevation: 0,
            titleTextStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            centerTitle: true,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Colors.deepPurple,
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.deepPurple),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.deepPurple, width: 2),
            ),
            labelStyle: TextStyle(color: Colors.deepPurple),
            hintStyle: TextStyle(color: Colors.grey),
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
          textTheme: TextTheme(
            headlineLarge: GoogleFonts.aBeeZee(
              fontSize: 20,
              color: Colors.purple,
              fontWeight: FontWeight.bold),
            bodyLarge: GoogleFonts.aBeeZee(
              fontSize: 14,
              color: Colors.green.shade900,
              fontWeight: FontWeight.bold),
            bodyMedium: GoogleFonts.aBeeZee(
              fontSize: 12,
              color: Colors.blue.shade900,
              fontWeight: FontWeight.bold),
            bodySmall: GoogleFonts.aBeeZee(
                fontSize: 10,
                color: Colors.blue.shade900,
                fontWeight: FontWeight.bold),
            labelLarge: GoogleFonts.aBeeZee(
                fontSize: 14,
                color: Colors.red.shade900,
                fontWeight: FontWeight.bold),
            labelMedium: GoogleFonts.aBeeZee(
                fontSize: 12,
                color: Colors.brown.shade900,
                fontWeight: FontWeight.bold),
            labelSmall: GoogleFonts.aBeeZee(
                fontSize: 10,
                color: Colors.orange.shade900,
                fontWeight: FontWeight.bold),

          ),
          iconTheme: IconThemeData(
            color: Colors.deepPurple,
            size: 24,
          ),
          snackBarTheme: SnackBarThemeData(backgroundColor:Colors.blueGrey, ),
          colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: Colors.deepPurpleAccent,
          ),
        ),
        // initialRoute: FirebaseAuth.instance.currentUser == null
        //     ? Routes.PHONE_AUTH // 👈 if not logged in
        //     : Routes.CHOOSEROLE,
        getPages: AppPages.routes,
        home: AuthGate(),
      )

  );
}