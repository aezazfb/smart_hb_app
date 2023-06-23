import 'package:flutter/material.dart';
import 'package:smart_hb_app/globalVars.dart';
import 'package:smart_hb_app/ui/HbDrawer.dart';
import 'package:smart_hb_app/ui/device_list.dart';


import 'components/body.dart';

class ProfileScreen extends StatelessWidget {
  static String routeName = "/profile";

  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, DeviceListScreen.routeName);
        return true;
      },
      child: Scaffold(
        drawer: const HbDrawer(),
        appBar: AppBar(
          backgroundColor: themeBgColour,
          title: const Text("Profile"),
        ),
        body: Body(),
      ),
    );
  }
}
