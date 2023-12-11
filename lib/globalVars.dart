import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get/get.dart';

Uint8List example = Uint8List.fromList([0, 2, 5 ,7]);

DiscoveredDevice fakeDevice = DiscoveredDevice(id: "1", name: "Az", serviceData: {}, manufacturerData: example, rssi: 2, serviceUuids: []);
DiscoveredDevice? theGlobalDevice;
bool? deviceConnected;
final DiscoveredDevice fakeGlobalDevice = fakeDevice;


final themeBtnColour = Colors.lightGreen.shade300;
final themeBgColour = Colors.lightGreen.shade300;
const themeFont = 'Helvetica Regular';

bool readingData = false;
bool isSaveBtnDisabled = false;
bool saveVisibility = true;

RxBool popUpObscure = false.obs;
RxBool popUpObscure1 = false.obs;

String? currentUser;