import 'package:flutter/material.dart';
import 'package:outrack/widgets/button.dart';
import 'package:outrack/widgets/textfield.dart';

outrackDialog(context, TextEditingController budgetNameController,
    TextEditingController budgetamountController, VoidCallback onPressed) {
  return showDialog(
      context: context,
      builder: (_) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                textField(budgetNameController, "Budget Name"),
                const SizedBox(
                  height: 10,
                ),
                numField(budgetamountController, "Budget amount"),
                const SizedBox(
                  height: 10,
                ),
                outrackButton(onPressed, "Set Budget")
              ],
            ),
          ));
}
