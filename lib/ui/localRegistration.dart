import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_hb_app/globalVars.dart';
import 'package:smart_hb_app/ui/localLogin.dart';
import 'package:smart_hb_app/classes/saveData.dart';

class LocalRegistrationScreen extends StatefulWidget {
  static String routeName = "/localregisteration";
  @override
  _LocalRegistrationScreenState createState() => _LocalRegistrationScreenState();
}

class _LocalRegistrationScreenState extends State<LocalRegistrationScreen> {

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
    return WillPopScope(
      onWillPop: () async {
        // Navigator.pop(context);
        Navigator.pushReplacementNamed(context, LocalLoginScreen.routeName);
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
                          //   'Register',
                          //   style: TextStyle(
                          //       color: Colors.white,
                          //       fontSize: 35,
                          //       fontWeight: FontWeight.w700),
                          // ),
                          const SizedBox(height: 7,),
                          const Text(
                            'Create new Account',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              // fontWeight: FontWeight.w700),
                            ),
                          )],
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
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black
                                              )
                                          ),
                                          prefixIcon: Icon(color: Color.fromRGBO(24, 79, 27, 1), Icons.email_outlined),
                                          border: OutlineInputBorder(),
                                          hintText: 'Username'),
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
                                      obscureText: isObsecure,
                                      controller: loginPasswordController,
                                      keyboardType: TextInputType.visiblePassword,
                                      decoration: InputDecoration(
                                          focusedBorder: const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black
                                              )
                                          ),
                                          suffixIcon: IconButton(
                                            icon: Icon(color: const Color.fromRGBO(24, 79, 27, 1), isObsecure ? Icons.remove_red_eye : Icons.visibility_off),
                                            onPressed: ()
                                            {
                                              _toggle();
                                            },
                                          ),
                                          prefixIcon: const Icon(color: Color.fromRGBO(24, 79, 27, 1), Icons.lock_outlined),
                                          border: const OutlineInputBorder(),
                                          hintText: 'Password'),
                                    ),
                                    //
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
                                      bool meriIjazatHai = theDoc.get("ijazat");

                                      if(meriIjazatHai){
                                        if(loginIdController.text.isNotEmpty && loginPasswordController.text.isNotEmpty){
                                          await db_connection.instance.createUser(loginIdController.text,
                                              loginPasswordController.text,
                                              'mobile').then((value) {
                                            Fluttertoast.showToast(msg: "${loginIdController.text} is successfully registered!");
                                            Navigator.pushReplacementNamed(context, LocalLoginScreen.routeName);
                                          });
                                        }
                                        else {
                                          if(loginIdController.text.isEmpty && loginPasswordController.text.isEmpty){
                                            Fluttertoast.showToast(msg: "Fields are empty!");
                                          }
                                          else if(loginIdController.text.isEmpty){
                                            Fluttertoast.showToast(msg: "Enter ID");
                                          }
                                          else if(loginPasswordController.text.isEmpty){
                                            Fluttertoast.showToast(msg: "Enter Password");
                                          }
                                        }
                                      }

                                      // await db_connection.instance.createUser(LoginData(loginId: loginIdController.text,
                                      //     loginPassword: loginPasswordController.text,
                                      //     mobile: '213mob'))
                                      //     .then((value) => Navigator.pushReplacementNamed(context, LocalLoginScreen.routeName));

                                      // Navigator.pushReplacementNamed(context, LocalLoginScreen.routeName);
                                    },
                                    child: const Text(
                                      'Register',
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(
                                  height: 20,
                                ),




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
