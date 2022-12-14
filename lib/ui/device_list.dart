import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:myble2/src/ble/ble_scanner.dart';
import 'package:smart_hb_app/functionalities/ble_scanner.dart';
import 'package:provider/provider.dart';
import 'package:smart_hb_app/functionalities/ble_device_connector.dart';

import 'package:smart_hb_app/ui/dataScreen.dart';
import '../widgets.dart';
// import 'device_detail/device_detail_screen.dart';

class DeviceListScreen extends StatelessWidget {
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
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Scan for devices'),
          backgroundColor: Colors.amberAccent,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const Text('Service UUID (2, 4, 16 bytes):'),
                  TextField(
                    controller: _uuidController,
                    enabled: !widget.scannerState.scanIsInProgress,
                    decoration: InputDecoration(
                        errorText:
                            _uuidController.text.isEmpty || _isValidUuidInput()
                                ? null
                                : 'Invalid UUID format'),
                    autocorrect: false,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        child: const Text('Scan'),
                        onPressed: !widget.scannerState.scanIsInProgress &&
                                _isValidUuidInput()
                            ? _startScanning
                            : null,
                      ),
                      ElevatedButton(
                        child: const Text('Stop'),
                        onPressed: widget.scannerState.scanIsInProgress
                            ? widget.stopScan
                            : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(!widget.scannerState.scanIsInProgress
                            ? 'Enter a UUID above and tap start to begin scanning'
                            : 'Tap a device to connect to it'),
                      ),
                      if (widget.scannerState.scanIsInProgress ||
                          widget.scannerState.discoveredDevices.isNotEmpty)
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.only(start: 18.0),
                          child: Text(
                              'count: ${widget.scannerState.discoveredDevices.length}'),
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
                        subtitle: Text("${device.id}\nRSSI: ${device.rssi}"),
                        leading: const BluetoothIcon(),
                        onTap: () async {
                          widget.stopScan();

                          // Fluttertoast.showToast(msg: device.name + device.id,
                          //     timeInSecForIosWeb: 3);
                          // _connect_it(device.id);
                          // Fluttertoast.showToast(msg: 'Connected to ${device.name}!',
                          //     timeInSecForIosWeb: 3);
                          if(isConnected){
                            // my disconnect condition
                            _disconnect_it(device.id);
                            Fluttertoast.showToast(msg: 'Disconnected ${device.name}!',
                                timeInSecForIosWeb: 3);
                          }
                          else{
                            _connect_it(device.id);
                            Fluttertoast.showToast(msg: 'Connected to ${device.name}!',
                                timeInSecForIosWeb: 3);
                            await Navigator.push<void>(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        dataScreen(thedevice: device)));
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
