import 'dart:core';

import 'package:flutter/material.dart';

class AvailabilityButton extends StatelessWidget {
  AvailabilityButton({this.title, this.onPressed, this.color});
  final String? title;
  final void Function()? onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: color,
      textColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: Container(
        height: 50,
        width: 200,
        child: Center(
          child: Text(
            title!,
            style: TextStyle(fontSize: 20, fontFamily: 'Brand-Bold'),
          ),
        ),
      ),
    );
  }
}
