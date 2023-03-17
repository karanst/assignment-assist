import 'dart:async';
import 'package:flutter/material.dart';
import 'package:assignment_assist/Views/bottom_bar.dart';
import 'package:assignment_assist/Views/onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Services/tokenString.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  String? uid;
  String? type;
    void checkingLogin() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        uid = prefs.getString(TokenString.userid);
        type = prefs.getString(TokenString.userType);
      });
  }
  
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration(milliseconds: 500),(){
      return checkingLogin();
    });
    Future.delayed(Duration(seconds:2),(){
      print("uid here $uid");
      if(uid == null || uid == ""){
       // return SeekerDrawerScreen();

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OnboardingScreen()));

      }
      else{

          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => BottomNav()));
        //return SignInScreen();
      }
    });
    //Timer(Duration(seconds: 4), () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> SignInScreen()));});
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
        decoration: const BoxDecoration(
          image:DecorationImage(
            image:AssetImage('assets/splash screen.png'),
            fit: BoxFit.fill
            )
          )
        ),
      ),
    );
  }
}
