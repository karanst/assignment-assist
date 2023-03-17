import 'package:flutter/material.dart';

 setSnackbar(String msg, BuildContext context) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar( SnackBar(
    content: Text(
      msg,
      // isCentered: true,
      // textColor: Colors.white,
    ),
    behavior: SnackBarBehavior.floating,

    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    backgroundColor: Colors.black,
    elevation: 1.0,
  ));
}