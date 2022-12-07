import 'package:flutter/material.dart';

Widget outrackButton(VoidCallback onPressed, String text) {
  return TextButton(
    onPressed: onPressed,
    child: Text(
      text,
      style: const TextStyle(color: Colors.black),
    ),
    style: TextButton.styleFrom(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          side: BorderSide(
              color: Colors.black, width: 1, style: BorderStyle.solid),
        )),
  );
}
