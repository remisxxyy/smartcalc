import 'package:flutter/material.dart';

import '../controllers/converter_controller.dart';

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  final ConverterController controller = ConverterController();
  final TextEditingController valueController = TextEditingController();

  late String selectedConversion;
  String result = '0';
  String? errorText;

  @override
  void initState() {
    super.initState();
    selectedConversion = controller.getAvailableConversions().first;
  }

  void convertValue() {
    final input = valueController.text.trim();

    if (input.isEmpty) {
      setState(() {
        errorText = 'Please enter a value';
        result = '0';
      });
      return;
    }

    final value = double.tryParse(input);

    if (value == null) {
      setState(() {
        errorText = 'Please enter a valid number';
        result = '0';
      });
      return;
    }

    final converted = controller.convert(selectedConversion, value);

    setState(() {
      errorText = null;
      result = converted;
    });
  }

  void fillExample(String value) {
    valueController.text = value;
    valueController.selection = TextSelection.fromPosition(
      TextPosition(offset: valueController.text.length),
    );
  }

  @override
  void dispose() {
    valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Converter'),
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
                      theme.colorScheme.tertiaryContainer,
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
                      'Unit & Currency Converter',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Convert distance, weight, temperature and currencies.',
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
                      DropdownButtonFormField<String>(
                        initialValue: selectedConversion,
                        decoration: InputDecoration(
                          labelText: 'Conversion type',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          prefixIcon: const Icon(Icons.swap_horiz),
                        ),
                        items: controller
                            .getAvailableConversions()
                            .map(
                              (type) => DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          ),
                        )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedConversion = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: valueController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Enter value',
                          hintText: 'Example: 25',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          prefixIcon: const Icon(Icons.edit),
                          errorText: errorText,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: convertValue,
                          icon: const Icon(Icons.transform),
                          label: const Text('Convert'),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Quick values',
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
                          _QuickValueChip(
                            label: '1',
                            onTap: () => fillExample('1'),
                          ),
                          _QuickValueChip(
                            label: '10',
                            onTap: () => fillExample('10'),
                          ),
                          _QuickValueChip(
                            label: '25',
                            onTap: () => fillExample('25'),
                          ),
                          _QuickValueChip(
                            label: '100',
                            onTap: () => fillExample('100'),
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
                        Icons.info_outline,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Currency rates are currently fixed for demonstration purposes. Live exchange rates can be added later with an API.',
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

class _QuickValueChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _QuickValueChip({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: const Icon(Icons.flash_on, size: 18),
      label: Text(label),
      onPressed: onTap,
    );
  }
}