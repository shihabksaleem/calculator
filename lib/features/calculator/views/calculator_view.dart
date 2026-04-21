import 'package:calculator/features/calculator/controllers/calculator_controller.dart';
import 'package:calculator/features/calculator/views/widgets/calc_button.dart';
import 'package:calculator/features/calculator/views/history_view.dart';
import 'package:calculator/features/calculator/views/widgets/history_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// The main UI for the Calculator application.
class CalculatorView extends GetView<CalculatorController> {
  const CalculatorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Obx(
          () => IconButton(
            icon: Icon(controller.isDarkMode.value ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
            onPressed: () => controller.toggleTheme(),
          ),
        ),
        title: const Text("Calculator"),
        centerTitle: true,
        actions: [
          // Access Precision & Application Settings
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Get.bottomSheet(const SettingsBottomSheet()),
          ),
          // Advanced History Page button
          IconButton(icon: const Icon(Icons.history_rounded), onPressed: () => Get.to(() => const HistoryView())),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // responsive layout using Column and Expanded
            return Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    alignment: Alignment.bottomRight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Ongoing Equation Display
                        Obx(
                          () => FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              controller.equation.value,
                              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w300),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Result Display
                        Obx(
                          () => Visibility(
                            visible: controller.isFinalResult.value,
                            maintainSize: true,
                            maintainAnimation: true,
                            maintainState: true,
                            child: SizedBox(
                              height: 80, // Stable height for result line
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  controller.result.value,
                                  style: TextStyle(
                                    fontSize: 60,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Lower Section: Button keypad grid
                Expanded(
                  flex: 3, // Keypad takes priority
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
                    ),
                    child: Column(
                      children: [
                        Expanded(child: _buildButtonRow(['AC', 'C', '%', '÷'])),
                        Expanded(child: _buildButtonRow(['7', '8', '9', '×'])),
                        Expanded(child: _buildButtonRow(['4', '5', '6', '-'])),
                        Expanded(child: _buildButtonRow(['1', '2', '3', '+'])),
                        Expanded(child: _buildButtonRow(['0', '.', '='])),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Helper to build a row of calculator buttons
  Widget _buildButtonRow(List<String> buttons) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons.map((text) {
        return CalcButton(
          text: text,
          // Special logic for the wide '0' button
          isLarge: text == '0' && buttons.length == 3,
          onTap: () => controller.onButtonPressed(text),
        );
      }).toList(),
    );
  }
}
