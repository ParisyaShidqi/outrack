import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';

Widget numField(TextEditingController controller, String labelText) {
  return TextField(
      keyboardType: TextInputType.number,
      inputFormatters: [
        CurrencyTextInputFormatter(
            locale: "id_ID", decimalDigits: 0, name: "Rp. ")
      ],
      cursorColor: Colors.black,
      controller: controller,
      decoration: InputDecoration(
          labelText: labelText,
          enabledBorder: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(),
          isDense: true));
}

Widget textField(TextEditingController controller, String labelText) {
  return TextField(
      cursorColor: Colors.black,
      controller: controller,
      decoration: InputDecoration(
          labelText: labelText,
          enabledBorder: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(),
          isDense: true));
}
