import 'package:http/http.dart' as http;
import 'dart:convert';

class CurrencyService {
  Future<Map<String, dynamic>> fetchCurrencies() async {
    final response = await http.get(Uri.parse('https://api.frankfurter.app/currencies'))
        .timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load currencies');
    }
  }

  Future<Map<String, dynamic>> fetchRates() async {
    final response = await http.get(Uri.parse('https://api.frankfurter.app/latest?from=EUR'));
    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      Map<String, dynamic> rates = {};
      result['rates'].forEach((key, value) {
        rates[key] = (value is int) ? value.toDouble() : value;
      });
      return rates;
    } else {
      throw Exception('Failed to load exchange rates');
    }
  }
}
