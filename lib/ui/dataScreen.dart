import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_hb_app/Models/hBData.dart';
import 'package:smart_hb_app/classes/saveData.dart';
import 'package:smart_hb_app/functionalities/ble_device_connector.dart';
import 'package:smart_hb_app/functionalities/ble_readData.dart';

class dataScreen extends StatefulWidget {

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

  late List<HBData> theHbData;
  bool isLoading = false;

  Future refreshHbs() async {
    setState(() {
      isLoading = true;
    });
    this.theHbData = await db_connection.instance.getAllhBs();

    setState(() {
      isLoading = false;
    });
  }

  Future addHB(RxString hb) async{
    final nt = HBData(
        firstName: firstnameController.text.isEmpty ? 'testdata' : firstnameController.text,
        lastName: lastnameController.text.isEmpty ? 'Ltestdata' : lastnameController.text,
        hBValue: hb.toString(),
        date: DateTime.now());
    await db_connection.instance.create(nt).then((value) => Fluttertoast.showToast(msg: 'Added!!! ${value.id}',
        timeInSecForIosWeb: 3));
  }

  mytoast(msg, tme){
    Fluttertoast.showToast(msg: msg, timeInSecForIosWeb: tme);
  }
  
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController entryController = TextEditingController();

  bool isSaveBtnDisabled = false;


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
                      children: [
                        Text('Hello ${theDevice.name} ', style: TextStyle(
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
                      children: [
                        Text('Welcome', style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 40,
                            fontWeight: FontWeight.w700,
                            color: Color.fromRGBO(93, 157, 254, 1)
                        ),),
                        // Text(' Back ${myd}', style: TextStyle(
                        //     fontFamily: 'Montserrat',
                        //     fontSize: 40,
                        //     fontWeight: FontWeight.w700,
                        // ),),
                        Obx(() => Text('~${theData.hB}',
                            style:TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 40,
                                fontWeight: FontWeight.w700
                            ))),
                      ],
                    ),

                    SizedBox(
                      height: 80,
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextFormField(
                          controller: firstnameController,
                          decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
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
                        SizedBox(
                          height: 35,
                        ),

                        TextFormField(
                          controller: lastnameController,
                          obscureText: isObsecured,
                          decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
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
                        TextFormField(
                          controller: entryController,
                          decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color.fromRGBO(93, 157, 254, 1)),
                              ),
                              labelText: 'konsa',
                              labelStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1,
                                  color: Colors.grey[400],
                                  fontSize: 15
                              )
                          ),
                        ),
                        SizedBox(
                          height: 35,
                        ),
                        TextButton(onPressed: (){},
                            child: Text('Forget Password?', style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[400]
                            ),)
                        ),

                        SizedBox(
                          height: 40,
                        ),

                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                              onPressed: (){
                                //ble_controller.connect(theDevice.id);
                                Fluttertoast.showToast(msg: 'Reading Data from ${theDevice.name}!',
                                    timeInSecForIosWeb: 3);
                                theData.readData(theDevice.id);
                                isSaveBtnDisabled = true;
                                // myd = hbValue.value;
                              },
                              child: Text('Read Data', style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                              )),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Color.fromRGBO(93, 157, 254, 1)),
                              ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),

                        //MyButton Az
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                // db_connection.instance.create(HBData(
                                //     firstName: firstnameController.text.isEmpty ? 'testdata' : firstnameController.text,
                                //     lastName: lastnameController.text.isEmpty ? 'Ltestdata' : lastnameController.text,
                                //     hBValue: '1 abhi',
                                //     date: DateTime.now())).then((value) => Fluttertoast.showToast(msg: 'Added!!! $value',
                                //     timeInSecForIosWeb: 3));
                              });
                              isSaveBtnDisabled ? addHB(theData.hB) : mytoast("Read Data First!", 3);
                            },
                            child: Text('Save Data', style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                            )),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Color.fromRGBO(93, 157, 254, 1)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),

                        SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: TextButton(
                            onPressed: (){
                              Fluttertoast.showToast(msg: 'This ${theData.hB}!',
                                  timeInSecForIosWeb: 3);
                            },
                            child: Text('Create Account', style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                            ),),
                          ),
                          ),
                        SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: TextButton(
                            onPressed: (){
                              Fluttertoast.showToast(msg: 'Refreshing!!!',
                                  timeInSecForIosWeb: 3);
                              refreshHbs();
                            },
                            child: Text('Refresh list', style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                            ),),
                          ),
                          ),
                      ],
                    ),

                    SizedBox(
                      height: 40,
                    ),

                    isLoading ? CircularProgressIndicator() :
                    // ListView.builder(itemBuilder: (BuildContext context, int index) {
                    //
                    //   final theNoteHb = theHbData[index];
                    //
                    //   return ListTile(title: Text('No. $index'),
                    //     leading: Text('the hb is ${theNoteHb.hBValue} !!'),
                    //   trailing: Text(DateFormat.yMMMd().format(theNoteHb.date)),);
                    // },
                    //   itemCount: theHbData.length,
                    // ),

                    // StaggeredGridView.countBuilder(crossAxisCount: 4,
                    //     itemCount: theHbData.length,
                    //     mainAxisSpacing: 4,
                    //     crossAxisSpacing: 4,
                    //     padding: EdgeInsets.all(7),
                    //     itemBuilder: (context, index) {
                    //   final theNoteHb = theHbData[index];
                    //   return GestureDetector(
                    //     onDoubleTap: (){refreshHbs();},
                    //     child: Container(child: Column(
                    //       children: <Widget>[
                    //         Text(DateFormat.yMMMd().format(theNoteHb.date)),
                    //
                    //         Text('the hb is ${theNoteHb.hBValue} !!'),
                    //       ],
                    //     ),),
                    //   );
                    // }, staggeredTileBuilder: (index) => StaggeredTile.fit(2)),

                // GestureDetector(
                //   onDoubleTap: (){refreshHbs();},
                //   child: Container(child: Column(
                //     children: <Widget>[
                //       Text(DateFormat.yMMMd().format(theHbData[int.parse(entryController.text)].date)),
                //
                //       Text('the hb is ${theHbData[int.parse(entryController.text)].hBValue} !!'),
                //     ],
                //   ),),
                // ),
                    ElevatedButton(onPressed: (){
                      refreshHbs();
                      Fluttertoast.showToast(msg: '${theHbData[int.parse(entryController.text)].firstName} ${theHbData[int.parse(entryController.text)].hBValue} ' + DateFormat.yMMMd().format(theHbData[int.parse(entryController.text)].date),
                          timeInSecForIosWeb: 3);
                    }, child: Text('Pop it')),

                    Text('ENDDDDDDDDDDDDDDDDDDDDD'),

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
