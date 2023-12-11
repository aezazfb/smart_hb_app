import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:smart_hb_app/globalVars.dart';
import 'package:smart_hb_app/ui/device_list.dart';
import 'package:smart_hb_app/ui/localLogin.dart';
import 'package:smart_hb_app/ui/profile/profile_screen.dart';
import 'package:smart_hb_app/classes/saveData.dart';

class HbDrawer extends StatelessWidget {
  const HbDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final oldPassController = TextEditingController();
    final newPasswordController = TextEditingController();
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
                      content: const Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('info@tech4lifeenterprises.com'),
                          SizedBox(height: 7,),
                          Text('+1-905-203-0370'),
                        ],
                      ),
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
              ListTile(
                leading:  Icon(Icons.call, color: themeBgColour),
                title: const Text('Change Password'),
                onTap: () => showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Password Details'),
                      content:  Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SingleChildScrollView(
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                  BorderRadius.vertical(top: Radius.circular(20))),
                              child: Padding(
                                padding: const EdgeInsets.all(25.0),
                                child: Column(
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // email
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Old Password',
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Obx(() => TextFormField(
                                          obscureText: popUpObscure1.value,
                                          controller: oldPassController,
                                          keyboardType: TextInputType.visiblePassword,
                                          decoration: InputDecoration(
                                              suffixIcon: IconButton(
                                                icon: Icon(!popUpObscure1.value ? Icons.remove_red_eye : Icons.visibility_off),
                                                onPressed: ()
                                                {
                                                  popUpObscure1.value = !popUpObscure1.value;
                                                },
                                              ),
                                              prefixIcon: Icon(Icons.lock_outlined),
                                              border: OutlineInputBorder(),
                                              hintText: 'Enter Old Password'),
                                        ),)
                                      ],
                                    ),

                                    SizedBox(
                                      height: 20,
                                    ),

                                    // pwrd
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'New Password',
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Obx(() => TextFormField(
                                          obscureText: popUpObscure.value,
                                          controller: newPasswordController,
                                          keyboardType: TextInputType.visiblePassword,
                                          decoration: InputDecoration(
                                              suffixIcon: IconButton(
                                                icon: Icon(!popUpObscure.value ? Icons.remove_red_eye : Icons.visibility_off),
                                                onPressed: ()
                                                {
                                                  popUpObscure.value = !popUpObscure.value;
                                                },
                                              ),
                                              prefixIcon: Icon(Icons.lock_outlined),
                                              border: OutlineInputBorder(),
                                              hintText: 'Enter Old Password'),
                                        ),)
                                        //
                                      ],
                                    ),

                                    SizedBox(
                                      height: 10,
                                    ),

                                    // login btn
                                    SizedBox(
                                      width: double.infinity,
                                      height: 55,
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(30),
                                              )),
                                          backgroundColor: MaterialStateProperty.all(
                                              themeBgColour),
                                        ),
                                        onPressed: () async {

                                          await db_connection.instance.changeUserPass(currentUser!,
                                              newPasswordController.text,
                                              'mobile').then((value) {
                                            Fluttertoast.showToast(msg: value);
                                            newPasswordController.clear();
                                            oldPassController.clear();
                                            Navigator.pop(context);

                                          });

                                          // await db_connection.instance.createUser(LoginData(loginId: loginIdController.text,
                                          //     loginPassword: loginPasswordController.text,
                                          //     mobile: '213mob'))
                                          //     .then((value) => Navigator.pushReplacementNamed(context, LocalLoginScreen.routeName));

                                          // Navigator.pushReplacementNamed(context, LocalLoginScreen.routeName);
                                        },
                                        child: Text(
                                          'Change Password',
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ),

                                    // SizedBox(
                                    //   height: 20,
                                    // ),




                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      actions: <Widget>[
                        IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              newPasswordController.clear();
                              oldPassController.clear();
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
              // ListTile(
              //   leading:
              //    Icon(Icons.info_outline_rounded, color: themeBgColour),
              //   title: const Text('About'),
              //   onTap: () {
              //     showAboutDialog(
              //         context: context,
              //         applicationName: "SmartHb",
              //         applicationLegalese: 'All Rights Reserved Tech4Life Enterprises',
              //         //,
              //         children: [
              //           const Text('1.0.1'),
              //         ]);
              //   },
              // ),
              ListTile(
                leading:  Icon(Icons.call, color: themeBgColour),
                title: const Text('About'),
                onTap: () => showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('SmartHb'),
                      content: const Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('All Rights Reserved Tech4Life Enterprises'),
                          SizedBox(height: 7,),
                          Text('Version 1.0.0'),
                        ],
                      ),
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
              ListTile(
                leading:  Icon(Icons.call, color: themeBgColour),
                title: const Text('Logout'),
                onTap: () => showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Logout Permission'),
                      content: const Text('Do you want to Logout?'),
                      actions: <Widget>[
                        IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                        IconButton(
                            icon: const Icon(Icons.check),
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, LocalLoginScreen.routeName);
                            })
                      ],
                    )),
              )
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
