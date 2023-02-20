import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_hb_app/Models/hBProfileData.dart';
import 'package:smart_hb_app/classes/saveData.dart';
import 'package:smart_hb_app/functionalities/ble_readData.dart';
import 'package:smart_hb_app/functionalities/toCSV.dart';
import 'package:smart_hb_app/globalVars.dart';
import 'package:smart_hb_app/ui/Addnew/AddnewHb.dart';
import 'package:smart_hb_app/ui/Menu/profiles.dart';
import 'package:smart_hb_app/ui/addEditProfile.dart';
import 'package:smart_hb_app/ui/hBEntryRow_widget.dart';
import 'package:smart_hb_app/ui/profile/profile_screen.dart';

class ProfileDetailPage extends StatefulWidget {
  static String routeName = "/HbsPage";
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

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    refreshNote();
  }

  // final DiscoveredDevice theDevice = theGlobalDevice;
  //final frb = FlutterReactiveBle();
  final theData = Get.put(TheData());

  Future refreshNote() async {
    // setState(() async{
    //   isLoading = true;
    //   note = await db_connection.instance.getHB(widget.fn);
    //   //this.hBbyId = await db_connection.instance.getHBbyId(widget.profId);
    //   notes = await db_connection.instance.getAllhBsById(widget.profId);
    //   isLoading = false;
    // });
    setState(() => isLoading = true);

    note = await db_connection.instance.getHB(widget.fn);
    //this.hBbyId = await db_connection.instance.getHBbyId(widget.profId);
    notes = await db_connection.instance.getAllhBsById(widget.profId);

    setState(() => isLoading = false);

  }

  Future addHBinProfile(RxString hb) async{
    final nt = HBData(
        firstName: note.firstName,
        id: widget.profId, hBValue: hb.toString(),
        age: note.age,
        gender: note.gender,
        date: DateTime.now());
    await db_connection.instance.createHb(nt).then((value) => Fluttertoast.showToast(msg: 'Hb Added!!! ${value.id}',
        timeInSecForIosWeb: 2));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      actions: [deleteButton()],
      leading: IconButton(onPressed: (){
        Navigator.pushReplacementNamed(context, HbsPage.routeName);
      }, icon: const Icon(Icons.arrow_back_rounded)),
      title: Row(
        children: [
          Text(isLoading ? "Name" : note.firstName),
          const SizedBox(
            width: 7,
          ),
          Column(children: [
            Text(isLoading ? "Gender" : "Gender: ${note.gender}"),
            Text(isLoading ? "Age" : "Age: ${note.age}"),
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
      child: const Icon(Icons.add),
      onPressed: () async {
        // await Navigator.of(context).push(
        //   MaterialPageRoute(builder: (context) => AddEditProfile(fn: widget.fn, profId: widget.profId,)),
        // );
        showDialog(
          context: context,
          builder: (BuildContext context) {
            if(theGlobalDevice != null) {
              return AddNewHb(theFirstName: widget.fn, theProfileId: widget.profId, theAge: note.age, theGender: note.gender,);
            }
            else{
              return AlertDialog(
                title: const Text('No device Connected!'),
                content: const Text('SmartHb not connected!'),
                actions: <Widget>[
                  IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      })
                ],
              );
            }
            },
        );
      },
    ),
    body: isLoading
        ? const Center(child: CircularProgressIndicator())
        : buildNotes(),
  );

  Widget editButton() => IconButton(
      icon: const Icon(Icons.edit_outlined),
      onPressed: () async {
        if (isLoading) return;

        // await Navigator.of(context).push(MaterialPageRoute(
        //   builder: (context) => AddEditProfile(hbProfile: note),
        // ));

        refreshNote();
      });

  Widget deleteButton() => IconButton(
    icon: const Icon(Icons.import_export_outlined),
    onPressed: () async {
      //await db_connection.instance.delete(widget.noteId);

      //Navigator.of(context).pop();

      setState(() {
        fileName = note.firstName;
        employeeData  = <List<dynamic>>[];

        for (int i = 0; i <notes.length ;i++) {

//row refer to each column of a row in csv file and rows refer to each row in a file
          List<dynamic> row = [];
          row.add(notes[i].firstName);
          row.add(notes[i].age);
          row.add(notes[i].gender);
          row.add(notes[i].date);
          row.add(notes[i].hBValue);

          //employeeData.clear();
          employeeData.add(row);
        }

        getCsv();

        String msg = "Data Exported Exported Successfully!";

        Fluttertoast.showToast(msg: msg,
            timeInSecForIosWeb: 2);
      });


    },
  );

  Widget buildNotes() =>
      StaggeredGridView.countBuilder(
    padding: const EdgeInsets.all(2),
    itemCount: notes.length,
    staggeredTileBuilder: (index) => const StaggeredTile.fit(1),
    crossAxisCount: 1,
    mainAxisSpacing: 0,
    crossAxisSpacing: 2,
    shrinkWrap: true,
    itemBuilder: (context, index) {
      final note = notes[index];

      return HbEntryWidget(hbDate: DateFormat.yMMMd().format(note.date), hbValue: note.hBValue);
    },
  );
}