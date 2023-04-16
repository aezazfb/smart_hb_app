import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class BleStatusScreen extends StatelessWidget {
  const BleStatusScreen({required this.mystatus, Key? key}) : super(key: key);

  final BleStatus mystatus;

  String determineText(BleStatus status) {
    switch (status) {
      case BleStatus.unsupported:
        return "This device does not support Bluetooth";
      case BleStatus.unauthorized:
        return "Authorise the SmartHb app to use Bluetooth";
      case BleStatus.poweredOff:
        return "Bluetooth is powered off on your device turn it on";
      // case BleStatus.locationServicesDisabled:
      //   return "Enable location services";
      case BleStatus.ready:
        return "Bluetooth is up and running";
      default:
        return "Waiting to fetch Bluetooth status $status";
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Text(determineText(mystatus)),
        ),
      );
}
