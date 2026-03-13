import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/step_progress_indicator.dart';
import '../../../../core/widgets/animated_gradient_button.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '6workout_frequency_screen.dart';

class WorkoutPreferenceScreen extends StatefulWidget {
  const WorkoutPreferenceScreen({super.key});

  @override
  State<WorkoutPreferenceScreen> createState() =>
      _WorkoutPreferenceScreenState();
}

class _WorkoutPreferenceScreenState extends State<WorkoutPreferenceScreen>
    with TickerProviderStateMixin {

  late AnimationController _entryController;
  late VideoPlayerController _videoController;

  final Set<String> selectedPreferences = <String>{};

  final List<Map<String, dynamic>> preferences = [
    {"title": "Gym Workout", "icon": Icons.fitness_center},
    {"title": "Home Workout", "icon": Icons.home},
    {"title": "Outdoor Training", "icon": Icons.park},
    {"title": "Yoga / Mobility", "icon": Icons.self_improvement},
    {"title": "No Preference", "icon": Icons.check_circle_outline},
  ];

  @override
  void initState() {
    super.initState();

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    _videoController = VideoPlayerController.asset(
      'assets/animations/workout.mp4',
    )
      ..initialize().then((_) {
        setState(() {});
        _videoController
          ..setLooping(true)
          ..setVolume(0)
          ..play();
      });
  }

  @override
  void dispose() {
    _entryController.dispose();
    _videoController.dispose();
    super.dispose();
  }

  void _goNext() {
    if (selectedPreferences.isEmpty) return;

    Get.to(
          () => const WorkoutFrequencyScreen(),
      transition: Transition.rightToLeftWithFade,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {

    final bool isEnabled = selectedPreferences.isNotEmpty;

    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: _entryController,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 20),

                const StepProgressIndicator(
                  currentStep: 5,
                  totalSteps: 7,
                ),

                const SizedBox(height: 25),

                /// 🎥 Snow Leopard Video
                if (_videoController.value.isInitialized)


                const SizedBox(height: 25),

                Text(
                  "Where do you prefer to workout?",
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),


                    const Text(
                      "Select one or more options",
                      style: TextStyle(color: Colors.grey),
                    ),
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: SizedBox(
                          height: 200,
                          //width: double.infinity,
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: SizedBox(
                              width: _videoController.value.size.width,
                              height: _videoController.value.size.height,
                              child: VideoPlayer(_videoController),
                            ),
                          ),
                        ),
                      ),
                    ),

                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: preferences.length,
                    itemBuilder: (context, index) {
                      final item = preferences[index];
                      return _buildCard(
                        title: item["title"] as String,
                        icon: item["icon"] as IconData,
                      );
                    },
                  ),
                ),

                AnimatedGradientButton(
                  text: isEnabled
                      ? "CONTINUE (${selectedPreferences.length})"
                      : "SELECT OPTION",
                  onTap: isEnabled ? _goNext : () {},
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
  }) {
    final bool isSelected = selectedPreferences.contains(title);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedPreferences.remove(title);
          } else {
            selectedPreferences.add(title);
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isSelected
              ? AppColors.primaryBlue.withOpacity(0.1)
              : Colors.white,
          border: Border.all(
            color: isSelected
                ? AppColors.primaryBlue
                : Colors.grey.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 28,
              color: AppColors.primaryBlue,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 24,
              width: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? AppColors.primaryBlue
                    : Colors.transparent,
                border: Border.all(
                  color: AppColors.primaryBlue,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(
                Icons.check,
                size: 16,
                color: Colors.white,
              )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}