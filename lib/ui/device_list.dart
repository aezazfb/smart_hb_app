import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:myble2/src/ble/ble_scanner.dart';
import 'package:smart_hb_app/functionalities/ble_scanner.dart';
import 'package:provider/provider.dart';
import 'package:smart_hb_app/functionalities/ble_device_connector.dart';
import 'package:smart_hb_app/globalVars.dart';
import 'package:smart_hb_app/ui/HbDrawer.dart';
import 'package:smart_hb_app/ui/Menu/profiles.dart';

import 'package:smart_hb_app/ui/dataScreen.dart';
import 'package:smart_hb_app/ui/profile/profile_screen.dart';
import '../widgets.dart';
// import 'device_detail/device_detail_screen.dart';

class DeviceListScreen extends StatelessWidget {
  static String routeName = "/deviceList";
  const DeviceListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer3<BleDeviceConnector, BleScanner, BleScannerState?>(
        builder: (_, deviceConnector, bleScanner, bleScannerState, __) => _DeviceList(
          scannerState: bleScannerState ??
              const BleScannerState(
                discoveredDevices: [],
                scanIsInProgress: false,
              ),
          startScan: bleScanner.startScan,
          stopScan: bleScanner.stopScan,
          connectMyDevice: deviceConnector,
        ),
      );
}

class _DeviceList extends StatefulWidget {
  const _DeviceList(
      {required this.scannerState,
      required this.startScan,
      required this.stopScan,
        required this.connectMyDevice});

  final BleScannerState scannerState;
  final void Function(List<Uuid>) startScan;
  final VoidCallback stopScan;
  final BleDeviceConnector connectMyDevice;


  @override
  _DeviceListState createState() => _DeviceListState();
}

class _DeviceListState extends State<_DeviceList> {
  late TextEditingController _uuidController;

  @override
  void initState() {
    super.initState();
    _uuidController = TextEditingController()
      ..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    widget.stopScan();
    _uuidController.dispose();
    super.dispose();
  }

  bool _isValidUuidInput() {
    final uuidText = _uuidController.text;
    if (uuidText.isEmpty) {
      return true;
    } else {
      try {
        Uuid.parse(uuidText);
        return true;
      } on Exception {
        return false;
      }
    }
  }

  bool isConnected = false;
  void _connect_it(dev){
    widget.connectMyDevice.connect(dev);
    isConnected = true;
  }

  void _disconnect_it(dev){
    widget.connectMyDevice.disconnect(dev);
    isConnected = false;
  }

  void _startScanning() {
    final text = _uuidController.text;
    widget.startScan(text.isEmpty ? [] : [Uuid.parse(_uuidController.text)]);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth <= 370 ? 17 : 30;
    return Scaffold(
      drawer: const HbDrawer(),
      appBar: AppBar(
        title: const Text('Scan for SmartHb'),
        backgroundColor: themeBgColour,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                //Text(screenWidth.toString()),
                // const Text('Service UUID (2, 4, 16 bytes):'),
                // TextField(
                //   controller: _uuidController,
                //   enabled: !widget.scannerState.scanIsInProgress,
                //   decoration: InputDecoration(
                //       errorText:
                //           _uuidController.text.isEmpty || _isValidUuidInput()
                //               ? null
                //               : 'Invalid UUID format'),
                //   autocorrect: false,
                // ),
                // const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: themeBtnColour,
                          padding:
                          const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                          textStyle:
                          TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold)),

                      onPressed: !widget.scannerState.scanIsInProgress &&
                          _isValidUuidInput()
                          ? _startScanning
                          : null,
                      child: const Text('Scan'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: themeBtnColour,
                          padding:
                          const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                          textStyle:
                          TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold)),
                      onPressed: widget.scannerState.scanIsInProgress
                          ? widget.stopScan
                          : null,
                      child: const Text('Stop'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(!widget.scannerState.scanIsInProgress
                          ? 'Tap scan to begin scanning!'
                          : 'Tap a device to connect to it!'),
                    ),
                    if (widget.scannerState.scanIsInProgress ||
                        widget.scannerState.discoveredDevices.isNotEmpty)
                      Padding(
                        padding:
                        const EdgeInsetsDirectional.only(start: 18.0),
                        child: Text(
                            'Devices: ${widget.scannerState.discoveredDevices.length}'),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Flexible(
            child: ListView(
              children: widget.scannerState.discoveredDevices
                  .map(
                    (device) => ListTile(
                  title: Text(device.name),
                  subtitle: Text(device.id), //\nRSSI: ${device.rssi}
                  leading: const BluetoothIcon(),
                  onTap: () async {
                    widget.stopScan();

                    // Fluttertoast.showToast(msg: device.name + device.id,
                    //     timeInSecForIosWeb: 3);
                    // _connect_it(device.id);
                    // Fluttertoast.showToast(msg: 'Connected to ${device.name}!',
                    //     timeInSecForIosWeb: 3);
                    if(deviceConnected == true){
                      // my disconnect condition
                      _disconnect_it(theGlobalDevice!.id);
                      Fluttertoast.showToast(msg: 'Disconnected ${theGlobalDevice!.name}!',
                          timeInSecForIosWeb: 3);
                      setState(() {
                        theGlobalDevice = null;
                        //theGlobalDevice = device;
                        deviceConnected = false;
                      });

                      if(theGlobalDevice != null){
                        _connect_it(device.id);
                        Fluttertoast.showToast(msg: 'Connected to ${device.name}!',
                            timeInSecForIosWeb: 3);
                        setState(() {
                          theGlobalDevice = null;
                          theGlobalDevice = device;
                          deviceConnected = true;
                        });
                      }

                    }
                    else{
                      if(theGlobalDevice != null){
                        _disconnect_it(theGlobalDevice!.id);
                      }
                      _connect_it(device.id);
                      Fluttertoast.showToast(msg: 'Connected to ${device.name}!',
                          timeInSecForIosWeb: 3);

                      setState(() {
                        theGlobalDevice = null;
                        theGlobalDevice = device;
                        deviceConnected = true;
                      });

                      Navigator.pushReplacementNamed(context, ProfileScreen.routeName);

                      // await Navigator.push<void>(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (_) =>
                      //             dataScreen(thedevice: theGlobalDevice)));
                    }
                    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Ye rahha snack!")));

                    // await Navigator.push<void>(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (_) =>
                    //             DeviceDetailScreen(device: device)));
                  },
                ),
              )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
