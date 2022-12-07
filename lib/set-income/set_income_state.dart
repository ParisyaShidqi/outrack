import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:outrack/homepage/homepage.dart';
import 'package:outrack/widgets/format_currency.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetIncomeState extends ChangeNotifier {
  TextEditingController setIncomeController = TextEditingController();
  TextEditingController setConstantOutcomeController = TextEditingController();
  bool _mounted = false;
  final BuildContext context;

  SetIncomeState(this.context) {
    incomeInit();
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

  incomeInit() async {
    var sp = await SharedPreferences.getInstance();
    String monthlyIncome = sp.getString('monthlyIncome') ?? "";
    if(monthlyIncome != "")
    {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    }
  }

  saveIncome(String income, String constantOutcome, {context}) async {
    var sp = await SharedPreferences.getInstance();
    await sp.setString("monthlyIncome", income);
    await sp.setString("constantOutcome", constantOutcome);

    if (setIncomeController.text != "") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    }
  }
}
