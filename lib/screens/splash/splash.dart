import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: 250,
                  child: Image.asset("assets/images/logo.png")),
            ],
          ),
          SizedBox(height: 4,),
          SpinKitThreeBounce(
            size: 20,
            color: Colors.black,
          )
        ],
      ),
    );
  }
}
