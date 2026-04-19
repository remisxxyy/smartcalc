import 'package:math_expressions/math_expressions.dart';
import '../services/history_service.dart';

class CalculatorController {
  Future<String> calculateExpression(String expression) async {
    try {
      String parsedExpression = expression.replaceAll('×', '*');

      Parser parser = Parser();
      Expression exp = parser.parse(parsedExpression);
      ContextModel cm = ContextModel();

      double eval = exp.evaluate(EvaluationType.REAL, cm);

      String result;

      if (eval == eval.toInt()) {
        result = eval.toInt().toString();
      } else {
        result = eval.toString();
      }

      // Сохраняем в Firebase
      await HistoryService.add("$expression = $result");

      return result;
    } catch (e) {
      return 'Error';
    }
  }
}