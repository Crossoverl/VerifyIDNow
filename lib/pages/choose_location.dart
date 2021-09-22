import 'package:flutter/material.dart';

class ChooseLocation extends StatefulWidget {
  @override
  _ChooseLocationState createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<ChooseLocation> {

  // will not block any other code
  void getData() async {
    // simulate network request for a username

    String username = await Future.delayed(Duration(seconds: 3), () {
      return 'user';
    });

    // simulate network request to get bio of the username
    String bio = await Future.delayed(Duration(seconds: 2), () {
      return 'bio';
    });

    print('$username - $bio');
  }

  int counter = 0;

  @override
  void initState() {
    super.initState();
    getData();
    print('hey there!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text('Choose a Location'),
        centerTitle: true,
        elevation: 0,
      ), //automatically places back arrow
      body: RaisedButton(
        onPressed: () {
          setState(() {
            counter+= 1;
          });
        },
        child: Text('counter is $counter'),
      ),
    );
  }
}
