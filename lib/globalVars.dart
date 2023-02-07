import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

Uint8List example = Uint8List.fromList([0, 2, 5 ,7]);

DiscoveredDevice fakeDevice = DiscoveredDevice(id: "1", name: "Az", serviceData: {}, manufacturerData: example, rssi: 2, serviceUuids: []);
late final DiscoveredDevice theGlobalDevice;
final DiscoveredDevice fakeGlobalDevice = fakeDevice;


final themeBtnColour = Colors.lightGreen.shade300;
final themeBgColour = Colors.lightGreen.shade300;
const themeFont = 'Helvetica Regular';