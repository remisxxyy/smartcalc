import 'package:flutter/material.dart';

import '../controllers/calculator_controller.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final CalculatorController controller = CalculatorController();
  final TextEditingController expressionController = TextEditingController();

  String result = '0';
  bool isLoading = false;
  String? errorText;

  Future<void> calculateResult() async {
    final expression = expressionController.text.trim();

    if (expression.isEmpty) {
      setState(() {
        result = '0';
        errorText = 'Please enter an equation';
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorText = null;
    });

    final answer = await controller.calculateExpression(expression);

    setState(() {
      result = answer;
      isLoading = false;
      if (answer == 'Error') {
        errorText = 'Invalid equation';
      }
    });
  }

  void insertSample(String sample) {
    expressionController.text = sample;
    expressionController.selection = TextSelection.fromPosition(
      TextPosition(offset: expressionController.text.length),
    );
  }

  @override
  void dispose() {
    expressionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartCalc'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primaryContainer,
                      theme.colorScheme.secondaryContainer,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Equation Calculator',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Solve full equations like 5+6/2 or (2+3)*4',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Result',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            result,
                            style: theme.textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                  side: BorderSide(
                    color: theme.colorScheme.outlineVariant,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      TextField(
                        controller: expressionController,
                        decoration: InputDecoration(
                          labelText: 'Enter equation',
                          hintText: 'Example: 5+6/2',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          prefixIcon: const Icon(Icons.functions),
                          errorText: errorText,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: isLoading ? null : calculateResult,
                          icon: isLoading
                              ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                              : const Icon(Icons.calculate),
                          label: Text(isLoading ? 'Calculating...' : 'Calculate'),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Quick examples',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _ExampleChip(
                            label: '5+6/2',
                            onTap: () => insertSample('5+6/2'),
                          ),
                          _ExampleChip(
                            label: '(2+3)*4',
                            onTap: () => insertSample('(2+3)*4'),
                          ),
                          _ExampleChip(
                            label: '10-3*2',
                            onTap: () => insertSample('10-3*2'),
                          ),
                          _ExampleChip(
                            label: '8/4+7',
                            onTap: () => insertSample('8/4+7'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                  side: BorderSide(
                    color: theme.colorScheme.outlineVariant,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.cloud_done_outlined,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Every successful calculation is saved to your cloud history in Firebase.',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExampleChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _ExampleChip({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: const Icon(Icons.bolt, size: 18),
      label: Text(label),
      onPressed: onTap,
    );
  }
}