import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:introduction_screen/introduction_screen.dart';

import 'appointment_info.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
    );

    return MaterialApp(
      title: 'Introduction screen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: OnBoardingPage(),
    );
  }
}

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _loadInfoPage(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => Info()),
    );
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset('$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      globalHeader: Align(
        alignment: Alignment.topRight,
      ),
      pages: [
        PageViewModel(
          title: "Information",
          body:
              "Let us know who you are. Provide your name, your employer company and the service you will be providing.",
          image: _buildImage('assets/images/logo.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Face ID",
          body: "Take a selfie to let us know that it is really you.",
          image: _buildImage('assets/images/logo.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "ID",
          body: "Take a picture of your driver's license.",
          image: _buildImage('assets/images/logo.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Confirm",
          body:
              "Once you have taken the pictures of both yourself and your ID you can confirm that they are of good quality or retake them again.",
          image: _buildImage('assets/images/logo.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Verified",
          body:
              "Once you have been verified a message will be sent to your client to let them know.",
          image: _buildImage('assets/images/logo.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Get Started!",
          bodyWidget: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                  "Click the 'Start' button to move\n on to the information page"),
            ],
          ),
          decoration: pageDecoration.copyWith(
            bodyAlignment: Alignment.center,
          ),
          //add image
          reverse: true,
        ),
      ],
      onDone: () => _loadInfoPage(context),
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: const Text('Skip'),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Start', style: TextStyle(fontWeight: FontWeight.w600)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(child: Text("This is the screen after Introduction")),
    );
  }
}
