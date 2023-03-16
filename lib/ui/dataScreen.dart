import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_hb_app/Models/hBProfileData.dart';
import 'package:smart_hb_app/classes/saveData.dart';
import 'package:smart_hb_app/functionalities/ble_device_connector.dart';
import 'package:smart_hb_app/functionalities/ble_readData.dart';
import 'package:smart_hb_app/globalVars.dart';
import 'package:smart_hb_app/ui/Menu/profiles.dart';
import 'package:smart_hb_app/ui/profile/profile_screen.dart';

class dataScreen extends StatefulWidget {
  static String routeName = "/add-profile";

  final DiscoveredDevice thedevice;
  const dataScreen({
    required this.thedevice,
    Key? key,
  }) : super(key: key);
  @override
  _dataScreenState createState() => _dataScreenState(theDevice: thedevice);
}

class _dataScreenState extends State<dataScreen> {

  _dataScreenState({
    required this.theDevice
});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshHbs();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    db_connection.instance.closeDb();
  }

  final DiscoveredDevice theDevice;
  final frb = FlutterReactiveBle();
  final theData = Get.put(TheData());

  bool isObsecured = true;
  bool? textIsEmpty ;

  late List<HBData> theHbData;
  bool isLoading = false;

  Future refreshHbs() async {
    setState(() {
      isLoading = true;
    });
    this.theHbData = await db_connection.instance.getAllhBProfiles();

    setState(() {
      isLoading = false;
    });
  }

  Future addProfile(RxString hb) async{
    int age = lastnameController.text.isEmpty ? 79 : int.parse(lastnameController.text);
    String fname = firstnameController.text.isEmpty ? 'Patient' : firstnameController.text;
    final nt = HBData(
        firstName: fname,
        age: age,
        gender: dropdownValue, //genderController.text.isEmpty ? "Other" : genderController.text,
        hBValue: "ValueAdded",
        date: DateTime.now());
    // await db_connection.instance.create(nt).then((value) => Fluttertoast.showToast(msg: 'Added!!! ${value.id}',
    //     timeInSecForIosWeb: 3));

    HBData idAdded = await db_connection.instance.create(nt);
    Fluttertoast.showToast(msg: '${idAdded.firstName} Profile Added!!! ', timeInSecForIosWeb: 3);

    addHB(hb, idAdded.id, age, fname, dropdownValue);
    return idAdded.id;

  }

  Future addHB(RxString hb, int? pid, int age, String fname, String gender) async{
    final nt = HBData(
        firstName: fname,
        id: pid, hBValue: "$hb",
        age: age,
        gender: gender,
        date: DateTime.now());
    await db_connection.instance.createHb(nt).then((value) => Fluttertoast.showToast(msg: 'Hb Added!!! ${value.id}',
        timeInSecForIosWeb: 2));
  }

  mytoast(msg, tme){
    Fluttertoast.showToast(msg: msg, timeInSecForIosWeb: tme);
  }
  
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController entryController = TextEditingController();
  TextEditingController rController = TextEditingController();
  TextEditingController tController = TextEditingController();

  static const List<String> list = <String>['Male', 'Female', 'Other'];
  String dropdownValue = list.first;




  // void readData(dev) async{
  //
  //   rx = QualifiedCharacteristic(
  //       serviceId: Uuid.parse("ffe0"),
  //       characteristicId: Uuid.parse("ffe1"),
  //       deviceId: dev);
  //
  //   // subscribe to rx
  //   frb.subscribeToCharacteristic(rx).listen((data){
  //     hbValue.value = ascii.decode(data).toString();
  //   }
  //   );
  // }

  void _Switch()
  {
    setState(() {
      isObsecured = !isObsecured;
    });
  }
  // bool saveVisibility = false;
  // bool readingData = false;

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: themeBgColour,
            leading: IconButton(onPressed: (){
              Navigator.pushReplacementNamed(context, ProfileScreen.routeName);
            }, icon: const Icon(Icons.arrow_back_rounded),
            color: Colors.white70,),
          ),
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [


                    Visibility(
                      visible: isSaveBtnDisabled,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Obx(() => Text(theData.hB != ' ' ? '${theData.hB} g/dL' : "Let's Read",
                                  style:const TextStyle(
                                      fontFamily: themeFont,
                                      fontSize: 40,
                                      fontWeight: FontWeight.w700
                                  ))),

                              // Text('.', style: TextStyle(
                              //     fontFamily: 'Montserrat',
                              //     fontSize: 40,
                              //     fontWeight: FontWeight.w700,
                              //     color: Color.fromRGBO(93, 157, 254, 1)
                              // ),),
                            ],
                          ),


                          const SizedBox(
                            height: 80,
                          ),

                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(

                              onPressed: (){
                                //ble_controller.connect(theDevice.id);
                                if(readingData == true){
                                  Fluttertoast.showToast(msg: 'Reading Already!',
                                      timeInSecForIosWeb: 2);
                                }
                                else{
                                  Fluttertoast.showToast(msg: 'Reading Data from ${theDevice.name}!',
                                      timeInSecForIosWeb: 3);
                                  theData.readData(theDevice.id);

                                  setState(() {
                                    isSaveBtnDisabled = true;
                                    readingData = true;
                                  });
                                  // myd = hbValue.value;
                                }

                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(themeBtnColour),
                              ),
                              child: Text(readingData == true ? 'Reading Data!' : 'Start Reading Data', style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                              )),
                            ),
                          ),



                          const SizedBox(
                            height: 10,
                          ),

                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () async {

                                // saveVisibility ? addProfile(theData.hB) : mytoast("Read Data First!", 3);
                                addProfile(theData.hB);

                                firstnameController.clear();
                                lastnameController.clear();
                                genderController.clear();

                                setState(() {
                                  saveVisibility == true ? saveVisibility = false : saveVisibility = true;

                                  isSaveBtnDisabled == true ? isSaveBtnDisabled = false : isSaveBtnDisabled = true;
                                  readingData = false;
                                  theData.hB = ' '.obs;
                                });

                                Navigator.pushReplacementNamed(context, HbsPage.routeName);

                                // isSaveBtnDisabled ? addHB(theData.hB) : mytoast("Read Data First!", 3);
                                // setState(() {
                                //   saveVisibility ? saveVisibility = false : saveVisibility = true;
                                //
                                //   isSaveBtnDisabled ? isSaveBtnDisabled = false : isSaveBtnDisabled = true;
                                // });
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(themeBtnColour),
                              ),
                              child: const Text('Save reading!', style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                              )),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 80,
                    ),

                    // Save data UI

                    Visibility(
                      visible: saveVisibility,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          TextFormField(
                            onChanged: (x) {
                              if (firstnameController.text.isNotEmpty && lastnameController.text.isNotEmpty) {
                                setState(() {
                                  textIsEmpty = false;
                                });
                              }
                              else{
                                setState(() {
                                  textIsEmpty = true;
                                });
                              }
                            },
                            // validator: (value) {
                            //   if (value == null || value.isEmpty) {
                            //     //return 'Please enter some text';
                            //     setState(() {
                            //       textIsEmpty = false;
                            //     });
                            //   }
                            //   else{
                            //     setState(() {
                            //       textIsEmpty = true;
                            //     });
                            //   }
                            // },
                            controller: firstnameController,
                            decoration: InputDecoration(
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color.fromRGBO(93, 157, 254, 1)),
                                ),
                              labelText: 'Person Name',
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
                            onChanged: (x) {
                              if (firstnameController.text.isNotEmpty && lastnameController.text.isNotEmpty) {
                                setState(() {
                                  textIsEmpty = false;
                                });
                              }
                              else{
                                setState(() {
                                  textIsEmpty = true;
                                });
                              }
                            },
                            // validator: (value) {
                            //   if (value == null || value.isEmpty) {
                            //     setState(() {
                            //       textIsEmpty = false;
                            //     });
                            //   }
                            //   else{
                            //     setState(() {
                            //       textIsEmpty = true;
                            //     });
                            //   }
                            // },
                            controller: lastnameController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color.fromRGBO(93, 157, 254, 1)),
                                ),
                                labelText: 'Age',
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


                          DropdownButton<String>(
                            isExpanded: true,

                            value: dropdownValue,
                            icon: const Icon(Icons.arrow_downward),
                            elevation: 16,
                            style: const TextStyle(color: Colors.lightGreen),
                            underline: Container(
                              height: 2,
                              color: Colors.lightGreenAccent,
                            ),
                            onChanged: (String? value) {
                              // This is called when the user selects an item.
                              setState(() {
                                dropdownValue = value!;
                              });
                            },
                            items: list.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),

                          const SizedBox(
                            height: 35,
                          ),



                          const SizedBox(
                            height: 40,
                          ),


                          //MyButton Az
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () async {
                                if(textIsEmpty == false){
                                  setState(() {
                                    saveVisibility ? saveVisibility = false : saveVisibility = true;

                                    isSaveBtnDisabled ? isSaveBtnDisabled = false : isSaveBtnDisabled = true;
                                  });
                                }
                                else {
                                  mytoast("Name/Age required!", 3);
                                }



                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(themeBtnColour),
                              ),
                              child: const Text('Next ', style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                              )),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),

                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () async {
                                Navigator.pushReplacementNamed(context, ProfileScreen.routeName);
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(themeBtnColour),
                              ),
                              child: const Text('Cancel', style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                              )),
                            ),
                          ),

                          const SizedBox(
                            height: 10,
                          ),


                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 40,
                    ),

                    // isLoading ? CircularProgressIndicator() :
                    // ElevatedButton(onPressed: (){
                    //   refreshHbs();
                    //   Fluttertoast.showToast(msg: '${theHbData[int.parse(entryController.text)].firstName} ${theHbData[int.parse(entryController.text)].hBValue} ' + DateFormat.yMMMd().format(theHbData[int.parse(entryController.text)].date),
                    //       timeInSecForIosWeb: 3);
                    // }, child: Text('Pop it')),

                    const SizedBox(
                      height: 50,
                    ),

                    const Text('SmartHb Application'),

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
