import 'package:calculator/features/calculator/controllers/calculator_controller.dart';
import 'package:get/get.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CalculatorController());
  }
}
