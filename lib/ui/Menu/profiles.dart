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
  bool isLoading = false;

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
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: themeBgColour,
      leading: IconButton(onPressed: (){
        Navigator.pushReplacementNamed(context, ProfileScreen.routeName);
      }, icon: const Icon(Icons.arrow_back_rounded),
        color: themeBtnColour,),
      title: const Text(
        'hB Profiles',
        style: TextStyle(fontSize: 24),
      ),
     // actions: [Icon(Icons.search), SizedBox(width: 12)],
    ),
    body: Center(
      child: isLoading
          ? CircularProgressIndicator()
          : notes.isEmpty
          ? Text(
        'No Profile Stored',
        style: TextStyle(color: Colors.white, fontSize: 24),
      )
          : buildNotes(),
    ),
    floatingActionButton: FloatingActionButton(
      backgroundColor: themeBgColour,
      child: Icon(Icons.add),
      onPressed: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => dataScreen(thedevice: theGlobalDevice)),
        );

        refreshNotes();
      },
    ),
  );

  Widget buildNotes() => StaggeredGridView.countBuilder(
    padding: EdgeInsets.all(8),
    itemCount: notes.length,
    staggeredTileBuilder: (index) => StaggeredTile.fit(2),
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
