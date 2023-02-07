import 'package:flutter/material.dart';
import 'package:smart_hb_app/globalVars.dart';
import 'package:smart_hb_app/ui/device_list.dart';
import 'package:smart_hb_app/ui/profile/profile_screen.dart';

class HbDrawer extends StatelessWidget {
  const HbDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: themeBgColour,
      child: Column(
        children: [
          const Spacer(flex: 1,),
          ListView(
            shrinkWrap: true,
            children: [
              DrawerHeader(

                padding: const EdgeInsets.only(left: 3.0, right: 3),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 57),
                      child: SizedBox(
                        width: 170,
                        child: Image(
                          image: AssetImage("myassets/sHbLogo.png"),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4.0),
                    RichText(
                        text: const TextSpan(
                            text: ('\n'),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                            children: [
                              TextSpan(
                                  text: '',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400))
                            ]))
                  ],
                ),
              ),
              ListTile(
                leading:
                 Icon(Icons.history_toggle_off, color: themeBgColour),
                title: const Text('Profiles'),
                onTap: (){
                  Navigator.pushReplacementNamed(context, ProfileScreen.routeName);
                  },
              ),
              const Divider(
                thickness: 0.5,
                height: 1,
                color: Colors.grey,
              ),
              // ListTile(
              //   leading: Icon(Icons.settings_applications_outlined,
              //       color: themeBgColour),
              //   title: Text('Settings'),
              // ),
              // Divider(
              //   thickness: 0.5,
              //   height: 1,
              //   color: Colors.grey,
              // ),
              // ListTile(
              //   leading: const Icon(Icons.share_sharp, color: themeBgColour),
              //   title: const Text('Share'),
              //   onTap: () => {
              //
              //   },
              // ),
              // const Divider(
              //   thickness: 0.5,
              //   height: 1,
              //   color: Colors.grey,
              // ),
              ListTile(
                leading:
                 Icon(Icons.feedback_outlined, color: themeBgColour),
                title: const Text('Device List'),
                onTap: () => Navigator.pushReplacementNamed(context, DeviceListScreen.routeName),
              ),
              const Divider(
                thickness: 0.5,
                height: 1,
                color: Colors.grey,
              ),
              ListTile(
                leading:  Icon(Icons.call, color: themeBgColour),
                title: const Text('Contact us'),
                onTap: () => showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Contact Details'),
                      content: const Text('+9203123456789'),
                      actions: <Widget>[
                        IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              Navigator.pop(context);
                            })
                      ],
                    )),
              ),
              const Divider(
                thickness: 0.5,
                height: 1,
                color: Colors.grey,
              ),
              // ListTile(
              //   leading: Icon(Icons.monetization_on_outlined,
              //       color: themeBgColour),
              //   title: Text('Wallet'),
              // ),
              // Divider(
              //   thickness: 0.5,
              //   height: 1,
              //   color: Colors.grey,
              // ),
              ListTile(
                leading:
                 Icon(Icons.info_outline_rounded, color: themeBgColour),
                title: const Text('About'),
                onTap: () {
                  showAboutDialog(
                      context: context,
                      applicationName: "SmartHb",
                      applicationLegalese: 'All Rights Reserved techEnterprises',
                      //,
                      children: [
                        const Text('1.0.1'),
                      ]);
                },
              ),
              const Divider(
                thickness: 0.5,
                height: 1,
                color: Colors.grey,
              ),
              // ListTile(
              //     leading: const Icon(Icons.logout, color: themeBgColour),
              //     title: const Text('Logout'),
              //     onTap: () async {
              //
              //
              //     }),
            ],
          ),
          const Spacer(flex: 2,)
        ],
      ),
    );
  }
}
