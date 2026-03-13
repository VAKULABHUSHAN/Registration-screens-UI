import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

class PersonalDetailsController extends GetxController {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isPasswordVisible = false.obs;
  var isLoading = false.obs;

  final formKey = GlobalKey<FormState>();

  void togglePassword() {
    HapticFeedback.selectionClick();
    isPasswordVisible.toggle();
  }

  Future<void> onContinue() async {
    if (!formKey.currentState!.validate()) {
      HapticFeedback.vibrate();
      return;
    }

    isLoading.value = true;
    HapticFeedback.mediumImpact();

    await Future.delayed(const Duration(seconds: 1));

    isLoading.value = false;

    // Navigate to next screen later
    // Get.to(PhysicalInformationScreen());
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}