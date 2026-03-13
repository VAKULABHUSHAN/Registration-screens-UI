import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/step_progress_indicator.dart';
import '../../../../core/widgets/animated_gradient_button.dart';
import 'package:get/get.dart';

import '7target_plan_screen.dart';
class WorkoutFrequencyScreen extends StatefulWidget {
  const WorkoutFrequencyScreen({super.key});

  @override
  State<WorkoutFrequencyScreen> createState() =>
      _WorkoutFrequencyScreenState();
}

class _WorkoutFrequencyScreenState extends State<WorkoutFrequencyScreen>
    with TickerProviderStateMixin {

  late AnimationController _entryController;

  int? selectedDays;
  int? selectedDuration;

  final List<int> frequencyOptions = <int>[2, 3, 4, 5, 6];
  final List<int> durationOptions = <int>[30, 45, 60, 90];

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
    if (selectedDays == null || selectedDuration == null) return;

    Get.to(
          () => const TargetPlanScreen(),
      transition: Transition.rightToLeftWithFade,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    final bool isEnabled =
        selectedDays != null && selectedDuration != null;

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
                  currentStep: 6,
                  totalSteps: 7,
                ),

                const SizedBox(height: 30),

                Text(
                  "How often can you train?",
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 30),

                /// 🔥 Days Per Week
                const Text(
                  "Days per week",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 15),

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: frequencyOptions.length,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.2,
                  ),
                  itemBuilder: (context, index) {
                    final days = frequencyOptions[index];
                    return _buildDaysCard(days);
                  },
                ),

                const SizedBox(height: 30),

                /// 🔥 Minutes Per Session
                const Text(
                  "Minutes per session",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 15),

                /// ✅ SAFE CHECKBOX LIST
                ...List.generate(
                  durationOptions.length,
                      (index) =>
                      _buildDurationCheckbox(durationOptions[index]),
                ),

                const SizedBox(height: 40),

                AnimatedGradientButton(
                  text: isEnabled
                      ? "CONTINUE ($selectedDays Days • $selectedDuration min)"
                      : "SELECT OPTIONS",
                  onTap: () {
                    if (isEnabled) {
                      _goNext();
                    }
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
  Widget _buildDaysCard(int days) {
    final bool isSelected = selectedDays == days;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDays = days;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: isSelected ? AppColors.primaryGradient : null,
          color: isSelected ? null : Colors.white,
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : Colors.grey.withOpacity(0.3),
          ),
        ),
        child: Center(
          child: Text(
            "$days",
            style: TextStyle(
              fontSize: 20,
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

  Widget _buildDurationCheckbox(int minutes) {
    final bool isSelected = selectedDuration == minutes;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected
              ? AppColors.primaryBlue
              : Colors.grey.withOpacity(0.3),
        ),
        color: Colors.white,
      ),
      child: CheckboxListTile(
        value: isSelected,
        activeColor: AppColors.primaryBlue,
        controlAffinity: ListTileControlAffinity.leading,
        title: Text(
          minutes == 90
              ? "1.5 Hours"
              : "$minutes Minutes",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.primaryBlue,
          ),
        ),
        onChanged: (value) {
          setState(() {
            selectedDuration = minutes;
          });
        },
      ),
    );
  }
}