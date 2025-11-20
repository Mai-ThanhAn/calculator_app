import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'colors.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  // Variable stores input expression
  // Biến lưu trữ biểu thức nhập vào
  String input = "";
  // Variable to store the result
  // Biến lưu trữ kết quả
  String result = "0000";

  // Function to handle when pressing the button
  // Hàm xử lý khi nhấn nút
  void onBtnTap(String value) {
    setState(() {
      if (value == "C") {
        // Reset all
        input = "";
        result = "0000";
      } else if (value == "=") {
        try {
          // 1. Normalize the expression:
          // 1. Chuẩn hóa biểu thức: 
          // The library does not understand '×' and '÷', need to change to '*' and '/'
          // Thư viện không hiểu '×' và '÷', cần đổi thành '*' và '/'
          String finalUserInput = input;
          finalUserInput = finalUserInput.replaceAll('×', '*');
          finalUserInput = finalUserInput.replaceAll('÷', '/');

          // 2. Use math_expressions to calculate
          // 2. Sử dụng math_expressions để tính
          Parser p = Parser();
          Expression exp = p.parse(finalUserInput);
          ContextModel cm = ContextModel();

          double eval = exp.evaluate(EvaluationType.REAL, cm);

          // 3. Beautify the result (Remove the trailing zero if it is an integer)
          // 3. Làm đẹp kết quả (Xóa số 0 ở cuối nếu là số nguyên)
          String evalStr = eval.toString();
          if (evalStr.endsWith(".0")) {
            result = evalStr.substring(0, evalStr.length - 2);
          } else {
            result = evalStr;
          }
        } catch (e) {
          // If the syntax is incorrect
          // Nếu nhập sai cú pháp
          result = "Error";
        }
      } else if (value == "+/-") {
        // Logic to change the sign (currently simply add a minus sign at the beginning)
        // Logic đổi dấu (hiện chỉ đơn giản thêm dấu trừ ở đầu)
        if (input.isNotEmpty) {
          input += "-";
        }
      } else {
        // Logic to enter numbers and normal calculations
         // Logic nhập số và phép tính thông thường
        if (input.length < 15) {
          input += value;
          result = input;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 35,
              child: Container(
                padding: const EdgeInsets.all(24),
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Display the expression being entered
                    // Hiển thị biểu thức đang nhập
                    Text(
                      input,
                      style: const TextStyle(color: Colors.grey, fontSize: 24),
                    ),
                    const SizedBox(height: 10),
                    // Display large numbers (Result)
                     // Hiển thị số lớn (Result)
                    FittedBox(
                      child: Text(
                        result.isEmpty ? "0" : result,
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

            // --- KEYBOARD SECTION ---
            Expanded(
              flex: 65,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 10,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Line 1: C, (), %, /
                    _buildRow(
                      ['C', '( )', '%', '÷'],
                      [
                        AppColors.buttonClear,
                        AppColors.buttonFunction,
                        AppColors.buttonFunction,
                        AppColors.buttonCalculations,
                      ],
                    ),

                    // Line 2: 7, 8, 9, x
                    _buildRow(
                      ['7', '8', '9', '×'],
                      [
                        AppColors.buttonNumber,
                        AppColors.buttonNumber,
                        AppColors.buttonNumber,
                        AppColors.buttonCalculations,
                      ],
                    ),

                    // Line 3: 4, 5, 6, -
                    _buildRow(
                      ['4', '5', '6', '-'],
                      [
                        AppColors.buttonNumber,
                        AppColors.buttonNumber,
                        AppColors.buttonNumber,
                        AppColors.buttonCalculations,
                      ],
                    ),

                    // Line 4: 1, 2, 3, +
                    _buildRow(
                      ['1', '2', '3', '+'],
                      [
                        AppColors.buttonNumber,
                        AppColors.buttonNumber,
                        AppColors.buttonNumber,
                        AppColors.buttonCalculations,
                      ],
                    ),
                    // Line 5: 0, ., +/-, =
                    _buildRow(
                      ['+/-', '0', '.', '='],
                      [
                        AppColors.buttonFunction,
                        AppColors.buttonNumber,
                        AppColors.buttonNumber,
                        AppColors.buttonCalculations,
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to build a single row of buttons
  // Takes a list of labels and a list of colors corresponding to each button
  // Hàm tạo một hàng nút duy nhất
  // Lấy danh sách nhãn và danh sách màu tương ứng với mỗi nút
  Widget _buildRow(List<String> labels, List<Color> colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(labels.length, (index) {
        return _buildButton(labels[index], colors[index]);
      }),
    );
  }

  // Function to build a single calculator button
  // [text] = Button label
  // [color] = Background color of the button
  Widget _buildButton(String text, Color color) {
    return GestureDetector(
      // When user taps, call onBtnTap()
      onTap: () => onBtnTap(text),
      child: Container(
        height: 90,
        width: 90,
        decoration: BoxDecoration(
          color: color, // Button background color
          shape: BoxShape.circle, // Make button circular
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: AppColors.textWhite, // Text color of button
              fontSize: 26,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}