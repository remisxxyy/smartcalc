class ConverterController {
  final Map<String, double> conversionRates = {
    'Kilometers → Miles': 0.621371,
    'Miles → Kilometers': 1.60934,
    'Kilograms → Pounds': 2.20462,
    'Pounds → Kilograms': 0.453592,
    'Celsius → Fahrenheit': 0,
    'Fahrenheit → Celsius': 0,
    'EUR → USD': 1.09,
    'USD → EUR': 0.92,
    'EUR → GBP': 0.85,
    'GBP → EUR': 1.18,
    'USD → JPY': 151.50,
    'JPY → USD': 0.0066,
  };

  String convert(String type, double value) {
    switch (type) {
      case 'Celsius → Fahrenheit':
        return ((value * 9 / 5) + 32).toStringAsFixed(2);
      case 'Fahrenheit → Celsius':
        return ((value - 32) * 5 / 9).toStringAsFixed(2);
      default:
        final rate = conversionRates[type];
        if (rate == null) return 'Error';
        return (value * rate).toStringAsFixed(2);
    }
  }

  List<String> getAvailableConversions() {
    return conversionRates.keys.toList();
  }
}