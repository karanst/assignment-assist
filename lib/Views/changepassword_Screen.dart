import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:assignment_assist/Services/api_path.dart';
import 'package:assignment_assist/Services/tokenString.dart';
import 'package:assignment_assist/Utils/CustomWidgets/TextFields/passwordTextField.dart';
import 'package:assignment_assist/Utils/CustomWidgets/customTextButton.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/style.dart';
import 'package:http/http.dart' as http;

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {


  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController  = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
bool changePasswordStatus  = false;

bool showOldPassword = false;

  changePassword()async{
    SharedPreferences prefs  = await SharedPreferences.getInstance();
    String? userType = prefs.getString(TokenString.userType);
    String? userMobile = prefs.getString(TokenString.userMobile);
    print("user type here ${userType}");
    var headers = {
      'Cookie': 'ci_session=26cd91f2343081c76d73d176a32b875d72c65b57'
    };
    var request = http.MultipartRequest('POST', Uri.parse('${ApiPath.baseUrl}change_password/${userType}'));
    request.fields.addAll({
      'mobile': userMobile.toString(),
      'password': newPasswordController.text,
      "old_password": oldPasswordController.text,
    });
    print("paramters are here ${request.fields}");
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = json.decode(finalResponse);
      print("final response here ${jsonResponse}");
       var snackBar = SnackBar(
         backgroundColor: primaryColor,
        content: Text('${jsonResponse['message']}'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pop(context);
    }
    else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(child: Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Image.asset('assets/ProfileAssets/menu_icon.png', scale: 1.6,),
        ),
        elevation: 0,
        backgroundColor: primaryColor,
        title: Text('Change Password'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        width: size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topRight: Radius.circular(70))
        ),
        //padding: EdgeInsets.symmetric(vertical: 30),
        child: ListView(
          children: [
            SizedBox(height: 40,),
           // CustomTextFormField(label: "Mobile",hint: "",fieldcontroller: mobileController,length: 10,),
            PasswordTextField(label: 'Old Password', labelColor: greyColor3,fieldController: oldPasswordController,isObscured:showOldPassword == true ? false : true,suffixIcons: InkWell(
                onTap: (){
                  setState(() {
                    showOldPassword = !showOldPassword;
                  });
                },
                child: Icon(changePasswordStatus == true ? Icons.visibility : Icons.visibility_off ))),
            PasswordTextField(label: 'New Password', labelColor: greyColor3,fieldController: newPasswordController,isObscured:changePasswordStatus == true ? false : true,suffixIcons: InkWell(
                onTap: (){
                  setState(() {
                    changePasswordStatus = !changePasswordStatus;
                  });
                },
                child: Icon(changePasswordStatus == true ? Icons.visibility : Icons.visibility_off ))),
            PasswordTextField(label: 'Confirm New Password', labelColor: greyColor3,fieldController: confirmPasswordController,isObscured: changePasswordStatus == true ? false:true,suffixIcons: InkWell(
             onTap: (){
               setState(() {
                 changePasswordStatus = !changePasswordStatus;
               });
             },
              child:  Icon(changePasswordStatus == true ? Icons.visibility : Icons.visibility_off )
            ),),
            SizedBox(height: 40,),
            CustomTextButton(buttonText: "Update", onTap: (){
             if(oldPasswordController.text.isEmpty){
                    var snackBar = SnackBar(
                    backgroundColor: primaryColor,
                    content: Text('Old Password can not be empty'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
              else if(newPasswordController.text !=  confirmPasswordController.text){
                var snackBar = SnackBar(
                  backgroundColor: primaryColor,
                  content: Text('Both password does not match'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
              else if(newPasswordController.text.isEmpty){
                var snackBar = SnackBar(
                  backgroundColor: primaryColor,
                  content: Text('Password is required'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
              else{
                changePassword();
              }
            },)
          ],
        ),
      ),
    ));
  }
}


