// import 'package:flutter/material.dart';
// import 'package:smart_hb_app/Models/hBProfileData.dart';
// import 'package:smart_hb_app/classes/saveData.dart';
// import 'package:smart_hb_app/ui/profile_form_widget.dart';
//
// class AddEditProfile extends StatefulWidget {
//   //final HBData? hbProfile;
//   final String fn;
//   final int? profId;
//
//   const AddEditProfile({
//     Key? key,
//     //this.hbProfile,
//     required this.fn,
//     this.profId
//   }) : super(key: key);
//   @override
//   _AddEditProfileState createState() => _AddEditProfileState();
// }
//
// class _AddEditProfileState extends State<AddEditProfile> {
//   final _formKey = GlobalKey<FormState>();
//   late bool isImportant;
//   late int number;
//   late String title;
//   late String firstName;
//   late int lastName;
//   late String hBValue;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // isImportant = widget.hbProfile?.isImportant ?? false;
//     lastName = widget.hbProfile?.age ?? 0;
//     firstName = widget.hbProfile?.firstName ?? '';
//     hBValue = widget.hbProfile?.hBValue ?? '';
//   }
//
//   @override
//   Widget build(BuildContext context) => Scaffold(
//     appBar: AppBar(
//       actions: [buildButton()],
//     ),
//     body: Form(
//       key: _formKey,
//       child: ProfileFormWidget(
//         isImportant: true,
//         number: 2,
//         title: firstName,
//         description: hBValue,
//         onChangedImportant: (isImportant) =>
//             setState(() => this.isImportant = isImportant),
//         onChangedNumber: (number) => setState(() => this.number = number),
//         onChangedTitle: (title) => setState(() => this.firstName = title),
//         onChangedDescription: (description) =>
//             setState(() => this.hBValue = description),
//       ),
//     ),
//   );
//
//   Widget buildButton() {
//     final isFormValid = firstName.isNotEmpty && hBValue.isNotEmpty;
//
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           onPrimary: Colors.white,
//           primary: isFormValid ? null : Colors.grey.shade700,
//         ),
//         onPressed: addOrUpdateNote,
//         child: Text('Save'),
//       ),
//     );
//   }
//
//   void addOrUpdateNote() async {
//     final isValid = _formKey.currentState!.validate();
//
//     if (isValid) {
//       final isUpdating = widget.hbProfile != null;
//
//       if (isUpdating) {
//         await updateNote();
//       } else {
//         await addNote();
//       }
//
//       Navigator.of(context).pop();
//     }
//   }
//
//   Future updateNote() async {
//     final note = widget.hbProfile!.copy(
//       // isImportant: isImportant,
//       hBValue: hBValue,
//       firstName: firstName,
//       age: lastName,
//     );
//
//     await db_connection.instance.updateHb(note);
//   }
//
//   Future addNote() async {
//     final note = HBData(
//       firstName: firstName,
//       age: lastName,
//       gender: "male",
//       hBValue: hBValue,
//       // description: description,
//       date: DateTime.now(),
//     );
//
//     await db_connection.instance.create(note);
//   }
// }
