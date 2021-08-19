import 'package:flutter/material.dart';
import 'package:skype_clone/utils/universal_variables.dart';

class FloatingColumn extends StatelessWidget {
  final double defaultSize;
  FloatingColumn({required this.defaultSize});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: UniversalVariables.fabGradient,
          ),
          child: Icon(
            Icons.dialpad,
            color: Colors.white,
            size: defaultSize * 2.5,
          ),
          padding: EdgeInsets.all(defaultSize * 1.5),
        ),
        SizedBox(height: defaultSize*1.5,),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black,
            border: Border.all(
              width: defaultSize*.2,
              color: UniversalVariables.gradientColorEnd,
            ),
          ),
          child: Icon(
            Icons.add_call,
            color: UniversalVariables.gradientColorEnd,
            size: defaultSize*2.5,
          ),
          padding: EdgeInsets.all(defaultSize*1.5),
        ),
      ],
    );
  }
}
