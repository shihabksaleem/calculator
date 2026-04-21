import 'package:calculator/core/theme/app_theme.dart';
import 'package:calculator/features/calculator/controllers/calculator_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrecisionSelector extends GetView<CalculatorController> {
  const PrecisionSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "DIGIT PRECISION",
          style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5),
        ),
        const SizedBox(height: 12),
        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [2, 4, 6, 8, 10].map((val) => _buildOption(context, val)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildOption(BuildContext context, int val) {
    final isSelected = controller.precision.value == val;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => controller.updatePrecision(val),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : (isDark ? AppTheme.operatorColorDark : AppTheme.operatorColorLight),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          val.toString(),
          style: TextStyle(
            color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
