import 'package:flutter/material.dart';
import 'colors.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  // --- 1. State Variables (Step 4 Requirement) ---
  String _display = '0000';      // Current display value
  String _equation = '';         // Full equation string
  double _num1 = 0;              // First operand
  double _num2 = 0;              // Second operand
  String _operation = '';        // Current operation
  
  // Helper variable to check if user just pressed an operator
  // If true, next number input will reset the display
  bool _shouldStartNewInput = false; 

  // --- 2. Logic (Button Functions) ---
  void onBtnTap(String value) {
    setState(() {
      // Handle button types
      if (['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'].contains(value)) {
        _handleNumber(value);
      } else if (['+', '-', '×', '÷'].contains(value)) {
        _handleOperation(value);
      } else if (value == '=') {
        _calculateResult();
      } else if (value == 'C') {
        _clearAll();
      } else if (value == '.') {
        _addDecimal();
      } else if (value == '+/-') {
        _toggleSign();
      } else if (value == '%') {
        _calculatePercentage();
      }
    });
  }

  // Handle number buttons
  void _handleNumber(String value) {
    if (_display == '0000' || _shouldStartNewInput) {
      _display = value;
      _shouldStartNewInput = false;
    } else {
      if (_display.length < 15) {
        _display += value;
      }
    }
  }

  // Handle operations (+, -, ×, ÷)
  void _handleOperation(String value) {
    if (_operation.isNotEmpty && !_shouldStartNewInput) {
      _calculateResult();
    }

    _num1 = double.parse(_display.replaceAll(',', '')); // Save first operand
    _operation = value; // Save operation
    _equation = "$_display $value"; // Update equation text
    _shouldStartNewInput = true;
  }

  // Calculate result (=)
  void _calculateResult() {
    if (_operation.isEmpty) return;

    _num2 = double.parse(_display.replaceAll(',', '')); // Save second operand
    
    double result = 0;
    switch (_operation) {
      case '+':
        result = _num1 + _num2;
        break;
      case '-':
        result = _num1 - _num2;
        break;
      case '×':
        result = _num1 * _num2;
        break;
      case '÷':
        if (_num2 != 0) {
          result = _num1 / _num2;
        } else {
          _display = "Error"; // Cannot divide by 0
          _operation = '';
          return;
        }
        break;
    }

    // Update result
    _display = _formatResult(result);
    _equation = "";
    _operation = ''; // Reset operation
    _shouldStartNewInput = true; // Prepare for new operation from this result
  }

  // Reset (C)
  void _clearAll() {
    _display = '0000';
    _equation = '';
    _num1 = 0;
    _num2 = 0;
    _operation = '';
  }

  // Add decimal point (.)
  void _addDecimal() {
    if (_shouldStartNewInput) {
      _display = "0.";
      _shouldStartNewInput = false;
    } else if (!_display.contains('.')) {
      _display += ".";
    }
  }

  // Toggle sign (+/-)
  void _toggleSign() {
    if (_display != '0000') {
      if (_display.startsWith('-')) {
        _display = _display.substring(1);
      } else {
        _display = "-$_display";
      }
    }
  }

  // Percentage (%)
  void _calculatePercentage() {
    double current = double.parse(_display);
    _display = (current / 100).toString();
  }

  // Helper: Format number (remove trailing .0)
  String _formatResult(double value) {
    String s = value.toString();
    if (s.endsWith(".0")) {
      return s.substring(0, s.length - 2);
    }
    return s;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // --- DISPLAY SECTION ---
            Expanded(
              flex: 35,
              child: Container(
                padding: const EdgeInsets.all(24),
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _equation,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 10),
                    FittedBox(
                      child: Text(
                        _display,
                        style: const TextStyle(
                          color: AppColors.textWhite,
                          fontSize: 60,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // --- BUTTON SECTION ---
            Expanded(
              flex: 65,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildRow(['C', '( )', '%', '÷'], 
                        [AppColors.buttonClear, AppColors.buttonFunction, AppColors.buttonFunction, AppColors.buttonCalculations]),
                    _buildRow(['7', '8', '9', '×'], 
                        [AppColors.buttonNumber, AppColors.buttonNumber, AppColors.buttonNumber, AppColors.buttonCalculations]),
                    _buildRow(['4', '5', '6', '-'], 
                        [AppColors.buttonNumber, AppColors.buttonNumber, AppColors.buttonNumber, AppColors.buttonCalculations]),
                    _buildRow(['1', '2', '3', '+'], 
                        [AppColors.buttonNumber, AppColors.buttonNumber, AppColors.buttonNumber, AppColors.buttonCalculations]),
                    _buildRow(['+/-', '0', '.', '='], 
                        [AppColors.buttonNumber, AppColors.buttonNumber, AppColors.buttonNumber, AppColors.buttonEqual]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(List<String> labels, List<Color> colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(4, (index) {
        return _buildButton(
          text: labels[index],
          bgColor: colors[index],
          onTap: () => onBtnTap(labels[index]),
        );
      }),
    );
  }

  Widget _buildButton({
    required String text,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: AppColors.textWhite,
              fontSize: 48,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}