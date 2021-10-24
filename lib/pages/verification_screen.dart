import 'package:flutter/material.dart';

class Verification extends StatelessWidget {
  const Verification({Key? key, required this.result}) : super(key: key);
  final String result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text('Complete'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ), //automatically places back arrow
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(result),
            SizedBox(
              height: 100.0,
            ),
            FlatButton(
              onPressed: () {
                int count = 0;
                Navigator.of(context).popUntil((route) {
                  return count++ == 3;
                });
              },
              child: Text('Return Home'),
              color: Colors.lightBlueAccent,
            )
          ],
        ),
      ),
    );
  }
}
