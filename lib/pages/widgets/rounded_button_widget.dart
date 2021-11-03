import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  const RoundedButton({
    required this.text,
    required this.onClicked,
  }) : super();

  @override
  Widget build(BuildContext context) => RaisedButton(
    child: Text(
      text,
      style: TextStyle(fontSize: 20.0),
    ),
    shape: StadiumBorder(),
    color: Color(0xFF1DDE7D),
    padding: EdgeInsets.only(top: 20.0, bottom: 20.0, right: 45.0, left: 45.0),
    textColor: Colors.black,
    onPressed: onClicked,
  );
}
