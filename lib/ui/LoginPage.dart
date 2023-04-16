import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen2 extends StatefulWidget {
  static String routeName = "/login";
  @override
  _LoginScreen2State createState() => _LoginScreen2State();
}

class _LoginScreen2State extends State<LoginScreen2> {

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }
  final emailController = TextEditingController();
  final passController = TextEditingController();

  bool isObsecured = true;

  void _Switch()
  {
    setState(() {
      isObsecured = !isObsecured;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Text('Hello', style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 40,
                            fontWeight: FontWeight.w700
                        ),),
                        Text('.', style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 40,
                            fontWeight: FontWeight.w700,
                            color: Color.fromRGBO(93, 157, 254, 1)
                        ),),
                      ],
                    ),

                    Row(
                      children: const [
                        Text('Payment', style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 40,
                            fontWeight: FontWeight.w700,
                            color: Color.fromRGBO(93, 157, 254, 1)
                        ),),
                        Text(' Error', style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                        ),),
                      ],
                    ),

                    const SizedBox(
                      height: 80,
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Color.fromRGBO(93, 157, 254, 1)),
                              ),
                              labelText: 'USERNAME',
                              labelStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1,
                                  color: Colors.grey[400],
                                  fontSize: 15
                              )
                          ),
                        ),
                        const SizedBox(
                          height: 35,
                        ),

                        TextFormField(
                          controller: passController,
                          obscureText: isObsecured,
                          decoration: InputDecoration(
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Color.fromRGBO(93, 157, 254, 1)),
                              ),
                              fillColor: Colors.green,
                              labelText: 'PASSWORD',
                              suffixIcon: IconButton(
                                onPressed: ()
                                {
                                  _Switch();
                                },
                                icon: Icon(isObsecured ? Icons.remove_red_eye : Icons.visibility_off),
                              ),
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1,
                                fontFamily: 'Montserrat',
                                color: Colors.grey[400],
                                fontSize: 15,
                              )
                          ),
                        ),
                        // TextButton(onPressed: (){},
                        //     child: Text('Forget Password?', style: TextStyle(
                        //         fontFamily: 'Montserrat',
                        //         fontWeight: FontWeight.w500,
                        //         color: Colors.grey[400]
                        //     ),)
                        // ),

                        const SizedBox(
                          height: 40,
                        ),

                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: signIn,
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(const Color.fromRGBO(93, 157, 254, 1)),
                            ),
                            child: const Text('LOGIN', style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                            )),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        // SizedBox(
                        //   height: 50,
                        //   width: double.infinity,
                        //   child: TextButton(
                        //     onPressed: (){},
                        //     child: const Text('Create Account', style: TextStyle(
                        //       fontFamily: 'Montserrat',
                        //       fontWeight: FontWeight.w600,
                        //     ),),
                        //   ),
                        // ),
                      ],
                    ),


                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future signIn () async {

    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text.trim(), password: passController.text.trim());
    }
    on FirebaseAuthException catch (e) {
      print(e);
    }
  }
}
