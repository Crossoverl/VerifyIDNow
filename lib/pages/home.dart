import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text('Begin'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              child:
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child:
                    Image.asset('assets/logo/Verify_logo.png')),
            ),
            Text('Home'),
            SizedBox(
              height: 100.0,
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/info');
              },
              child: Text('Begin'),
              color: Colors.lightBlueAccent,
            )
          ],
        ),
      ),
    );
  }
}
