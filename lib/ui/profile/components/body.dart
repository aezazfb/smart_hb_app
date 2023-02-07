import 'package:flutter/material.dart';
import 'package:smart_hb_app/globalVars.dart';
import 'package:smart_hb_app/ui/Menu/profiles.dart';
import 'package:smart_hb_app/ui/dataScreen.dart';

import 'profile_menu.dart';
import 'profile_pic.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          const ProfilePic(),
          const SizedBox(height: 20),
          ProfileMenu(
            text: "New Profile",
            icon: "myassets/User Icon.svg",
            press: () {
              if(theGlobalDevice != null) {
                Navigator.pushReplacementNamed(context, dataScreen.routeName);
              }
              else{
                showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('No Device Found!'),
                      content: const Text('Device required to add new profile.'),
                      actions: <Widget>[
                        IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              Navigator.pop(context);
                            })
                      ],
                    ));
              }
            },
          ),
          ProfileMenu(
            text: "Existing Profiles",
            icon: "myassets/User.svg",
            press: () {
              if(true) {
                Navigator.pushReplacementNamed(context, HbsPage.routeName);
              }
              else{

              }
            },
          ),

        ],
      ),
    );
  }
}
