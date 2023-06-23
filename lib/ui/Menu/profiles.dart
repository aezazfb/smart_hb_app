import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:smart_hb_app/Models/hBProfileData.dart';
import 'package:smart_hb_app/classes/saveData.dart';
import 'package:smart_hb_app/globalVars.dart';
import 'package:smart_hb_app/ui/addEditProfile.dart';
import 'package:smart_hb_app/ui/dataScreen.dart';
import 'package:smart_hb_app/ui/profile/profile_screen.dart';
import 'package:smart_hb_app/ui/profileCard.dart';
import 'package:smart_hb_app/ui/profileDetailPage.dart';

class HbsPage extends StatefulWidget {
  static String routeName = "/HbsPage";
  @override
  _HbsPageState createState() => _HbsPageState();
}

class _HbsPageState extends State<HbsPage> {
  late List<HBData> notes;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    refreshNotes();
  }

  @override
  void dispose() {
    db_connection.instance.closeDb();

    super.dispose();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);

    this.notes = await db_connection.instance.getAllhBProfiles();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
    onWillPop: () async {
      Navigator.pushReplacementNamed(context, ProfileScreen.routeName);
      return true;
    },
    child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        leading: IconButton(onPressed: (){
          Navigator.pushReplacementNamed(context, ProfileScreen.routeName);
        }, icon: const Icon(Icons.arrow_back_rounded),
          color: Colors.white70,),
        title: const Text(
          'Profiles',
          style: TextStyle(fontSize: 24),
        ),
       // actions: [Icon(Icons.search), SizedBox(width: 12)],
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : notes.isEmpty
            ? const Text(
          'No Profile Stored',
          style: TextStyle(color: Colors.white, fontSize: 24),
        )
            : buildNotes(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: themeBgColour,
        child: const Icon(Icons.add),
        onPressed: () async {
          // await Navigator.of(context).push(
          //   MaterialPageRoute(builder: (context) => dataScreen(thedevice: theGlobalDevice!)),
          // );
          if(theGlobalDevice != null) {
            readingData = false;
            isSaveBtnDisabled = false;
            saveVisibility = true;
            Navigator.pushReplacementNamed(context, dataScreen.routeName);
          }
          else{
            showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('No Device Found!'),
                  content: const Text('Device required to add new profile.'),
                  actions: <Widget>[
                    IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                        })
                  ],
                ));
          }

          refreshNotes();
        },
      ),
    ),
  );

  Widget buildNotes() => StaggeredGridView.countBuilder(
    padding: const EdgeInsets.all(8),
    itemCount: notes.length,
    staggeredTileBuilder: (index) => const StaggeredTile.fit(2),
    crossAxisCount: 4,
    mainAxisSpacing: 4,
    crossAxisSpacing: 4,
    itemBuilder: (context, index) {
      final note = notes[index];

      return GestureDetector(
        onTap: () async {
          await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProfileDetailPage(fn: note.firstName, profId: note.id,),
          ));

          refreshNotes();
        },
        child: ProfileCardWidget(hBProfile: note, profileIndex: index),
      );
    },
  );
}
