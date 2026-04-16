import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/widgets/animated_gradient_button.dart';
import '../../../../core/widgets/animated_text_field.dart';
import '../../../../core/widgets/step_progress_indicator.dart';
import '../../../../core/utils/app_colors.dart';
import '../../controllers/personal_details_controller.dart';
import '3.1nationality_screen.dart';

class PersonalDetailsScreen extends StatefulWidget {
  const PersonalDetailsScreen({super.key});

  @override
  State<PersonalDetailsScreen> createState() =>
      _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState
    extends State<PersonalDetailsScreen>
    with TickerProviderStateMixin {

  final controller = Get.put(PersonalDetailsController());

  late AnimationController _animationController;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fade = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _navigateNext() async {
    if (!controller.formKey.currentState!.validate()) return;

    controller.isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 600));
    controller.isLoading.value = false;

    Get.off(
          () =>  NationalitySelectionScreen(),
      transition: Transition.rightToLeftWithFade,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Container(
          color: AppColors.background,
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const SizedBox(height: 30),

                    /// Hero Logo
                    Center(
                      child: Hero(
                        tag: "app_logo",
                        child: Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppColors.primaryGradient,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryBlue
                                    .withOpacity(0.25),
                                blurRadius: 25,
                                spreadRadius: 2,
                              )
                            ],
                          ),
                          child: const Icon(
                            Icons.fitness_center,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    FadeTransition(
                      opacity: _fade,
                      child: const StepProgressIndicator(
                        currentStep: 2,
                        totalSteps: 7,
                      ),
                    ),

                    const SizedBox(height: 30),

                    FadeTransition(
                      opacity: _fade,
                      child: SlideTransition(
                        position: _slide,
                        child: const Text(
                          "Tell us about you",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: AppColors.onSurface,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      "Let’s start with your basic details",
                      style: TextStyle(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),

                    const SizedBox(height: 40),

                    /// Soft Card
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: AppColors.outlineVariant.withOpacity(0.1)),
                      ),
                      child: Column(
                        children: [

                          AnimatedTextField(
                            hint: "Full Name",
                            controller: controller.fullNameController,
                            textColor: AppColors.onSurface,
                            validator: (value) =>
                            value!.isEmpty
                                ? "Enter your name"
                                : null,
                          ),

                          const SizedBox(height: 20),

                          AnimatedTextField(
                            hint: "Email Address",
                            controller: controller.emailController,
                            textColor: AppColors.onSurface,
                            validator: (value) {
                              if (value == null ||
                                  !value.contains("@")) {
                                return "Enter valid email";
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          Obx(() => AnimatedTextField(
                            hint: "Password",
                            controller:
                            controller.passwordController,
                            textColor: AppColors.onSurface,
                            obscureText:
                            !controller.isPasswordVisible.value,
                            suffix: IconButton(
                              icon: Icon(
                                controller
                                    .isPasswordVisible.value
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              onPressed:
                              controller.togglePassword,
                            ),
                            validator: (value) =>
                            value!.length < 6
                                ? "Minimum 6 characters"
                                : null,
                          )),

                          const SizedBox(height: 40),

                          Obx(() =>
                              AnimatedGradientButton(
                                text: controller.isLoading.value
                                    ? "Please wait..."
                                    : "CONTINUE",
                                onTap:
                                controller.isLoading.value
                                    ? () {}
                                    : _navigateNext,
                              )),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}