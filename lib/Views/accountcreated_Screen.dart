import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:assignment_assist/Utils/CustomWidgets/customTextButton.dart';
import 'package:assignment_assist/Utils/style.dart';
import 'package:assignment_assist/Views/signin_Screen.dart';

class AccountCreatedScreen extends StatelessWidget {
  const AccountCreatedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset('assets/AuthAssets/accountcreated.png', fit: BoxFit.fitWidth,color: secondaryColor, ),
             const Text('Account Created\n Successfully', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),),
              CustomTextButton(buttonText: "Done", onTap: (){Get.to(SignInScreen());},)
            ],
          ),
    ));
  }
}
