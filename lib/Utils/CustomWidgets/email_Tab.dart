import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:assignment_assist/Utils/style.dart';
import 'package:assignment_assist/Views/forgotpassword_Screen.dart';
import 'TextFields/authTextField.dart';
import 'customTextButton.dart';

class EmailTabs extends StatelessWidget {
  const EmailTabs({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20,),
        AuthTextField(
          obsecureText: false,
          iconImage: Image.asset('assets/AuthAssets/Icon material-email.png', scale: 1.3),
          hintText: 'Enter Email',),
        AuthTextField(
          obsecureText: true,
          iconImage: Image.asset('assets/AuthAssets/Icon ionic-ios-lock.png', scale: 1.3, color: primaryColor,),
          hintText: 'Enter Password',
        ),
        SizedBox(height: 10,),
        GestureDetector(
          onTap: (){
            Get.to(ForgotPasswordScreen());
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
                alignment: Alignment.centerRight,
                child: Text('Forgot Password?', style: TextStyle(color: greyColor1,fontWeight: FontWeight.bold,),)),
          ),
        ),
        const SizedBox(height: 80,),
        CustomTextButton(buttonText: 'Sign In', onTap: (){
          // Navigator.push(context, MaterialPageRoute(builder: (context)=> SeekerDrawerScreen()));
        }),
      ],
    );
  }
}
