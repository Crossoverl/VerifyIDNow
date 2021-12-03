import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app1/pages/widgets/verification_type.dart';
import 'package:flutter_app1/pages/widgets/rounded_button_widget.dart';

class Verification extends StatelessWidget {
  const Verification({Key? key, required this.result, required this.tries})
      : super(key: key);
  final String result;
  final int tries;
  final int triesAllowed = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Container(
        padding: EdgeInsets.all(30.0),
        alignment: Alignment.center,
        child: VerificationType(result: result, tries: tries,)
      ),
    );
  }
}
