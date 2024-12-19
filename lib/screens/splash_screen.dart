import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zain_mobiles/screens/bottom_navigation_bar.dart';
import 'package:zain_mobiles/view_model/data_base_management.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final provider = Provider.of<DataBaseManagement>(context, listen: false);
    provider.fetchFromServer();
    Future.delayed(
      Duration(seconds: 3),
      () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MyHomePage(),
          ),
        );
      },
    );
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.none,
            image: AssetImage("assets/images/splashScreenx.png"),
          ),
        ),
      ),
    );
  }
}
