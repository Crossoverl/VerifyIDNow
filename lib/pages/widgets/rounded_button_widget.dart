import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;
  final int color;

  const RoundedButton({
    required this.text,
    required this.onClicked,
    required this.color,
  }) : super();

  @override
  Widget build(BuildContext context) => RaisedButton(
    child: Text(
      text,
      style: TextStyle(fontSize: 25.0),
    ),
    shape: StadiumBorder(),
    color: Color(color),
    padding: EdgeInsets.only(top: 10.0, bottom: 10.0, right: 45.0, left: 45.0),
    textColor: Colors.black,
    onPressed: onClicked,
  );
}
