import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

class WelcomeController extends GetxController {
  final AudioPlayer _player = AudioPlayer();
  var isAnimating = false.obs;

  Future<void> onGetStarted() async {
    HapticFeedback.mediumImpact();
    await _player.play(AssetSource('sounds/click.mp3'));

    isAnimating.value = true;

    await Future.delayed(const Duration(milliseconds: 800));

    // Navigate to next screen later
    // Get.toNamed(AppRoutes.personalDetails);
  }
}