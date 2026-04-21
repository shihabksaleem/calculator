import 'package:calculator/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A reusable, premium-styled calculator button.
class CalcButton extends StatelessWidget {
  final String text; // Button label
  final Color? color; // Optional custom background color
  final Color? textColor; // Optional custom text color
  final VoidCallback onTap; // Callback on button press
  final bool isLarge; // Whether the button should take more horizontal space

  const CalcButton({
    super.key,
    required this.text,
    this.color,
    this.textColor,
    required this.onTap,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color defaultColor;
    Color defaultTextColor;

    // Determine colors based on button type
    if (text == '=') {
      defaultColor = Colors.transparent; 
      defaultTextColor = Colors.white;
    } else if (text == 'AC') {
      defaultColor = isDark ? AppTheme.numberColorDark : AppTheme.numberColorLight;
      defaultTextColor = AppTheme.acColor;
    } else if (text == 'C') {
      defaultColor = isDark ? AppTheme.numberColorDark : AppTheme.numberColorLight;
      defaultTextColor = AppTheme.acColor; // Matched with AC
    } else if (_isOperator(text)) {
      defaultColor = isDark ? AppTheme.operatorColorDark : AppTheme.operatorColorLight;
      defaultTextColor = isDark ? Colors.white : Colors.black87;
    } else if (_isAction(text)) {
      defaultColor = isDark ? AppTheme.actionColorDark : AppTheme.actionColorLight;
      defaultTextColor = isDark ? Colors.white : Colors.black87;
    } else {
      defaultColor = isDark ? AppTheme.numberColorDark : AppTheme.numberColorLight;
      defaultTextColor = isDark ? Colors.white : Colors.black;
    }

    final bool isEquals = text == '=';

    return Expanded(
      flex: isLarge ? 2 : 1,
      child: Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: isEquals
              ? const LinearGradient(
                  colors: AppTheme.equalsGradient,
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
              : null,
          border: isDark && !isEquals ? Border.all(
            color: Colors.white.withOpacity(0.08), // Subtle rim lighting
            width: 1.5,
          ) : null,
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.1),
              blurRadius: 15,
              spreadRadius: 0,
              offset: isDark ? const Offset(0, 0) : const Offset(0, 5),
            ),
          ],
        ),
        child: Material(
          color: isEquals ? Colors.transparent : (color ?? defaultColor),
          borderRadius: BorderRadius.circular(24),
          child: InkWell(
            onTap: () {
              HapticFeedback.lightImpact(); // Add tactile feedback
              onTap();
            },
            borderRadius: BorderRadius.circular(24),
            child: Semantics(
              label: _getSemanticsLabel(text),
              button: true,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                alignment: Alignment.center,
                child: Text(
                  text == '-' ? '\u2212' : text, // Use proper minus sign
                  style: TextStyle(
                    color: textColor ?? defaultTextColor,
                    fontSize: text == '=' ? 36 : 28, // Maintain larger equals sign
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Helper to check if the button is a mathematical operator
  bool _isOperator(String text) {
    return text == '+' || text == '-' || text == '×' || text == '÷' || text == '=' || text == '%';
  }

  /// Helper to check if the button is a special action (Clear, Percent)
  bool _isAction(String text) {
    return text == 'AC' || text == 'C' || text == '%' || text == '+/-';
  }

  /// Friendly labels for screen readers
  String _getSemanticsLabel(String text) {
    switch (text) {
      case 'AC':
        return 'All Clear';
      case 'C':
        return 'Clear Entry';
      case '+':
        return 'Plus';
      case '-':
        return 'Minus';
      case '×':
        return 'Multiply';
      case '÷':
        return 'Divide';
      case '=':
        return 'Equals';
      case '%':
        return 'Percentage';
      case '.':
        return 'Decimal point';
      default:
        return text;
    }
  }
}
