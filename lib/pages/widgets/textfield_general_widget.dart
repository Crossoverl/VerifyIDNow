import 'package:flutter/material.dart';
import 'package:flutter_app1/pages/widgets/textform_button.dart';


class TextfieldGeneralWidget extends StatefulWidget {
  @override
  _TextfieldGeneralWidgetState createState() => _TextfieldGeneralWidgetState();


}

class _TextfieldGeneralWidgetState extends State<TextfieldGeneralWidget> {
  final emailController = TextEditingController();
  final companyController = TextEditingController();
  final serviceController = TextEditingController();
  bool isDisabled = true;

  @override
  void initState() {
    super.initState();

    emailController.addListener(() => setState(() {}));
    companyController.addListener(() => setState(() {}));
    serviceController.addListener(() => setState(() {}));

  }


  void _printLatestValue() {

    print('Name: ${emailController.text}');
    print('Company: ${companyController.text}');
    print('Service: ${serviceController.text}');

  }

  bool _isButtonDisabled() {

    if ((emailController.text == "") || (companyController.text == "") || (serviceController.text == "")) {
      return true;
    }
    else {
      return false;
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    companyController.dispose();
    serviceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Center(
        child: ListView(
          padding: EdgeInsets.all(32),
          children: [
            buildEmail(),
            const SizedBox(height: 24),
            buildCompany(),
            const SizedBox(height: 24),
            buildService(),
            const SizedBox(height: 24),
            DisabledButton(
              key: Key('submitInfo'),
              isDisabled: _isButtonDisabled(),
              child: RaisedButton (
                child: Text('Next'),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true)
                      .pushNamed('/take_photo');
                },
                textColor: Colors.white,
                color: Colors.blue,
                disabledColor: Colors.grey,
                disabledTextColor: Colors.black,
              )
            ),

            FlatButton(
              onPressed: () {
                _printLatestValue();
                Navigator.of(context, rootNavigator: true)
                    .pushNamed('/take_photo');
              },
              child: Text("Skip"),
              color: Colors.lightBlueAccent,
            ),
          ],
        ),
      );

  Widget buildEmail() => TextField(
        controller: emailController,
        decoration: InputDecoration(
          labelText: 'Name',
          prefixIcon: Icon(Icons.account_circle),
          // icon: Icon(Icons.mail),
          suffixIcon: emailController.text.isEmpty
              ? Container(width: 0)
              : IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => emailController.clear(),
                ),
          border: UnderlineInputBorder(),
        ),
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.done,
        // autofocus: true,
      );

  Widget buildCompany() => TextField(
        controller: companyController,
        decoration: InputDecoration(
          labelText: 'Company',
          prefixIcon: Icon(Icons.account_balance_rounded),
          // icon: Icon(Icons.mail),
          suffixIcon: companyController.text.isEmpty
              ? Container(width: 0)
              : IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => companyController.clear(),
                ),
          border: UnderlineInputBorder(),
        ),
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        // autofocus: true,
      );

  Widget buildService() => TextField(
        controller: serviceController,
        decoration: InputDecoration(
          labelText: 'Service',
          prefixIcon: Icon(Icons.account_balance_rounded),
          // icon: Icon(Icons.mail),
          suffixIcon: serviceController.text.isEmpty
              ? Container(width: 0)
              : IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => serviceController.clear(),
                ),
          border: UnderlineInputBorder(),
        ),
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        // autofocus: true,
      );
}
