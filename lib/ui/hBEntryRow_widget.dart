import 'package:flutter/material.dart';
import 'package:smart_hb_app/ui/size_config.dart';



class HbEntryWidget extends StatelessWidget {
  const HbEntryWidget({
    Key? key, required this.hbDate, required this.hbValue,
  }) : super(key: key);

  final String hbDate;
  final String hbValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 90,
      width: double.infinity,
      margin: EdgeInsets.all((7)),
      padding: EdgeInsets.fromLTRB(0.0, 27, 0.0, 15),
      decoration: BoxDecoration(
        color: Color(0xFF4A3298),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text.rich(
          TextSpan(
            style: TextStyle(color: Colors.white),
            children: [
              TextSpan(text: "${hbDate}\n"),
              TextSpan(
                text: "${hbValue}",
                style: TextStyle(
                  fontSize: (24),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
