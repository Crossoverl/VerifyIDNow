// This is a basic Flutter widget test.


//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
import 'dart:async';
import 'dart:convert';
import 'package:flutter_app1/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app1/pages/verification_screen.dart';
import 'package:flutter_app1/pages/widgets/textform_button.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app1/pages/widgets/textfield_general_widget.dart';
import 'package:flutter_app1/pages/widgets/rounded_button_widget.dart';
import 'package:flutter_app1/pages/widgets/button_widget.dart';
import 'package:flutter_app1/pages/take_photo_screen.dart';
import 'package:flutter_app1/pages/appointment_info.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter/cupertino.dart';




void main() {
  testWidgets('Verify Appt Information Input - 1', (WidgetTester tester) async {
    Widget testWidget = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(home: new Info()));
    await tester.pumpWidget(testWidget);
    await tester.enterText(find.byType(TextField).at(0), 'John Doe');
    await tester.enterText(find.byType(TextField).at(1), 'ABC Electric');
    await tester.enterText(find.byType(TextField).at(2), 'install a new meter');
    await tester.pumpWidget(testWidget);
    expect((tester.widget(find.byType(DisabledButton).at(0)) as DisabledButton).isDisabled, false);
  });

  testWidgets('Empty Appt Information - 2', (WidgetTester tester) async {
    Widget testWidget = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(home: new Info()));
    await tester.pumpWidget(testWidget);
    await tester.pumpWidget(testWidget);
    expect((tester.widget(find.byType(DisabledButton).at(0)) as DisabledButton).isDisabled, true);
  });

  testWidgets('App Render - 3', (WidgetTester tester) async {
    Widget testWidget = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(home: new Home()));

    await tester.pumpWidget(testWidget);
    expect((tester.widget(find.byType(IntroductionScreen).at(0)) as IntroductionScreen).globalBackgroundColor, Colors.white);
  });

  testWidgets('Check verification not possible page - 7', (WidgetTester tester) async {
    Widget testWidget = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(home: new Verification(result: "false", tries: 2))
    );
    await tester.pumpWidget(testWidget);
    expect((tester.widget(find.byType(Text).at(0)) as Text).data, "We were unable to verify your identity.");
    expect((tester.widget(find.byType(RoundedButton).at(0)) as RoundedButton).text, "RETRY");

    await tester.tap(find.byType(RoundedButton).at(0));
    await tester.pumpAndSettle();
  });

  testWidgets('Check verification not possible page | result: true, tries: 1 - 7a', (WidgetTester tester) async {
    Widget testWidget = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(home: new Verification(result: "true", tries: 1))
    );
    await tester.pumpWidget(testWidget);
    expect((tester.widget(find.byType(Text).at(0)) as Text).data, "Your identity has been verified!");
    expect((tester.widget(find.byType(RoundedButton).at(0)) as RoundedButton).text, "RETURN HOME");
  });


  testWidgets('Check rendering of RoundedButton component - 8', (WidgetTester tester) async {
    Widget testWidget = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(home: new RoundedButton(text: 'Test', color: 0xFFFFFFFF, onClicked: () => {
        }))
    );
    await tester.pumpWidget(testWidget);

    expect((tester.widget(find.byType(RaisedButton).at(0)) as RaisedButton).color, Color(0xFFFFFFFF));
    expect(find.text('Test'), findsOneWidget);
  });


  testWidgets('Check rendering of the ButtonWidget Component - 11', (WidgetTester tester) async {
    Widget testWidget = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(home: new ButtonWidget(text: "test", onClicked: () => {}))
    );
    await tester.pumpWidget(
        testWidget
    );
    expect(find.text('test'), findsOneWidget);
  });

  testWidgets('Check correct rendering of verification_screen.dart - 13', (WidgetTester tester) async {
    Widget testWidget = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(home: new Verification(result: "true", tries: 1))
    );
    await tester.pumpWidget(
        testWidget
    );
    expect(find.text('Your identity has been verified!'), findsOneWidget);
  });

}
