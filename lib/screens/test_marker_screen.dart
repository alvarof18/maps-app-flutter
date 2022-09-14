import 'package:flutter/material.dart';

import '../markers/markers.dart';

class TestMarkerScreen extends StatelessWidget {
  const TestMarkerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 150,
          width: 350,
          child: CustomPaint(
              painter: EndMarkerPainter(
                  kilometers: 58, destination: 'Epa Circunvalacion 1')),
        ),
      ),
    );
  }
}
