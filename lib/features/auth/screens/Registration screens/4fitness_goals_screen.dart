import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/step_progress_indicator.dart';
import '../../../../core/widgets/animated_gradient_button.dart';
import 'package:get/get.dart';

import '5.1meal_type_selection_screen.dart';


class FitnessGoalsScreen extends StatefulWidget {
  const FitnessGoalsScreen({super.key});

  @override
  State<FitnessGoalsScreen> createState() => _FitnessGoalsScreenState();
}

class _FitnessGoalsScreenState extends State<FitnessGoalsScreen>
    with TickerProviderStateMixin {

  String? selectedGoal;
  late AnimationController _entryController;

  final List<Map<String, dynamic>> goals = [
    {
      "title": "Lose Weight",
      "icon": Icons.trending_down,
    },
    {
      "title": "Build Muscle",
      "icon": Icons.fitness_center,
    },
    {
      "title": "Stay Fit",
      "icon": Icons.favorite,
    },
    {
      "title": "Improve Endurance",
      "icon": Icons.directions_run,
    },
  ];

  @override
  void initState() {
    super.initState();

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  void _goNext() {
    if (selectedGoal == null) return;

    Get.to(
          () => const MealTypeScreen(),
      transition: Transition.rightToLeftWithFade,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: _entryController,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.1),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: _entryController,
                curve: Curves.easeOut,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const SizedBox(height: 20),

                  const StepProgressIndicator(
                    currentStep: 4,
                    totalSteps: 7,
                  ),

                  const SizedBox(height: 30),

                  Text(
                    "What's Your Goal?",
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Choose your primary fitness goal",
                    style: TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 30),

                  Expanded(
                    child: ListView.builder(
                      itemCount: goals.length,
                      itemBuilder: (context, index) {
                        final goal = goals[index];
                        return _buildGoalCard(
                          title: goal["title"],
                          icon: goal["icon"],
                        );
                      },
                    ),
                  ),

                  AnimatedGradientButton(
                    text: "CONTINUE",
                    onTap: _goNext,
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGoalCard({
    required String title,
    required IconData icon,
  }) {
    final isSelected = selectedGoal == title;

    return GestureDetector(
      onTap: () {
        setState(() => selectedGoal = title);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: isSelected ? AppColors.primaryGradient : null,
          color: isSelected ? null : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 15,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? Colors.white : AppColors.primaryBlue,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Colors.white,
              ),
          ],
        ),
      ),
    );
  }
}