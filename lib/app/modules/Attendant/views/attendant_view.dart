import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/attendant_controller.dart';

class AttendantView extends GetView<AttendantController> {
  const AttendantView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AttendantView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AttendantView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
