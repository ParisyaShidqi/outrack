import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:outrack/homepage/homepage.dart';
import 'package:outrack/set-income/set_income_state.dart';
import 'package:outrack/widgets/button.dart';
import 'package:outrack/widgets/format_currency.dart';
import 'package:outrack/widgets/textfield.dart';
import 'package:provider/provider.dart';

class SetIncomePage extends StatelessWidget {
  const SetIncomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => SetIncomeState(context),
        child:
            Consumer<SetIncomeState>(builder: (context, setIncomeState, child) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    numField(
                        setIncomeState.setIncomeController, "Monthly Income"),
                    const SizedBox(
                      height: 10,
                    ),
                    numField(setIncomeState.setConstantOutcomeController,
                        "Constant Outcome (optional)"),
                    const SizedBox(
                      height: 10,
                    ),
                    outrackButton(() {
                      setIncomeState.saveIncome(
                          setIncomeState.setIncomeController.text,
                          setIncomeState.setConstantOutcomeController.text,
                          context: context);
                    }, "Set Income")
                  ],
                ),
              ),
            ),
          );
        }));
  }
}
