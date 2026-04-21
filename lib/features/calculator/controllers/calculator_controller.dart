import 'package:calculator/core/services/storage_service.dart';
import 'package:calculator/features/calculator/models/history_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:math_expressions/math_expressions.dart';

/// The core controller for the Calculator, handling logic, state, and persistence.
class CalculatorController extends GetxController {
  // Observables for reactive UI updates
  var equation = '0'.obs; // The ongoing mathematical expression
  var result = '0'.obs; // Live preview of the result
  var precision = 2.obs; // User-defined decimal precision
  var history = <HistoryItem>[].obs; // List of past calculations
  var searchQuery = ''.obs; // Current search term for history
  var isDarkMode = true.obs; // Current theme state
  var isFinalResult = false.obs; // Tracks if display is showing a calculated result

  @override
  void onInit() {
    super.onInit();
    // Load persisted settings from StorageService
    precision.value = StorageService.getPrecision();
    
    // Load history and filter out any "Undefined" results that might have been stored previously
    final storedHistory = StorageService.getHistory();
    history.assignAll(storedHistory.where((item) => item.result != "Undefined"));
    
    // If we filtered anything, sync back to storage
    if (history.length != storedHistory.length) {
      StorageService.saveHistory(history);
    }
    
    isDarkMode.value = StorageService.isDarkMode();
  }

  /// Main handler for all button presses
  void onButtonPressed(String buttonText) {
    if (buttonText == 'AC') {
      clear();
    } else if (buttonText == 'C') {
      delete();
    } else if (buttonText == '=') {
      calculate();
    } else if (buttonText == '.') {
      addDecimal();
    } else if (_isOperator(buttonText)) {
      addOperator(buttonText);
    } else {
      addNumber(buttonText);
    }
  }

  /// Appends a number to the current equation
  void addNumber(String number) {
    if (isFinalResult.value) {
      equation.value = number;
      result.value = '0';
      isFinalResult.value = false;
    } else if (equation.value == '0') {
      equation.value = number;
    } else {
      equation.value += number;
    }
  }

  /// Handles decimal point logic, preventing multiple dots in a single segment
  void addDecimal() {
    if (isFinalResult.value) {
      equation.value = '0.';
      isFinalResult.value = false;
      return;
    }
    String currentEquation = equation.value;

    // Split the equation by operators to isolate the current number segment
    List<String> parts = currentEquation.split(RegExp(r'[+\-×÷]'));
    String lastSegment = parts.isEmpty ? "" : parts.last;

    if (!lastSegment.contains('.')) {
      if (lastSegment.isEmpty || _isOperator(currentEquation[currentEquation.length - 1])) {
        // If it starts with a dot or follows an operator, add a leading zero
        equation.value += '0.';
      } else {
        equation.value += '.';
      }
    }
  }

  /// Appends an operator to the equation, replacing the previous one if necessary
  void addOperator(String op) {
    if (isFinalResult.value) {
      if (result.value == "Undefined") {
        Get.closeAllSnackbars();
        Get.snackbar(
          "Invalid Operation",
          "Clear the error before continuing",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orangeAccent,
          colorText: Colors.white,
        );
        return;
      }
      // Start from previous result if user types an operator
      equation.value = result.value + op;
      result.value = '0';
      isFinalResult.value = false;
      return;
    }

    String currentEquation = equation.value;
    if (currentEquation.isEmpty) return;

    String lastChar = currentEquation[currentEquation.length - 1];

    if (_isOperator(lastChar)) {
      // Replace the last operator if the user changes their mind
      equation.value = currentEquation.substring(0, currentEquation.length - 1) + op;
    } else if (lastChar == '.') {
      // Handle the case where user types "5. +" -> "5.0 +"
      equation.value += '0' + op;
    } else {
      equation.value += op;
    }
  }

  /// Deletes the last character from the equation
  void delete() {
    if (isFinalResult.value) {
      clear();
      isFinalResult.value = false;
      return;
    }
    if (equation.value.length <= 1) {
      equation.value = '0';
      result.value = '0';
    } else {
      equation.value = equation.value.substring(0, equation.value.length - 1);
    }
  }

