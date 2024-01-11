import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_hb_app/globalVars.dart';
import 'package:smart_hb_app/ui/device_list.dart';
import 'package:smart_hb_app/ui/localRegistration.dart';
import 'package:smart_hb_app/classes/saveData.dart';

class LocalLoginScreen extends StatefulWidget {
  static String routeName = "/locallogin";

  LocalLoginScreen({super.key, this.currentBleStatus});

  BleStatus? currentBleStatus;

  @override
  _LocalLoginScreenState createState() => _LocalLoginScreenState(currentBleStatus);
}

class _LocalLoginScreenState extends State<LocalLoginScreen> {

  _LocalLoginScreenState(
      this.currentBleStatus
      );
  BleStatus? currentBleStatus;

  bool isObsecure = true;

  final loginIdController = TextEditingController();
  final loginPasswordController = TextEditingController();

  void _toggle()
  {
    setState(() {
      isObsecure = !isObsecure;
    });
  }

  @override
  Widget build(BuildContext context) {
    // if(currentBleStatus != BleStatus.ready){
    //   Fluttertoast.showToast(msg: "Bluetooth is Off!");
    // }
    return WillPopScope(
      onWillPop:()async{
        showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Exit Permission'),
              content: const Text('Do you want to exit?'),
              actions: <Widget>[
                IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: () {
                      SystemNavigator.pop();
                    })
              ],
            ));
        return true;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SafeArea(
          child: Scaffold(
              backgroundColor: themeBgColour,
              body: Container(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 70,
                      width: double.infinity,
                      color: themeBgColour,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(width: 150,'myassets/sHbLogo.png'),
                          // Text(
                          //   'Sign in',
                          //   style: TextStyle(
                          //       color: Colors.white,
                          //       fontSize: 35,
                          //       fontWeight: FontWeight.w700),
                          // ),
                          // Text(
                          //   'Sign In',
                          //   style: TextStyle(
                          //     color: Colors.white,
                          //     // fontSize: 18,
                          //     // fontWeight: FontWeight.w700),
                          //   ),
                          // )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: themeBgColour,
                              border: Border.all(color: Colors.green),
                              borderRadius:
                              const BorderRadius.vertical(top: Radius.circular(20))),
                          child: Padding(
                            padding: const EdgeInsets.all(25.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // email
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Username',
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    TextFormField(
                                      controller: loginIdController,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: const InputDecoration(
                                          prefixIcon: Icon(color: Color.fromRGBO(24, 79, 27, 1),Icons.email_outlined),
                                          border: OutlineInputBorder(),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.black
                                            )
                                          ),
                                          hintText: 'Enter Your Username'),
                                    )
                                  ],
                                ),

                                const SizedBox(
                                  height: 20,
                                ),

                                // pwrd
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Password',
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    TextFormField(
                                      controller: loginPasswordController,
                                      obscureText: isObsecure,
                                      keyboardType: TextInputType.visiblePassword,
                                      decoration: InputDecoration(
                                          focusedBorder: const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black
                                              )
                                          ),
                                          suffixIcon: IconButton(
                                            icon: Icon(color: const Color.fromRGBO(24, 79, 27, 1),isObsecure ? Icons.remove_red_eye : Icons.visibility_off),
                                            onPressed: ()
                                            {
                                              _toggle();
                                            },
                                          ),
                                          prefixIcon: const Icon(color: Color.fromRGBO(24, 79, 27, 1), Icons.lock_outlined),
                                          border: const OutlineInputBorder(),
                                          hintText: 'Enter Your Password'),
                                    ),
                                    // Removed forget your pass
                                  ],
                                ),

                                const SizedBox(
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
                                          const Color.fromRGBO(164, 222, 2, 0)),
                                    ),
                                    onPressed: () async {

                                      final FirebaseFirestore theDatabase = FirebaseFirestore.instance;
                                      DocumentSnapshot theDoc = await theDatabase.collection("smarthb").doc("1uyUPZZAKibVCEaKm3aw").get();
                                      bool meriIjazatHai = theDoc.get("developerIjazat");

                                      if(meriIjazatHai){
                                        if(loginIdController.text.isNotEmpty && loginPasswordController.text.isNotEmpty){
                                          await db_connection.instance.loginUser(loginIdController.text)
                                              .then((value) {
                                            if(value==loginPasswordController.text){
                                              setState(() {
                                                currentUser = loginIdController.text;
                                              });
                                              Fluttertoast.showToast(
                                                  msg: "Logged in Successfully!");
                                              Navigator.pushReplacementNamed(context, DeviceListScreen.routeName);
                                            }else if(value=='Id not found!') {
                                              Fluttertoast.showToast(
                                                  msg: 'Id not found!');
                                            } else{
                                              Fluttertoast.showToast(
                                                  msg: 'Incorrect Password!');
                                            }


                                          });
                                        }
                                        else if(loginIdController.text.isEmpty){
                                          Fluttertoast.showToast(msg: "Enter Login ID!");
                                        }
                                        else if(loginPasswordController.text.isEmpty){
                                          Fluttertoast.showToast(msg: "Enter Password!");
                                        }
                                      }



                                      // await db_connection.instance.createUser(LoginData(loginId: loginIdController.text,
                                      //     loginPassword: loginPasswordController.text,
                                      //     mobile: '213mob')).then((value) => Fluttertoast.showToast(msg: value.toString()));
                                    },
                                    child: const Text(
                                      'LOGIN',
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(
                                  height: 20,
                                ),

                                //Removed fb and gmail login

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text('You don\'t have an account yet?'),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pushReplacementNamed(context, LocalRegistrationScreen.routeName);
                                        },
                                        child: const Text(
                                          'Register Now',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        )),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Image.asset(width: 150,'myassets/tech4lifeLogo1.png')
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
