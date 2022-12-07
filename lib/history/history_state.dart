import 'package:flutter/cupertino.dart';
import 'package:outrack/sql_helper.dart';
import 'package:outrack/widgets/format_currency.dart';

class HistoryState with ChangeNotifier {
  List<Map<String, dynamic>> outcome = [];
  bool _mounted = false;
  String totalOutcome = "";

  HistoryState() {
    refreshOutcome();
  }

  @override
  void dispose() {
    _mounted = true;
    super.dispose();
  }

  _notify() {
    if (!_mounted) {
      super.notifyListeners();
    }
  }

  refreshOutcome() async {
    final data = await SQLHelper.getOutcome();
    outcome = data;
    totalOutcome = formatCurrency(outcomeCounter(outcome));
    _notify();
  }

  outcomeCounter(List<Map<String, dynamic>> localOutcome) {
    int totalOutcome = 0;
    for (var element in localOutcome) {
      int outcomeAmount = element['outcome_amount'].toInt();
      totalOutcome += outcomeAmount;
    }
    return totalOutcome;
  }
}
