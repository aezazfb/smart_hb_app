import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:smart_hb_app/Models/hBProfileData.dart';
import 'package:smart_hb_app/functionalities/ble_readData.dart';
import 'package:smart_hb_app/ui/profile/profile_screen.dart';
import 'package:smart_hb_app/classes/saveData.dart';
import 'package:smart_hb_app/ui/profileDetailPage.dart';
import '../../globalVars.dart';

class AddNewHbScreen extends StatefulWidget {
  final String theFirstName;
  final int? theProfileId;
  final int? theAge;
  final String? theGender;

  const AddNewHbScreen({Key? key, required this.theFirstName, this.theProfileId, this.theAge, this.theGender}) : super(key: key);

  @override
  State<AddNewHbScreen> createState() => _AddNewHbScreenState();
}

class _AddNewHbScreenState extends State<AddNewHbScreen> {

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
    await db_connection.instance.createHb(nt).then((value) => Fluttertoast.showToast(msg: 'Hb Added!!! ',
        timeInSecForIosWeb: 2));
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: themeBgColour,
            leading: IconButton(onPressed: (){
              Navigator.pushReplacementNamed(context, ProfileScreen.routeName);
            }, icon: const Icon(Icons.arrow_back_rounded),
              color: Colors.white70,),
          ),
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // ignore: unrelated_type_equality_checks
                        Obx(() => Text(theData.hB != ' ' ? '${theData.hB} g/dL' : "",
                            style:const TextStyle(
                                fontFamily: themeFont,
                                fontSize: 40,
                                fontWeight: FontWeight.w700
                            ))),


                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [

                      ],
                    ),

                    // const SizedBox(
                    //   height: 80,
                    // ),
                    //
                    // SizedBox(
                    //   width: double.infinity,
                    //   height: 50,
                    //   child: ElevatedButton(
                    //
                    //     onPressed: (){
                    //
                    //       if(readingData == true){
                    //         Fluttertoast.showToast(msg: 'Reading Already!',
                    //             timeInSecForIosWeb: 2);
                    //       }
                    //       else{
                    //         Fluttertoast.showToast(msg: 'Reading Data from ${theDevice.name}!',
                    //             timeInSecForIosWeb: 3);
                    //         theData.readData(theDevice.id);
                    //
                    //         setState(() {
                    //           isSaveBtnDisabled = true;
                    //           readingData = true;
                    //         });
                    //         // myd = hbValue.value;
                    //       }
                    //
                    //     },
                    //     style: ButtonStyle(
                    //       backgroundColor: MaterialStateProperty.all(themeBtnColour),
                    //     ),
                    //     child: Text(readingData == true ? 'Reading Data!' : 'Start Reading Data', style: const TextStyle(
                    //       fontFamily: 'Montserrat',
                    //       fontWeight: FontWeight.w600,
                    //     )),
                    //   ),
                    // ),



                    const SizedBox(
                      height: 10,
                    ),


                    const SizedBox(
                      height: 80,
                    ),

                    // Save data UI

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          if(theData.hB != ' '){
                            addHBinProfile(theData.hB).then((value) async {

                              // setState(() {
                              //   saveVisibility == true ? saveVisibility = false : saveVisibility = true;
                              //
                              //   isSaveBtnDisabled == true ? isSaveBtnDisabled = false : isSaveBtnDisabled = true;
                              //   readingData = false;
                              //   theData.hB = ' '.obs;
                              // });
                              //
                              // await Navigator.of(context).push(MaterialPageRoute(
                              //   builder: (context) => ProfileDetailPage(fn: widget.theFirstName, profId: widget.theProfileId,),
                              // ));
                            });
                          }
                          else{
                            Fluttertoast.showToast(msg: 'Device Value Empty',
                                timeInSecForIosWeb: 2);
                          }

                          // Navigator.pushReplacementNamed(context, HbsPage.routeName);

                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(themeBtnColour),
                        ),
                        child: const Text('Save reading!', style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                        )),
                      ),
                    ),
                    const SizedBox(height: 13,),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          await Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ProfileDetailPage(fn: widget.theFirstName, profId: widget.theProfileId,),
                          ));
                          // Navigator.pop(context);
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(themeBtnColour),
                        ),
                        child: const Text('Back', style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                        )),
                      ),
                    ),

                    const SizedBox(
                      height: 40,
                    ),

                    // isLoading ? CircularProgressIndicator() :
                    // ElevatedButton(onPressed: (){
                    //   refreshHbs();
                    //   Fluttertoast.showToast(msg: '${theHbData[int.parse(entryController.text)].firstName} ${theHbData[int.parse(entryController.text)].hBValue} ' + DateFormat.yMMMd().format(theHbData[int.parse(entryController.text)].date),
                    //       timeInSecForIosWeb: 3);
                    // }, child: Text('Pop it')),

                    const SizedBox(
                      height: 50,
                    ),

                    const Text('SmartHb Application'),

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
