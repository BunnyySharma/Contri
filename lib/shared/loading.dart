import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF272640),
      body: Container(
        child: Center(
          child: SpinKitWaveSpinner(
            color: Color(0xFF004C4e),
            size: 60,
          ),
        ),
      ),
    );
  }
}
