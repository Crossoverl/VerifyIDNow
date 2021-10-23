import 'package:flutter/material.dart';
import 'button_widget.dart';

class TextfieldGeneralWidget extends StatefulWidget {
  @override
  _TextfieldGeneralWidgetState createState() => _TextfieldGeneralWidgetState();
}

class _TextfieldGeneralWidgetState extends State<TextfieldGeneralWidget> {
  final emailController = TextEditingController();
  final companyController = TextEditingController();
  final serviceController = TextEditingController();

  @override
  void initState() {
    super.initState();

    emailController.addListener(() => setState(() {}));
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
            ButtonWidget(
              text: 'Submit',
              onClicked: () {
                print('Name: ${emailController.text}');
                print('Company: ${companyController.text}');
                print('Service: ${serviceController.text}');
              },
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
