import 'package:flutter/material.dart';

class ShimmeringLogo extends StatelessWidget {
  final double defaultSize;
  const ShimmeringLogo({required this.defaultSize});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: defaultSize * 5,
      width: defaultSize * 5,
      child: Image.asset('assets/images/logo1.jpg'),
    );
  }
}
