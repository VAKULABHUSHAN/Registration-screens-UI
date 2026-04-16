import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/step_progress_indicator.dart';
import '../../../../core/widgets/animated_gradient_button.dart';
import '3physical_information_screen.dart';

class NationalitySelectionScreen extends StatefulWidget {
  const NationalitySelectionScreen({super.key});

  @override
  State<NationalitySelectionScreen> createState() =>
      _NationalitySelectionScreenState();
}

class _NationalitySelectionScreenState
    extends State<NationalitySelectionScreen>
    with TickerProviderStateMixin {

  String? selectedNationality;
  String? selectedState;

  late AnimationController _entryController;

  final List<String> nationalities = [
    "Indian",
    "American",
    "Canadian",
    "Australian",
    "Other",
  ];

  final List<String> indianStates = [
    "Tamil Nadu",
    "Karnataka",
    "Kerala",
    "Maharashtra",
    "Delhi",
    "Gujarat",
    "Uttar Pradesh",
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
    if (selectedNationality == null) return;

    Get.to(
          () => const PhysicalInformationScreen(),
      transition: Transition.rightToLeftWithFade,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
                    currentStep: 3,
                    totalSteps: 7,
                  ),

                  const SizedBox(height: 30),

                    Text(
                      "Your Nationality?",
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                    ),

                  const SizedBox(height: 10),

                  const Text(
                    "Select your nationality",
                    style: TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 30),

                  /// NATIONALITY LIST
                  Expanded(
                    child: ListView.builder(
                      itemCount: nationalities.length,
                      itemBuilder: (context, index) {
                        return _buildNationalityCard(
                          nationalities[index],
                        );
                      },
                    ),
                  ),

                  /// STATE DROPDOWN (Only for India)
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    transitionBuilder: (child, animation) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, -0.2),
                          end: Offset.zero,
                        ).animate(animation),
                        child: FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                      );
                    },
                    child: selectedNationality == "Indian"
                        ? Padding(
                      key: const ValueKey("stateDropdown"),
                      padding: const EdgeInsets.only(bottom: 20),
                      child: DropdownButtonFormField<String>(
                        value: selectedState,
                        items: indianStates
                            .map((state) => DropdownMenuItem(
                          value: state,
                          child: Text(state),
                        ))
                            .toList(),
                        onChanged: (value) {
                          setState(() => selectedState = value);
                        },
                        decoration: InputDecoration(
                          labelText: "Select State",
                          filled: true,
                          fillColor: AppColors.surfaceContainerHigh,
                          labelStyle: const TextStyle(color: AppColors.onSurfaceVariant),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: const BorderSide(color: AppColors.outlineVariant),
                          ),
                        ),
                      ),
                    )
                        : const SizedBox.shrink(),
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

  Widget _buildNationalityCard(String title) {
    final isSelected = selectedNationality == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedNationality = title;
          selectedState = null;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: isSelected ? AppColors.primaryGradient : null,
          color: isSelected ? null : AppColors.surfaceContainerHigh,
          border: isSelected ? null : Border.all(color: AppColors.outlineVariant.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            Icon(
              Icons.public,
              size: 28,
              color: isSelected ? Colors.white : AppColors.primaryBlue,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? AppColors.onPrimaryFixed : AppColors.onSurface,
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