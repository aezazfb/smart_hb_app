import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
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
  final DiscoveredDevice theDevice;
  final frb = FlutterReactiveBle();
  final ble_controller = Get.put(BleController());
  late BleDeviceConnector connectMyDevice;
  bool isObsecured = true;
  late StreamSubscription<ConnectionStateUpdate> connection;
  late QualifiedCharacteristic rx;
  RxString status = 'not connected'.obs;
  RxString hbValue = ' '.obs;
  String myd = '';

  void _disconnect_it(dev){
    connectMyDevice.disconnect(dev);
    //isConnected = false;
  }

  void readData() async{
    // rx = QualifiedCharacteristic(
    //     serviceId: Uuid.parse("ffe0"),
    //     characteristicId: Uuid.parse("ffe1"),
    //     deviceId: theDevice.id
    // );
    //
    // // subscribe to rx
    // frb.subscribeToCharacteristic(rx).listen((data){
    //   hbValue.value = ascii.decode(data).toString();
    // });


    status.value = 'connecting...';
    connection = frb.connectToDevice(id: theDevice.id).listen((state){
      if (state.connectionState == DeviceConnectionState.connected){
        status.value = 'connected!';

        // get rx
        rx = QualifiedCharacteristic(
            serviceId: Uuid.parse("ffe0"),
            characteristicId: Uuid.parse("ffe1"),
            deviceId: theDevice.id);

        // subscribe to rx
        frb.subscribeToCharacteristic(rx).listen((data){
          hbValue.value = ascii.decode(data).toString();
        });}});
  }

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
                        Text('Hello ${theDevice.name} ${hbValue.value.obs}', style: TextStyle(
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
                        Obx(() => Text('HB is: ${ble_controller.temperature }',
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
                                Fluttertoast.showToast(msg: 'Connected to ${ble_controller.status}!',
                                    timeInSecForIosWeb: 3);
                                readData();
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
                        SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: TextButton(
                            onPressed: (){
                              Fluttertoast.showToast(msg: 'Connected to ${ble_controller.temperature}!',
                                  timeInSecForIosWeb: 3);
                            },
                            child: Text('Create Account', style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                            ),),
                          ),
                          ),
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
}
