import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_hb_app/Models/hBProfileData.dart';
import 'package:smart_hb_app/classes/saveData.dart';
import 'package:smart_hb_app/functionalities/ble_readData.dart';
import 'package:smart_hb_app/globalVars.dart';
import 'package:smart_hb_app/ui/addEditProfile.dart';
import 'package:smart_hb_app/ui/hBEntryRow_widget.dart';

class ProfileDetailPage extends StatefulWidget {
  //final int noteId;
  final String fn;
  final int? profId;

  const ProfileDetailPage({
    Key? key,
    //required this.noteId,
    required this.fn,
    this.profId
  }) : super(key: key);

  @override
  _ProfileDetailPageState createState() => _ProfileDetailPageState();
}

class _ProfileDetailPageState extends State<ProfileDetailPage> {
  late HBData note;
  late HBData hBbyId;
  late List<HBData> notes;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshNote();
  }

  final DiscoveredDevice theDevice = theGlobalDevice;
  //final frb = FlutterReactiveBle();
  final theData = Get.put(TheData());

  Future refreshNote() async {
    setState(() => isLoading = true);

    this.note = await db_connection.instance.getHB(widget.fn);
    //this.hBbyId = await db_connection.instance.getHBbyId(widget.profId);
    this.notes = await db_connection.instance.getAllhBsById(widget.profId);

    setState(() => isLoading = false);


  }

  Future addHBinProfile(RxString hb) async{
    final nt = HBData(
        firstName: widget.fn,
        id: widget.profId, hBValue: hb.toString(),
        age: 79,
        gender: "In Profile",
        date: DateTime.now());
    await db_connection.instance.createHb(nt).then((value) => Fluttertoast.showToast(msg: 'hB Added!!! ${value.id}',
        timeInSecForIosWeb: 2));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Row(
        children: [
          Text(note.firstName),
          Column(children: [
            Text("Gender: ${note.gender}"),
            Text("Age: ${note.age}"),
          ],)
        ],
      ),
      // actions: [Column(
      //   children: [
      //     Text(note.firstName),
      //     Text("Gender: ${note.gender}"),
      //     Text("Age: ${note.age}"),
      //   ],
      // ), ],
    ),
    floatingActionButton: FloatingActionButton(
      backgroundColor: Colors.green,
      child: Icon(Icons.add),
      onPressed: () async {
        // await Navigator.of(context).push(
        //   MaterialPageRoute(builder: (context) => AddEditProfile(fn: widget.fn, profId: widget.profId,)),
        // );
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              scrollable: true,
              shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
              insetPadding: EdgeInsets.all(10.0),
              titlePadding: EdgeInsets.all(0.0),
              titleTextStyle: TextStyle(
                  color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
              title: Container(
                width: MediaQuery.of(context).size.width - 40,
                padding: EdgeInsets.only(left: 10, bottom: 20, top: 10),
                child: Text('New hB Entry'),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      topLeft: Radius.circular(15.0)),
                ),
              ),
              content: Container(
                width: MediaQuery.of(context).size.width - 40,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    SizedBox(height: 7),
                    ListTile(
                      leading: Icon(
                        Icons.comment,
                        //color: util.primaryColor,
                      ),
                      title: Obx(() => Text('${theData.hB}',
                          style:TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 40,
                              fontWeight: FontWeight.w700
                          ))),
                    ),
                    SizedBox(
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

                        },
                        child: Text('Start Reading Data', style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                        )),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Color.fromRGBO(93, 157, 254, 1)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                    //color: Colors.green,
                    onPressed: () {
                      setState(() {
                        //Add entry logic
                        addHBinProfile(theData.hB);

                      });

                      // String jd = selectedBookingList.elementAt(index).id;
                      // CustomerCancelReq.CancelRequest(jd, 'merimarzi');
                    },
                    child: Text('Add New hB!')),
                TextButton(
                    //color: util.primaryColor,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Back'))
              ],
            );
          },
        );
      },
    ),
    body: isLoading
        ? Center(child: CircularProgressIndicator())
        : buildNotes(),
  );

  Widget editButton() => IconButton(
      icon: Icon(Icons.edit_outlined),
      onPressed: () async {
        if (isLoading) return;

        // await Navigator.of(context).push(MaterialPageRoute(
        //   builder: (context) => AddEditProfile(hbProfile: note),
        // ));

        refreshNote();
      });

  Widget deleteButton() => IconButton(
    icon: Icon(Icons.delete),
    onPressed: () async {
      //await db_connection.instance.delete(widget.noteId);

      Navigator.of(context).pop();
    },
  );

  Widget buildNotes() => StaggeredGridView.countBuilder(
    padding: EdgeInsets.all(2),
    itemCount: notes.length,
    staggeredTileBuilder: (index) => StaggeredTile.fit(1),
    crossAxisCount: 1,
    mainAxisSpacing: 0,
    crossAxisSpacing: 2,
    itemBuilder: (context, index) {
      final note = notes[index];

      return HbEntryWidget(hbDate: DateFormat.yMMMd().format(note.date), hbValue: note.hBValue);
    },
  );
}
