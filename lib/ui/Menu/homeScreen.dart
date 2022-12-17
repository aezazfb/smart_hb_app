import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class homeScreen extends StatelessWidget {
  const homeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
          ],
        ),
      ),
      drawer: Drawer(backgroundColor: Colors.blueGrey,
        child: Wrap(
          children: [
            ListTile(
              title: Text("han bhae"),
              tileColor: Colors.deepOrange,
              selectedTileColor: Colors.orangeAccent,
              leading: Icon(Icons.add_to_queue_rounded),
              onTap: (() {
                //print("kaon");
                Fluttertoast.showToast(msg: "chalado",
                    timeInSecForIosWeb: 3);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Ye rahha snack!")));
              }),
            )
          ],
        ),),
      appBar: AppBar(backgroundColor: Colors.amber,
        title: Row(children: [
          Icon(Icons.settings),
          SizedBox(width: 3,),
          Text("Settings"),
        ],),
        //leading: Icon(Icons.settings_applications),
      ),
    );
  }
}
