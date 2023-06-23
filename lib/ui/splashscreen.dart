import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_hb_app/globalVars.dart';
import 'package:smart_hb_app/main.dart';
import 'package:smart_hb_app/ui/LoginPage.dart';
import 'package:smart_hb_app/ui/loginCheck.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);


  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final navKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navKey,
      home: Scaffold(
          backgroundColor: themeBgColour,
          body: const Image(image: AssetImage("myassets/smartScreen.png"),
            //fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          )),
    );
  }

  @override
  void initState() {
    super.initState();
    //FirebaseAuth.instance.signOut();
  gotoHome();

  }

  Future gotoHome() async {
    // Future.delayed(const Duration(milliseconds: 5700));

    setState(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 2700)).then((value) {
          Navigator.pushReplacementNamed(context, HomeScreen.routeName);
          //Navigator.pushReplacementNamed(context, LoginScreen2.routeName);
          // Navigator.pushReplacementNamed(context, UserCheck.routeName);
          // return Scaffold(
          //   body: StreamBuilder<User?>(
          //     stream: FirebaseAuth.instance.authStateChanges(),
          //     builder: (context, snapshot){
          //       if(snapshot.hasData){
          //         return const HomeScreen();
          //       }
          //       else{
          //         return LoginScreen2();
          //       }
          //     },
          //   ),
          // );
        });
      });
      // Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    });
  }
}
