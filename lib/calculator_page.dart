import 'package:flutter/material.dart';

import 'calculator_controller.dart';
import 'converter_page.dart';
import 'history_page.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final CalculatorController controller = CalculatorController();
  final TextEditingController expressionController = TextEditingController();

  String result = '0';

  Future<void> calculateResult() async {
    final expression = expressionController.text.trim();

    if (expression.isEmpty) {
      setState(() {
        result = '0';
      });
      return;
    }

    final answer = await controller.calculateExpression(expression);

    setState(() {
      result = answer;
    });
  }

  @override
  void dispose() {
    expressionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Equation Calculator"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: expressionController,
              decoration: const InputDecoration(
                labelText: "Enter equation",
                hintText: "Example: 5+6/2",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: calculateResult,
              child: const Text("Calculate"),
            ),
            const SizedBox(height: 25),
            Text(
              "Result: $result",
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ConverterPage(),
                  ),
                );
              },
              child: const Text("KM to Mile Converter"),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HistoryPage(),
                  ),
                );
              },
              child: const Text("History"),
            ),
          ],
        ),
      ),
    );
  }
}