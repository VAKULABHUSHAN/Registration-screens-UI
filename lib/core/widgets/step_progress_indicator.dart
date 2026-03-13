import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class StepProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const StepProgressIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (index) {
        final isActive = index < currentStep;

        return Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            height: 8,
            decoration: BoxDecoration(
              gradient: isActive
                  ? AppColors.primaryGradient
                  : null,
              color: isActive
                  ? null
                  : Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        );
      }),
    );
  }
}