import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/step_progress_indicator.dart';
import '../../../../core/widgets/animated_gradient_button.dart';
import 'package:get/get.dart';
import '8building_plan_screen.dart';

class TargetPlanScreen extends StatefulWidget {
  const TargetPlanScreen({super.key});

  @override
  State<TargetPlanScreen> createState() => _TargetPlanScreenState();
}

class _TargetPlanScreenState extends State<TargetPlanScreen>
    with TickerProviderStateMixin {

  late AnimationController _entryController;

  double targetWeight = 70;
  int? selectedWeeks;
  String? selectedIntensity;

  final List<int> weekOptions = [8, 12, 16];
  final List<String> intensityOptions = [
    "Beginner",
    "Moderate",
    "Intense"
  ];

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  void _goNext() {
    if (selectedWeeks == null || selectedIntensity == null) return;

    Get.to(
          () => const BuildingPlanScreen(),
      transition: Transition.rightToLeftWithFade,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );   }

  @override
  Widget build(BuildContext context) {
    final bool isEnabled =
        selectedWeeks != null && selectedIntensity != null;

    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: _entryController,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 20),

                const StepProgressIndicator(
                  currentStep: 7,
                  totalSteps: 7,
                ),

                const SizedBox(height: 30),

                Text(
                  "Let's Set Your Target",
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 40),

                /// 🎯 Target Weight
                Text(
                  "Target Weight: ${targetWeight.toInt()} kg",
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),

                Slider(
                  value: targetWeight,
                  min: 40,
                  max: 120,
                  divisions: 80,
                  activeColor: AppColors.primaryBlue,
                  onChanged: (value) {
                    setState(() {
                      targetWeight = value;
                    });
                  },
                ),

                const SizedBox(height: 30),

                /// ⏳ Timeline
                const Text(
                  "Timeline",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 15),

                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: weekOptions.map((weeks) {
                    final isSelected =
                        selectedWeeks == weeks;
                    return _buildSelectableCard(
                        "$weeks Weeks",
                        isSelected, () {
                      setState(() {
                        selectedWeeks = weeks;
                      });
                    });
                  }).toList(),
                ),

                const SizedBox(height: 30),

                /// 💪 Intensity
                const Text(
                  "Workout Intensity",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 15),

                Column(
                  children: intensityOptions.map((level) {
                    final isSelected =
                        selectedIntensity == level;
                    return _buildSelectableCard(
                        level, isSelected, () {
                      setState(() {
                        selectedIntensity = level;
                      });
                    });
                  }).toList(),
                ),

                const SizedBox(height: 40),

                AnimatedGradientButton(
                  text: isEnabled
                      ? "CREATE MY PLAN"
                      : "SELECT OPTIONS",
                  onTap: () {
                    if (isEnabled) _goNext();
                  },
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectableCard(
      String text,
      bool isSelected,
      VoidCallback onTap,
      ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(
            vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient:
          isSelected ? AppColors.primaryGradient : null,
          color: isSelected ? null : Colors.white,
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : Colors.grey.withOpacity(0.3),
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected
                  ? Colors.white
                  : AppColors.primaryBlue,
            ),
          ),
        ),
      ),
    );
  }
}