import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/currency_conversion_service.dart';

class CurrencyTableScreen extends StatefulWidget {
  final String currencyCode;
  final double exchangeRate;

  CurrencyTableScreen({Key? key, required this.currencyCode, required this.exchangeRate}) : super(key: key);

  @override
  _CurrencyTableScreenState createState() => _CurrencyTableScreenState();
}

class _CurrencyTableScreenState extends State<CurrencyTableScreen> {
  late CurrencyConversionService currencyService;

  @override
  void initState() {
    super.initState();
    currencyService = CurrencyConversionService()
      ..setCurrency(widget.currencyCode, widget.exchangeRate);
  }

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat('#,##0.##', 'fr_FR');

    List<Widget> buildNumbers(bool isBaseCurrency) {
      return List<Widget>.generate(10, (index) {
        double number = (index + 1) * currencyService.factor;
        if (!isBaseCurrency) {
          number = currencyService.isEuroToUsd ? number * currencyService.exchangeRate : number / currencyService.exchangeRate;
        }
        String displayText = numberFormat.format(number);
        return Text(
          displayText,
          style: TextStyle(fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold),
        );
      });
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          '${currencyService.baseCurrency} - ${currencyService.targetCurrency}', // Mise à jour pour utiliser baseCurrency et targetCurrency
          style: TextStyle(
            color: Colors.black,
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.swap_horiz),
            onPressed: () {
              setState(() {
                currencyService.toggleCurrencyDirection();
              });
            },
          ),
        ],
      ),
      body: Row(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onDoubleTap: () {
                setState(() {
                  if (currencyService.canDecrease()) {
                    currencyService.decreaseFactor();
                  }
                });
              },
              child: Container(
                color: Colors.grey,
                child: Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: buildNumbers(true),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onDoubleTap: () {
                setState(() {
                  if (currencyService.canIncrease()) {
                    currencyService.increaseFactor();
                  }
                });
              },
              child: Container(
                color: Colors.green,
                child: Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: buildNumbers(false),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
