import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_hb_app/Models/hBProfileData.dart';

final _lightColors = [
  Colors.amber.shade300,
  Colors.lightGreen.shade300,
  Colors.lightBlue.shade300,
  Colors.orange.shade300,
  Colors.pinkAccent.shade100,
  Colors.tealAccent.shade100
];

class ProfileCardWidget extends StatelessWidget {
  ProfileCardWidget({
    Key? key,
    required this.hBProfile,
    required this.profileIndex,
  }) : super(key: key);

  final HBData hBProfile;
  final int profileIndex;

  @override
  Widget build(BuildContext context) {
    /// Pick colors from the accent colors based on index
    final color = _lightColors[profileIndex % _lightColors.length];
    final time = DateFormat.yMMMd().format(hBProfile.date);
    final minHeight = getMinHeight(profileIndex);

    return Card(
      color: color,
      child: Container(
        constraints: BoxConstraints(minHeight: minHeight),
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              time,
              style: TextStyle(color: Colors.grey.shade700),
            ),
            SizedBox(height: 4),
            Text(
              hBProfile.firstName,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// To return different height for different widgets
  double getMinHeight(int index) {
    switch (index % 4) {
      case 0:
        return 100;
      case 1:
        return 150;
      case 2:
        return 150;
      case 3:
        return 100;
      default:
        return 100;
    }
  }
}

