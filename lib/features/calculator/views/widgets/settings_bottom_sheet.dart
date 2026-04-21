import 'package:calculator/features/calculator/controllers/calculator_controller.dart';
import 'package:calculator/features/calculator/views/widgets/precision_selector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// A focused bottom sheet for application settings like decimal precision.
class SettingsBottomSheet extends GetView<CalculatorController> {
  const SettingsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF1C1C1E) // Lighter charcoal for Dark Mode elevation
            : Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Text('Settings', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          const PrecisionSelector(),
          const SizedBox(height: 10),
          const Divider(),
          const SizedBox(height: 10),
          // Theme explanation or other settings can go here
          const Text("Decimal Precision", style: TextStyle(color: Colors.grey, fontSize: 13)),
        ],
      ),
    );
  }
}
