import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:outrack/sql_helper.dart';
import 'package:outrack/widgets/format_currency.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeState extends ChangeNotifier {
  TextEditingController setOutcomeNameController = TextEditingController();
  TextEditingController setOutcomeAmountController = TextEditingController();
  TextEditingController budgetNameController = TextEditingController();
  TextEditingController budgetAmountController = TextEditingController();

  List<Map<String, dynamic>> budget = [];
  List<Map<String, dynamic>> outcome = [];
  List<Map<String, dynamic>> todayOutcome = [];
  bool _mounted = false;
  String monthlyIncome = "";
  List<bool> budgetCheckbox = [];
  List<String> budgetItems = [];
  List<String> outcomeItems = [];
  List<String> budgetList = <String>[];
  String dropdownValue = "";
  bool isLoading = false;
  int dropdownID = 0;
  String totalOutcome = "Rp. 0";
  var now = DateTime.now();
  String date = "";

  HomeState() {
    date = DateFormat('dd/MMM/yyyy').format(now);

    initIncome();
    refreshBudget();
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

  String intFormat(String text) {
    print(text);
    String formattedText = text.replaceAll("Rp. ", "");
    print("ft " + formattedText);
    formattedText = formattedText.replaceAll(".", "");

    return formattedText;
  }

  initIncome() async {
    var sp = await SharedPreferences.getInstance();
    monthlyIncome = sp.getString("monthlyIncome") ?? "";
  }

  idSeeker(String name) async {
    for (var element in budget) {
      if (name == element["budget_name"]) {
        dropdownID = element["id"];
      }
    }
    _notify();
  }

  monthlyIncomeAfterOutcomeDelete(int outcome) async {
    int localMonthlyIncome = 0;
    String unformattedMI = intFormat(monthlyIncome);
    localMonthlyIncome = int.parse(unformattedMI) + outcome;
    var sp = await SharedPreferences.getInstance();
    monthlyIncome = formatCurrency(localMonthlyIncome);
    await sp.setString("monthlyIncome", monthlyIncome);
    _notify();
  }

  outcomeCounter(List<Map<String, dynamic>> localOutcome) {
    int totalOutcome = 0;
    for (var element in localOutcome) {
      int outcomeAmount = element['outcome_amount'].toInt();
      print(element['outcome_name']);
      totalOutcome = totalOutcome + outcomeAmount;
    }
    return totalOutcome;
  }

// Budget CRD

  refreshBudget() async {
    budgetList = [];
    final data = await SQLHelper.getBudget();
    budget = data;
    budgetItems =
        List<String>.generate(budget.length, (i) => 'ItemBudget ${i + 1}');

    for (var element in budget) {
      budgetList.add(element['budget_name']);
    }
    if (budgetList.isNotEmpty) {
      dropdownValue = budgetList.first;
      idSeeker(budgetList.first);
    }

    _notify();
  }

  addBudget() async {
    String budgetFormat = intFormat(budgetAmountController.text);
    await SQLHelper.addBudget(
        budgetNameController.text, double.parse(budgetFormat));
    await refreshBudget();
  }

  updateBudget(double budgetAmount) async {
    Map<String, dynamic> budgetJson = {"budget_amount": budgetAmount};
    await SQLHelper.updateBudget(dropdownID, budgetJson);
    _notify();
  }

  deleteBudget(int index) async {
    isLoading = true;
    _notify();

    int totalOutcome = 0;

    for (var element in outcome) {
      int outcomeAmount = element['outcome_amount'].toInt();
      if (element['budget_id'] == budget[index]['id']) {
        totalOutcome += outcomeAmount;
      }
    }
    monthlyIncomeAfterOutcomeDelete(totalOutcome);
    await SQLHelper.deleteBudget(budget[index]['id']);

    await refreshBudget();
    await refreshOutcome();

    isLoading = false;
    _notify();
  }

  // Outcome CRD

  refreshOutcome() async {
    todayOutcome = [];
    final data = await SQLHelper.getOutcome();
    outcome = data;

    for (var element in outcome) {
      if (element['date'] == date) {
        todayOutcome.add(element);
      }
    }

    outcomeItems = List<String>.generate(
        todayOutcome.length, (i) => 'ItemOutcome ${i + 1}');
    totalOutcome = formatCurrency(outcomeCounter(todayOutcome));
    _notify();
  }

  addOutcome() async {
    double budgetAmount = 0;
    String outcomeFormat = intFormat(setOutcomeAmountController.text);
    String annualIncome = intFormat(monthlyIncome);

    if (budget.isNotEmpty) {
      await SQLHelper.addOutcome(setOutcomeNameController.text,
          double.parse(outcomeFormat), dropdownID, date);
      int tempAnnualIncome = int.parse(annualIncome) - int.parse(outcomeFormat);
      monthlyIncome = formatCurrency(tempAnnualIncome);
      for (var element in budget) {
        if (dropdownID == element["id"]) {
          budgetAmount = element['budget_amount'] - double.parse(outcomeFormat);
          break;
        }
      }

      updateBudget(budgetAmount);
      await refreshOutcome();
      await refreshBudget();
    }
  }

  deleteOutcome(int index) async {
    isLoading = true;
    _notify();
    int amountAfterDelete = 0;
    await SQLHelper.deleteOutcome(outcome[index]['id']);
    for (var element in budget) {
      if (element['id'] == dropdownID) {
        amountAfterDelete = element['budget_amount'].toInt() +
            outcome[index]['outcome_amount'].toInt();
        break;
      }
    }
    monthlyIncomeAfterOutcomeDelete(outcome[index]['outcome_amount'].toInt());
    updateBudget(amountAfterDelete.toDouble());
    refreshOutcome();
    refreshBudget();
    isLoading = false;
    _notify();
  }
}
