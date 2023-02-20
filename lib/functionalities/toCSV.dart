import 'dart:io';

import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

/// Convert a map list to csv
// String? mapListToCsv(List<Map<String, Object?>>? mapList,
//     {ListToCsvConverter? converter}) {
//   if (mapList == null) {
//     return null;
//   }
//   converter ??= const ListToCsvConverter();
//   var data = <List>[];
//   var keys = <String>[];
//   var keyIndexMap = <String, int>{};
//
//   // Add the key and fix previous records
//   int addKey(String key) {
//     var index = keys.length;
//     keyIndexMap[key] = index;
//     keys.add(key);
//     for (var dataRow in data) {
//       dataRow.add(null);
//     }
//     return index;
//   }
//
//   for (var map in mapList) {
//     // This list might grow if a new key is found
//     var dataRow = List<Object?>.filled(keyIndexMap.length, null);
//     // Fix missing key
//     map.forEach((key, value) {
//       var keyIndex = keyIndexMap[key];
//       if (keyIndex == null) {
//         // New key is found
//         // Add it and fix previous data
//         keyIndex = addKey(key);
//         // grow our list
//         dataRow = List.from(dataRow, growable: true)..add(value);
//       } else {
//         dataRow[keyIndex] = value;
//       }
//     });
//     data.add(dataRow);
//   }
//   return converter.convert(<List>[keys, ...data]);

late List<List<dynamic>> employeeData;
late String fileName;

getCsv() async {

  if (await Permission.storage.request().isGranted) {

//store file in documents folder

    String dir = "${(await getExternalStorageDirectory())!.path}/$fileName.csv";
    String file = "$dir";

    File f = new File(file);

// convert rows to String and write as csv file

    String csv = const ListToCsvConverter().convert(employeeData);
    f.writeAsString(csv);
  }else{

    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
  }
}