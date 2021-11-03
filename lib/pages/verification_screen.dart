import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app1/pages/widgets/rounded_button_widget.dart';
class Verification extends StatelessWidget {
  const Verification({Key? key, required this.result, required this.tries}) : super(key: key);
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (result == 'true' && tries < 3) ...[
              Center(
                child:
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child:
                    Text(
                        'Your identity has been verified!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: CupertinoColors.activeBlue,
                            fontSize: 35)
                    )
                    )
                ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child:
                  Text(
                  'The customer has been notified of your arrival.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold,
                  color: CupertinoColors.black,
                  fontSize: 20)
                  )
              ),
              RoundedButton(text: 'RETURN HOME', color: 0xFF1DDE7D, onClicked: () {
                int count = 0;
                Navigator.of(context).popUntil((route) {
                  return count++ == 3;
                });
              },
              ),
            ]
            else if (result == 'false' && tries <= 3)...[
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child:
                      Text('We were unable to verify your identity.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold,
                      color: CupertinoColors.black,
                      fontSize: 35
                )
              )),
              Padding(
                padding: EdgeInsets.all(15.0),
                child:
                Text(
                    'Please try again.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold,
                        color: CupertinoColors.black,
                        fontSize: 20)
                ),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child:
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 5.0),
                        child:
                          Text('Number of attempts left: ' +  (4-tries).toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: CupertinoColors.systemRed,
                                  fontSize: 20)
                          ),
                      ),
                      RoundedButton(text: 'RETRY', color: 0xFF1DDE7D, onClicked: () {
                        int count = 0;
                        Navigator.of(context).popUntil((route) {
                          return count++ == 1;
                        });
                      }
                      )
                  ]
                ),
              ),
            ]
            else ...[
              Padding(
                  padding: EdgeInsets.all(20.0),
                  child:
                  Text('We were unable to verify your identity.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold,
                  color: CupertinoColors.black,
                  fontSize: 35
                  )
              )),
              RoundedButton(text: 'RETURN HOME', color: 0xFF1DDE7D, onClicked: () {
              int count = 0;
              Navigator.of(context).popUntil((route) {
                return count++ == 3;
                });
              },
              )
            ],

            // Text(tries.toString()),
            SizedBox(
              height: 100.0,
            ),

            // FlatButton(
            //   onPressed: () {
            //     int count = 0;
            //     Navigator.of(context).popUntil((route) {
            //       return count++ == 3;
            //     });
            //   },
            //   child: Text('RETURN HOME'),
            //   color: Color(0xFF1DDE7D),
            // )
          ],
        ),
      ),
    );
  }
}
