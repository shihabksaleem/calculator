import 'package:calculator/core/bindings/initial_binding.dart';
import 'package:calculator/core/services/storage_service.dart';
import 'package:calculator/core/theme/app_theme.dart';
import 'package:calculator/features/calculator/views/calculator_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  // Ensure Flutter engine is initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize local storage (GetStorage) for persistence
  await StorageService.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine the initial theme mode from persisted settings
    final isDarkMode = StorageService.isDarkMode();

    return GetMaterialApp(
      title: 'Professional Calculator',
      debugShowCheckedModeBanner: false,
      // Theme configurations
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      // Dependency injection binding
      initialBinding: InitialBinding(),
      // Initial screen
      home: const CalculatorView(),
    );
  }
}
