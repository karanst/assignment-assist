import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:assignment_assist/Utils/CustomWidgets/customPlanTile.dart';
import 'package:assignment_assist/Utils/CustomWidgets/customTextButton.dart';
import 'package:assignment_assist/Utils/style.dart';

class CustomDialogBox extends StatelessWidget {
  const CustomDialogBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Dialog(
      elevation: 50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
      child: Container(
        width: 340,
        height: 488,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20)
        ),
        child: Column(
          children: [
            Container(
              width: 340,
              height: 70,
              alignment: Alignment.center,
              color: primaryColor,
              child: Text("Select Payment Plan", style: TextStyle(fontSize: 16, color: whiteColor, fontWeight: FontWeight.bold),),
            ),
            Container(
              width: size.width,
              child: Column(
                children: [
                  CustomPlanTile(planName: "Premium", planPrice: "0", description1: "2", description2: "fadfasdfsdf",),
                  CustomPlanTile(planName: "Silver", planPrice: "0", description1: "2", description2: "fadfasdfsdf",),
                  CustomPlanTile(planName: "Mumbai not IT", planPrice: "0", description1: "2", description2: "fadfasdfsdf",),
                ],
              ),
            ),
            CustomTextButton(buttonText: "Close", onTap: (){},)
          ],
        ),
      ),
    );
  }
}
