import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:assignment_assist/Model/get_profile_model.dart';
import 'package:assignment_assist/Services/api_path.dart';
import 'package:assignment_assist/Services/tokenString.dart';
import 'package:assignment_assist/Utils/style.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReferEarnScreen extends StatefulWidget {
  const ReferEarnScreen({Key? key}) : super(key: key);

  @override
  State<ReferEarnScreen> createState() => _ReferEarnScreenState();
}

class _ReferEarnScreenState extends State<ReferEarnScreen> {

  String? userid;
  String? referralCode;
  GetProfileModel? seekerProfileModel;

  getProfileData()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString(TokenString.userid);
    var headers = {
      'Cookie': 'ci_session=21ebc11f1bb101ac0f04e6fa13ac04dc55609d2e'
    };
    var request = http.MultipartRequest('POST', Uri.parse('${ApiPath.userProfile}/$userid'));
    request.fields.addAll({
      // 'seeker_email': '$userid'
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = GetProfileModel.fromJson(json.decode(finalResponse));
      setState(() {
        seekerProfileModel = jsonResponse;
        referralCode = seekerProfileModel!.data![0].refferalCode;
        // firstNameController = TextEditingController(text: seekerProfileModel!.data![0].name);
        // emailController = TextEditingController(text: seekerProfileModel!.data![0].email);
        // mobileController = TextEditingController(text: seekerProfileModel!.data![0].mobile);
        // profileImage = '${seekerProfileModel!.data![0].image}';
      });
      print("this is referral code ${referralCode}");
    }
    else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
            backgroundColor: primaryColor,
            appBar: AppBar(
              elevation: 0,
              // centerTitle: true,
              backgroundColor: primaryColor,
              leading: GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back_ios, color: whiteColor, size: 20),
                //Icon(Icons.arrow_back_ios, color: whiteColor, size: 22),
              ),
              // title:  Text('Refer & Earn', style: TextStyle(color: whiteColor, fontSize: 18, fontWeight: FontWeight.bold),),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Image.asset(
                    'assets/refer.png',
                    height: 200.0,
                    width: 300,
                    fit: BoxFit.cover,
                  ),
                ),
                Text("Refer And Earn", style: TextStyle(
                  fontSize: 30
                ),),

              ],
            )
        ));
  }
}
