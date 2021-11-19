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
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery
        .of(context)
        .size
        .width;
    return RaisedButton(
      child: Text(
        text,
        style: TextStyle(fontSize: 0.03 * deviceWidth),
        textAlign: TextAlign.center,
      ),
      shape: StadiumBorder(),
      color: Color(color),
      padding: EdgeInsets.only(
          top: 10.0, bottom: 10.0, right: 45.0, left: 45.0),
      textColor: Color(textColor),
      onPressed: onClicked,
    );
  }
}