import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:smart_hb_app/Models/hBProfileData.dart';
import 'package:smart_hb_app/functionalities/ble_readData.dart';
import 'package:smart_hb_app/globalVars.dart';
import 'package:smart_hb_app/classes/saveData.dart';


class AddNewHb extends StatefulWidget {

  final String theFirstName;
  final int? theProfileId;
  final int? theAge;
  final String? theGender;


   AddNewHb({Key? key, required this.theFirstName, this.theProfileId, this.theAge, this.theGender}) : super(key: key);

  @override
  State<AddNewHb> createState() => _AddNewHbState();
}

class _AddNewHbState extends State<AddNewHb> {
  final DiscoveredDevice theDevice = theGlobalDevice!;

  //final frb = FlutterReactiveBle();
  final theData = Get.put(TheData());

   Future addHBinProfile(RxString hb) async{
     final nt = HBData(
         firstName: widget.theFirstName,
         id: widget.theProfileId, hBValue: "$hb",
         age: widget.theAge ?? 79,
         gender: widget.theGender ?? "Human",
         date: DateTime.now());
     await db_connection.instance.createHb(nt).then((value) => Fluttertoast.showToast(msg: 'Hb Added!!!',
         timeInSecForIosWeb: 2));
   }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      insetPadding: const EdgeInsets.all(10.0),
      titlePadding: const EdgeInsets.all(0.0),
      titleTextStyle: const TextStyle(
          color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
      title: Container(
        width: MediaQuery.of(context).size.width - 40,
        padding: const EdgeInsets.only(left: 10, bottom: 20, top: 10),
        child: const Text('New Hb Entry'),
        decoration: const BoxDecoration(
          color: Colors.lightGreen,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(15),
              topLeft: Radius.circular(15.0)),
        ),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width - 40,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            const SizedBox(height: 7),
            ListTile(
              leading: const Icon(
                Icons.comment,
                //color: util.primaryColor,
              ),
              title: Obx(() => Text('${theData.hB} g/dL',
                  style:const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 40,
                      fontWeight: FontWeight.w700
                  ))),
            ),
            const SizedBox(
              height: 80,
            ),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: (){
                  //ble_controller.connect(theDevice.id);
                  Fluttertoast.showToast(msg: 'Reading Data from ${theDevice.name}!',
                      timeInSecForIosWeb: 3);
                  theData.readData(theDevice.id);
                  setState(() {
                    isSaveBtnDisabled = true;
                    readingData = true;
                  });
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(themeBtnColour),
                ),
                child:  Text(readingData == false ? 'Start Reading Data' : 'Reading Data!', style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                )),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          //color: Colors.green,
            onPressed: () {
              addHBinProfile(theData.hB).then((value)  {

                Navigator.pop(context);
              });


              // String jd = selectedBookingList.elementAt(index).id;
              // CustomerCancelReq.CancelRequest(jd, 'merimarzi');
            },
            child: const Text('Add New Hb!')),
        TextButton(
          //color: util.primaryColor,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Back'))
      ],
    );
  }
}
