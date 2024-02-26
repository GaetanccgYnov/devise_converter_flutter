import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'currency_table_screen.dart'; // Assurez-vous que le chemin est correct

class CurrencyDisplayScreen extends StatefulWidget {
  @override
  _CurrencyDisplayScreenState createState() => _CurrencyDisplayScreenState();
}

class _CurrencyDisplayScreenState extends State<CurrencyDisplayScreen> {
  late Future<Map<String, dynamic>> currencies;
  late Future<Map<String, dynamic>> rates;
  final String baseUrl = 'https://api.frankfurter.app';

  @override
  void initState() {
    super.initState();
    currencies = fetchCurrencies();
    rates = fetchRates();
  }

  Future<Map<String, dynamic>> fetchCurrencies() async {
    final response = await http.get(Uri.parse('$baseUrl/currencies'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load currencies');
    }
  }

  Future<Map<String, dynamic>> fetchRates() async {
    final response = await http.get(Uri.parse('$baseUrl/latest?from=EUR'));
    if (response.statusCode == 200) {
      return json.decode(response.body)['rates'];
    } else {
      throw Exception('Failed to load exchange rates');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Currencies and Rates'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait([currencies, rates]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            final currenciesData = snapshot.data![0] as Map<String, dynamic>;
            final ratesData = snapshot.data![1] as Map<String, dynamic>;
            return ListView.builder(
              itemCount: currenciesData.length,
              itemBuilder: (context, index) {
                String currencyCode = currenciesData.keys.elementAt(index);
                String currencyName = currenciesData[currencyCode];
                String rate = ratesData[currencyCode]?.toDouble()?.toStringAsFixed(2) ?? 'N/A';
                return ListTile(
                  leading: Text(currencyCode, style: TextStyle(fontWeight: FontWeight.bold)),
                  title: Text(currencyName),
                  trailing: Text(rate),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CurrencyTableScreen(
                          currencyCode: currencyCode,
                          exchangeRate: double.parse(ratesData[currencyCode].toString()),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
