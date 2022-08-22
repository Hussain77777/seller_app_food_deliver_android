import 'dart:async';

import 'package:flutter/material.dart';
import 'package:seller_app_food_deliver/global/global.dart';
import 'package:seller_app_food_deliver/mainScreens/home_screen.dart';

import '../Authentication/auth_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  startTimer() {

    Timer(const Duration(seconds:1), () async {

      if(firebaseAuth.currentUser!=null){
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (c) => const HomeScreen()));
      }else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (c) => const Auth_screen()));
      }});
  }
void initState(){
    super.initState();
startTimer();
  }
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("images/splash.jpg"),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text(
                "Sell Food Online",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 40,
                    fontFamily: "signatra",
                    letterSpacing: 3),
              ),
            )
          ],
        ),
        color: Colors.white,
      ),
    );
  }
}