  /// Resets the calculator state
  void clear() {
    equation.value = '0';
    result.value = '0';
  }

  /// Helper to check if a character is a mathematical operator
  bool _isOperator(String char) {
    return char == '+' || char == '-' || char == '×' || char == '÷' || char == '%' || char == 'x';
  }

  /// Evaluates the current equation in real-time as the user types
  void _liveCalculate() {
    try {
      // Prepare expression for math_expressions parser
      String expression = equation.value.replaceAll('×', '*').replaceAll('÷', '/');

      // Remove trailing operator for live preview evaluation
      if (_isOperator(expression[expression.length - 1])) {
        expression = expression.substring(0, expression.length - 1);
      }

      GrammarParser p = GrammarParser();
      Expression exp = p.parse(expression);
      ContextModel cm = ContextModel();
      RealEvaluator evaluator = RealEvaluator(cm);
      num eval = evaluator.evaluate(exp);

      result.value = _formatResult(eval);
    } catch (e) {
      // Silent fail for live preview to keep UI clean during incomplete typing
    }
  }

  /// Performs the final calculation and updates history
  void calculate() {
    try {
      String expression = equation.value.replaceAll('×', '*').replaceAll('÷', '/');

      GrammarParser p = GrammarParser();
      Expression exp = p.parse(expression);
      ContextModel cm = ContextModel();
      RealEvaluator evaluator = RealEvaluator(cm);
      num eval = evaluator.evaluate(exp);

      String finalResult = _formatResult(eval);

      // Store successful calculation in history if it's a valid number
      if (finalResult != "Undefined") {
        final historyItem = HistoryItem(equation: equation.value, result: finalResult, timestamp: DateTime.now());
        history.insert(0, historyItem);
        StorageService.saveHistory(history);
      }

      // Keep the equation visible and only update the result line
      result.value = finalResult;
      isFinalResult.value = true; // Mark as final result
    } catch (e) {
      // UI feedback for malformed expressions
      Get.snackbar(
        "Invalid Operation",
        "Expression could not be evaluated",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  /// Formats the final double value into a user-friendly string based on precision
  String _formatResult(num val) {
    if (val.isInfinite || val.isNaN) return "Undefined";

    // If it's a whole number, remove decimal part
    if (val == val.toInt()) {
      return val.toInt().toString();
    }

    // Apply precision and remove trailing zeros
    return val.toStringAsFixed(precision.value).replaceFirst(RegExp(r'\.?0*$'), '');
  }

  /// Updates current decimal precision and saves to local storage
  void updatePrecision(int p) {
    precision.value = p;
    StorageService.savePrecision(p);
    // If there is an active result, re-calculate it with new precision
    if (isFinalResult.value) {
      calculate();
    }
  }

  /// Toggles between light and dark themes
  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    StorageService.saveThemeMode(isDarkMode.value);
  }

  /// Clears the history log
  void clearHistory() {
    history.clear();
    StorageService.saveHistory(history);
  }

  /// Deletes a specific calculation from history
  void deleteHistoryItem(int index) {
    history.removeAt(index);
    StorageService.saveHistory(history);
  }

  /// Reuses a past calculation's result in the current display
  void reuseHistoryItem(HistoryItem item) {
    if (item.result == "Undefined") {
      Get.closeAllSnackbars();
      Get.snackbar(
        "Invalid Reuse",
        "Cannot reuse an undefined calculation",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orangeAccent,
        colorText: Colors.white,
      );
      return;
    }
    equation.value = item.result;
    result.value = '0';
    isFinalResult.value = false;
    Get.back(); // Return to calculator
  }

  /// Returns a filtered list of history items based on search query
  List<HistoryItem> get filteredHistory {
    if (searchQuery.value.isEmpty) return history.toList();
    return history
        .where((item) => item.equation.contains(searchQuery.value) || item.result.contains(searchQuery.value))
        .toList();
  }
}
