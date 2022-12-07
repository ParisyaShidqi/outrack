import 'package:intl/intl.dart';

String formatCurrency(int currency) {
  var formatCurrencyIndo =
      NumberFormat.currency(locale: "id_ID", symbol: "Rp. ", decimalDigits: 0);
  String formattedNumber = formatCurrencyIndo.format(currency);
  return formattedNumber;
}
