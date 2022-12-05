import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';

class BleController {
  final frb = FlutterReactiveBle();
  String dvcid = 'ACF96F8D-3E05-4929-1C08-AC7B86B20453';
  // String dvcid = '68:76:0B:0D:37:C2';
  // String svcid = "0000ffe0-0000-1000-8000-00805f9b34fb";
  String svcid = "180f";
  late StreamSubscription<ConnectionStateUpdate> connection;
  late QualifiedCharacteristic rx;
  RxString status = 'not connected'.obs;
  RxString temperature = ' '.obs;

  void connect() async {
    status.value = 'connecting...';
    connection = frb.connectToDevice(id: dvcid).listen((state){
      if (state.connectionState == DeviceConnectionState.connected){
        status.value = 'connected!';

        // get rx
        rx = QualifiedCharacteristic(
            serviceId: Uuid.parse("ffe0"),
            characteristicId: Uuid.parse("ffe1"),
            deviceId: dvcid);

        // subscribe to rx
        frb.subscribeToCharacteristic(rx).listen((data){
          temperature.value = ascii.decode(data).toString();
        });}});}}