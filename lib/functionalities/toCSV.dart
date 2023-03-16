import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

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
late String dir;
getCsv(BuildContext context) async {

  if (await Permission.storage.request().isGranted) {

//store file in documents folder

     dir = "${(await getExternalStorageDirectory())!.path}/$fileName.csv";
    String file = "$dir";

    File f = new File(file);

// convert rows to String and write as csv file

    String csv = const ListToCsvConverter().convert(employeeData);
    f.writeAsString(csv).then((value) async {
    await onShare(context, dir, fileName);


    });
  }else{

    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
  }
}

onShare(BuildContext context, String fPath, String fileName) async {
  // A builder is used to retrieve the context immediately
  // surrounding the ElevatedButton.
  //
  // The context's `findRenderObject` returns the first
  // RenderObject in its descendent tree when it's not
  // a RenderObjectWidget. The ElevatedButton's RenderObject
  // has its position and size after it's built.
  final box = context.findRenderObject() as RenderBox?;
  final files = <XFile>[];
  files.add(XFile(fPath, name: fileName));
  await Share.shareXFiles(files,
      text: "$fileName's Hb Data.",
      subject: "$fileName's Hb Data",
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size).then((value)
  {
    String msg = "Data Exported Successfully!";
    Fluttertoast.showToast(msg: msg,
        timeInSecForIosWeb: 2);
  });

}