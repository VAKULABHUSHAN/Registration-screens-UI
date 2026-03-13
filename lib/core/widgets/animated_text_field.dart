import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class AnimatedTextField extends StatefulWidget {
  final String hint;
  final TextEditingController controller;
  final bool obscureText;
  final Widget? suffix;
  final String? Function(String?)? validator;

  const AnimatedTextField({
    super.key,
    required this.hint,
    required this.controller,
    this.obscureText = false,
    this.suffix,
    this.validator, required Color textColor,
  });

  @override
  State<AnimatedTextField> createState() => _AnimatedTextFieldState();
}

class _AnimatedTextFieldState extends State<AnimatedTextField> {
  bool isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (value) => setState(() => isFocused = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isFocused
                ? AppColors.primaryBlue
                : Colors.grey.withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: [
            if (isFocused)
              BoxShadow(
                color: AppColors.primaryBlue.withOpacity(0.1),
                blurRadius: 15,
              )
          ],
        ),
        child: TextFormField(
          controller: widget.controller,
          obscureText: widget.obscureText,
          validator: widget.validator,
          decoration: InputDecoration(
            hintText: widget.hint,
            border: InputBorder.none,
            suffixIcon: widget.suffix,
          ),
        ),
      ),
    );
  }
}