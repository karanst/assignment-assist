import 'package:flutter/material.dart';
import 'package:assignment_assist/Utils/CustomWidgets/customTextButton.dart';
import 'package:assignment_assist/Views/otp_Screen.dart';import '../style.dart';
import 'package:get/get.dart';
import 'TextFields/authTextField.dart';

class MobileTabs extends StatelessWidget {
  const MobileTabs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(height: 40,),
        AuthTextField(
          obsecureText: false,
          iconImage: Image.asset('assets/AuthAssets/Icon ionic-ios-call.png', scale: 1.3, color: primaryColor,),
          hintText: 'Enter Mobile Number',
        ),
        SizedBox(height: 70,),
        CustomTextButton(buttonText: 'Send OTP', onTap: (){Get.to(OTPScreen());},)
      ],
    );
  }
}
