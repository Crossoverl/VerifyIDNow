import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app1/pages/widgets/textfield_general_widget.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(InfoPage());
}

// class Info extends StatelessWidget {
//   const Info({Key? key}) : super(key: key);
//   static final String title = 'Information';
//
//   @override
//   Widget build(BuildContext context) => MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: title,
//         theme: ThemeData(
//           primaryColor: Colors.black,
//         ),
//         home: InfoPage(title: title),
//       );
// }

class InfoPage extends StatefulWidget {
  final String title = 'Information';

  const InfoPage({Key? key}) : super(key: key);

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  // int index = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Colors.lightBlue,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Colors.grey),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop(context);
            },
          ),
        ),
        body: TextfieldGeneralWidget(),
      );
}
