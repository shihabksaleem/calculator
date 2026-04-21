import 'package:calculator/features/calculator/controllers/calculator_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:calculator/core/services/storage_service.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  // Initialize GetStorage for testing
  TestWidgetsFlutterBinding.ensureInitialized();
  
  group('CalculatorController Tests', () {
    late CalculatorController controller;

    setUp(() async {
      await GetStorage.init();
      controller = CalculatorController();
      controller.onInit();
      controller.clear();
    });

    test('Initial state should be 0', () {
      expect(controller.equation.value, '0');
      expect(controller.result.value, '0');
    });

    test('Number input should update equation', () {
      controller.onButtonPressed('1');
      controller.onButtonPressed('2');
      expect(controller.equation.value, '12');
    });

    test('Decimal validation: only one dot allowed per segment', () {
      controller.onButtonPressed('5');
      controller.onButtonPressed('.');
      controller.onButtonPressed('5');
      controller.onButtonPressed('.'); // Should be ignored
      expect(controller.equation.value, '5.5');
      
      controller.onButtonPressed('+');
      controller.onButtonPressed('.');
      expect(controller.equation.value, '5.5+0.');
    });

    test('Chained operations logic', () {
      controller.onButtonPressed('2');
      controller.onButtonPressed('+');
      controller.onButtonPressed('3');
      controller.onButtonPressed('×');
      controller.onButtonPressed('4');
      // 2 + 3 * 4 = 14
      controller.onButtonPressed('=');
      expect(controller.equation.value, '14');
    });

    test('Precision setting works', () {
      controller.onButtonPressed('1');
      controller.onButtonPressed('0');
      controller.onButtonPressed('÷');
      controller.onButtonPressed('3');
      
      controller.updatePrecision(4);
      controller.onButtonPressed('=');
      expect(controller.equation.value, '3.3333');
      
      controller.clear();
      controller.onButtonPressed('1');
      controller.onButtonPressed('0');
      controller.onButtonPressed('÷');
      controller.onButtonPressed('3');
      controller.updatePrecision(2);
      controller.onButtonPressed('=');
      expect(controller.equation.value, '3.33');
    });

    test('Division by zero handling', () {
      controller.onButtonPressed('5');
      controller.onButtonPressed('÷');
      controller.onButtonPressed('0');
      controller.onButtonPressed('=');
      // result.value was set to '0' on eval fail in my logic, 
      // but _formatResult returns "Error" for Inf.
      // Wait, let's see. double val = 5/0 is Infinity.
      expect(controller.equation.value, 'Error');
    });
  });
}
