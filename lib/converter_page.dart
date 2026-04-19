import 'package:flutter/material.dart';

class ConverterPage extends StatefulWidget {
  const ConverterPage({super.key});

  @override
  State<ConverterPage> createState() => _ConverterPageState();
}

class _ConverterPageState extends State<ConverterPage> {
  final TextEditingController kmController = TextEditingController();
  String result = "0";

  void convert() {
    final double km = double.tryParse(kmController.text) ?? 0;
    final double miles = km * 0.621371;

    setState(() {
      result = miles.toStringAsFixed(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("KM to Mile Converter"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: kmController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: "Kilometers",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: convert,
              child: const Text("Convert"),
            ),
            const SizedBox(height: 25),
            Text(
              "$result Miles",
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}