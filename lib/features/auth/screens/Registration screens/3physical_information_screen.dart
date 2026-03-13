import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/step_progress_indicator.dart';
import '../../../../core/widgets/animated_gradient_button.dart';
import 'package:get/get.dart';
import '4fitness_goals_screen.dart';


class PhysicalInformationScreen extends StatefulWidget {
  const PhysicalInformationScreen({super.key});

  @override
  State<PhysicalInformationScreen> createState() =>
      _PhysicalInformationScreenState();
}

class _PhysicalInformationScreenState
    extends State<PhysicalInformationScreen>
    with TickerProviderStateMixin {

  int selectedAge = 22;
  String selectedGender = "Male";
  double height = 170;
  double weight = 70;

  double bmi = 0;
  String bmiStatus = "Normal";

  late AnimationController _entryController;

  @override
  void initState() {
    super.initState();
    _calculateBMI();

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  void _calculateBMI() {
    double heightInMeters = height / 100;
    bmi = weight / (heightInMeters * heightInMeters);

    if (bmi < 18.5) {
      bmiStatus = "Underweight";
    } else if (bmi < 24.9) {
      bmiStatus = "Normal";
    } else if (bmi < 29.9) {
      bmiStatus = "Overweight";
    } else {
      bmiStatus = "Obese";
    }
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  void _goNext() {
    Get.to(
          () => const FitnessGoalsScreen(),
      transition: Transition.rightToLeftWithFade,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
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
              child: SingleChildScrollView(
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
                      "Your Physical Stats",
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 30),

                    /// AGE PICKER
                    _buildGlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Age"),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 80,
                            child: ListWheelScrollView.useDelegate(
                              itemExtent: 30,
                              physics: const FixedExtentScrollPhysics(),
                              onSelectedItemChanged: (index) {
                                setState(() => selectedAge = index + 10);
                              },
                              childDelegate: ListWheelChildBuilderDelegate(
                                builder: (context, index) {
                                  final age = index + 10;
                                  final isSelected = age == selectedAge;

                                  return AnimatedDefaultTextStyle(
                                    duration: const Duration(milliseconds: 300),
                                    style: TextStyle(
                                      fontSize: isSelected ? 28 : 20,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: isSelected
                                          ? AppColors.primaryBlue
                                          : Colors.grey,
                                    ),
                                    child: Center(child: Text("$age")),
                                  );
                                },
                                childCount: 80,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// BIG GENDER CARDS
                    Row(
                      children: [
                        Expanded(child: _buildGenderCard("Male")),
                        const SizedBox(width: 15),
                        Expanded(child: _buildGenderCard("Female")),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// HEIGHT
                    _buildGlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Height: ${height.toInt()} cm"),
                          Slider(
                            value: height,
                            min: 120,
                            max: 220,
                            activeColor: AppColors.primaryBlue,
                            onChanged: (value) {
                              setState(() {
                                height = value;
                                _calculateBMI();
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// WEIGHT
                    _buildGlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Weight: ${weight.toInt()} kg"),
                          Slider(
                            value: weight,
                            min: 40,
                            max: 150,
                            activeColor: AppColors.primaryGreen,
                            onChanged: (value) {
                              setState(() {
                                weight = value;
                                _calculateBMI();
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    /// DYNAMIC BODY IMAGE
                    // Center(
                    //   child: AnimatedSwitcher(
                    //     duration: const Duration(milliseconds: 500),
                    //     child: Image.asset(
                    //       _getBmiImage(),
                    //       key: ValueKey(bmiStatus),
                    //       height: 120,
                    //     ),
                    //   ),
                    // ),

                    const SizedBox(height: 20),

                    /// BMI CARD
                    _buildGlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Your BMI"),
                          const SizedBox(height: 10),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 400),
                            child: Text(
                              "${bmi.toStringAsFixed(1)} ($bmiStatus)",
                              key: ValueKey(bmi),
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: _getBmiColor(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

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
      ),
    );
  }

  // String _getBmiImage() {
  //   switch (bmiStatus) {
  //     case "Underweight":
  //       return "assets/images/underweight.png";
  //     case "Normal":
  //       return "assets/images/fit.png";
  //     case "Overweight":
  //       return "assets/images/overweight.png";
  //     default:
  //       return "assets/images/obese.png";
  //   }
  // }

  Color _getBmiColor() {
    switch (bmiStatus) {
      case "Normal":
        return Colors.green;
      case "Underweight":
        return Colors.orange;
      default:
        return Colors.red;
    }
  }

  Widget _buildGenderCard(String gender) {
    final isSelected = selectedGender == gender;

    return GestureDetector(
      onTap: () {
        setState(() => selectedGender = gender);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: isSelected ? AppColors.primaryGradient : null,
          color: isSelected ? null : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              gender == "Male" ? Icons.male : Icons.female,
              size: 40,
              color: isSelected ? Colors.white : Colors.grey,
            ),
            const SizedBox(height: 10),
            Text(
              gender,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            blurRadius: 15,
            color: Colors.black.withOpacity(0.05),
          )
        ],
      ),
      child: child,
    );
  }
}