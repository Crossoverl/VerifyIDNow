import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;
  final int color;
  final int textColor;

  const RoundedButton({
    required this.text,
    required this.onClicked,
    required this.color,
    this.textColor = 0xFF000000,
  }) : super();

  @override
  Widget build(BuildContext context) => RaisedButton(
    child: Text(
      text,
      style: TextStyle(fontSize: 16.0),
      textAlign: TextAlign.center,
    ),
    shape: StadiumBorder(),
    color: Color(color),
    padding: EdgeInsets.only(top: 16.0, bottom: 16.0, right: 12.0, left: 12.0),
    textColor: Color(textColor),
    onPressed: onClicked,
  );
}
