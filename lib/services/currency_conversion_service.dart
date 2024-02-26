// services/currency_conversion_service.dart
class CurrencyConversionService {
  double exchangeRate = 1.08;
  String baseCurrency = "EUR";
  String targetCurrency = "USD";
  bool isEuroToUsd = true;
  double factor = 1;

  void setCurrency(String currency, double rate) {
    targetCurrency = currency;
    exchangeRate = rate;
    isEuroToUsd = targetCurrency != "EUR";
  }

  void toggleCurrencyDirection() {
    isEuroToUsd = !isEuroToUsd;
    // Inverser les devises lors du basculement
    final String temp = baseCurrency;
    baseCurrency = targetCurrency;
    targetCurrency = temp;
  }

  /// Augmente le facteur de conversion par un facteur de 10.
  double increaseFactor() {
    factor *= 10;
    return factor;
  }

  /// Diminue le facteur de conversion par un facteur de 10.
  double decreaseFactor() {
    factor /= 10;
    return factor;
  }

  /// Vérifie si le facteur de conversion peut être augmenté sans dépasser une certaine limite.
  bool canIncrease() => (10 * factor * exchangeRate) < 1000000;

  /// Vérifie si le facteur de conversion peut être diminué sans tomber en dessous d'un certain seuil.
  bool canDecrease() => ((1 * factor) / 10) >= 1;
}
