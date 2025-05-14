import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/pharmacist_controller.dart';

class PharmacistView extends GetView<PharmacistController> {
  const PharmacistView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PharmacistView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'PharmacistView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
