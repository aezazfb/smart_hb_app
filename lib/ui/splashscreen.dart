import 'package:flutter/material.dart';
import 'package:smart_hb_app/globalVars.dart';
import 'package:smart_hb_app/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: themeBgColour,
        body: const Image(image: AssetImage("myassets/smartScreen.png"),
          //fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
        ));
  }

  @override
  void initState() {
    super.initState();
  gotoHome();

  }

  Future gotoHome() async {
    // Future.delayed(const Duration(milliseconds: 5700));

    setState(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 2700)).then((value) {
          Navigator.pushReplacementNamed(context, HomeScreen.routeName);
        });
      });
      // Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    });
  }
}
