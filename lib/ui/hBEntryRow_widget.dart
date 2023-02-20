import 'package:flutter/material.dart';
import 'package:smart_hb_app/ui/size_config.dart';



class HbEntryWidget extends StatefulWidget {
  const HbEntryWidget({
    Key? key, required this.hbDate, required this.hbValue,
  }) : super(key: key);

  final String hbDate;
  final String hbValue;

  @override
  State<HbEntryWidget> createState() => _HbEntryWidgetState();
}

class _HbEntryWidgetState extends State<HbEntryWidget> {
  bool animate = false;

  @override
  void initState() {
    super.initState();
  startAnimation();
  }

  @override
  Widget build(BuildContext context) {
    final val = "${widget.hbValue.trim()} g/dL";
    return Container(
      // height: 90,
      width: double.infinity,
      margin: const EdgeInsets.all((7)),
      padding: const EdgeInsets.fromLTRB(0.0, 27, 0.0, 15),
      decoration: BoxDecoration(
        color: const Color(0xFF4A3298),
        borderRadius: BorderRadius.circular(20),
      ),
      // child: Stack(
      //   children: [
      //     AnimatedPositioned(
      //       top: animate ? 0 : -20,
      //       duration: Duration(milliseconds: 3000),
      //         child: Text("${widget.hbDate}\n")),
      //     Text(
      //       val,
      //       style: const TextStyle(
      //         fontSize: (24),
      //         fontWeight: FontWeight.bold,
      //       ),
      //     ),
      //   ],
      // ),
      child: Center(child:
        Text.rich(
            TextSpan(
              style: const TextStyle(color: Colors.white),
              children: [
                TextSpan(text: "${widget.hbDate}\n"),
                TextSpan(
                  text: val,
                  style: const TextStyle(
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

  Future startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      animate = true;
    });
  }
}
