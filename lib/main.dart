import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:smart_hb_app/functionalities/ble_device_connector.dart';
// import 'package:myble2/src/ble/ble_device_connector.dart';
import 'package:smart_hb_app/functionalities/ble_device_interactor.dart';
// import 'package:myble2/src/ble/ble_device_interactor.dart';
import 'package:smart_hb_app/functionalities/ble_scanner.dart';
// import 'package:myble2/src/ble/ble_scanner.dart';
import 'package:smart_hb_app/functionalities/ble_status_monitor.dart';
import 'package:smart_hb_app/routes.dart';
import 'package:smart_hb_app/ui/Menu/profiles.dart';
// import 'package:myble2/src/ble/ble_status_monitor.dart';

import 'package:smart_hb_app/ui/ble_status_screen.dart';
import 'package:smart_hb_app/ui/dataScreen.dart';
//import 'package:myble2/src/ui/ble_status_screen.dart';

import 'package:smart_hb_app/ui/device_list.dart';
// import 'package:myble2/src/ui/device_list.dart';
import 'package:provider/provider.dart';
import "package:firebase_core/firebase_core.dart";

import 'package:smart_hb_app/functionalities/ble_logger.dart';
import 'package:smart_hb_app/ui/localLogin.dart';
import 'package:smart_hb_app/ui/splashscreen.dart';
// import 'src/ble/ble_logger.dart';

const _themeColor = Colors.green;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final _bleLogger = BleLogger();
  final _ble = FlutterReactiveBle();
  final _scanner = BleScanner(ble: _ble, logMessage: _bleLogger.addToLog);
  final _monitor = BleStatusMonitor(_ble);
  Uint8List example = Uint8List.fromList([0, 2, 5 ,7]);

  DiscoveredDevice fakeDevice = DiscoveredDevice(id: "1", name: "Az", serviceData: {}, manufacturerData: example, rssi: 2, serviceUuids: []);
  final _connector = BleDeviceConnector(
    ble: _ble,
    logMessage: _bleLogger.addToLog,
  );
  final _serviceDiscoverer = BleDeviceInteractor(
    bleDiscoverServices: _ble.discoverServices,
    readCharacteristic: _ble.readCharacteristic,
    writeWithResponse: _ble.writeCharacteristicWithResponse,
    writeWithOutResponse: _ble.writeCharacteristicWithoutResponse,
    subscribeToCharacteristic: _ble.subscribeToCharacteristic,
    logMessage: _bleLogger.addToLog,
  );

  final navKey = GlobalKey<NavigatorState>();

  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: _scanner),
        Provider.value(value: _monitor),
        Provider.value(value: _connector),
        Provider.value(value: _serviceDiscoverer),
        Provider.value(value: _bleLogger),
        StreamProvider<BleScannerState?>(
          create: (_) => _scanner.state,
          initialData: const BleScannerState(
            discoveredDevices: [],
            scanIsInProgress: false,
          ),
        ),
        StreamProvider<BleStatus?>(
          create: (_) => _monitor.state,
          initialData: BleStatus.unknown,
        ),
        StreamProvider<ConnectionStateUpdate>(
          create: (_) => _connector.state,
          initialData: const ConnectionStateUpdate(
            deviceId: 'Unknown device',
            connectionState: DeviceConnectionState.disconnected,
            failure: null,
          ),
        ),
      ],
      child: MaterialApp(navigatorKey: navKey,
        title: 'SmartHb',
        color: _themeColor,
        theme: ThemeData(primarySwatch: _themeColor),
        home:  const SplashScreen(),
        routes: routes,
      ),
    ),
  );
}

class HomeScreen extends StatelessWidget {
  static String routeName = "/homeee";
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer<BleStatus?>(
    builder: (_, status, __) {
      if (status == BleStatus.ready) {
        return LocalLoginScreen();
        // return const DeviceListScreen();
      } else {
        //return const DeviceListScreen();
        return BleStatusScreen(mystatus: status ?? BleStatus.unknown);
      }
    },
  );
}
