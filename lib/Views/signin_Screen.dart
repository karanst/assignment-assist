import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:assignment_assist/Services/api_path.dart';
import 'package:assignment_assist/Services/globle.dart';
import 'package:assignment_assist/Utils/CustomWidgets/email_Tab.dart';
import 'package:assignment_assist/Utils/style.dart';
import 'package:assignment_assist/Views/user_profile.dart';
import 'package:assignment_assist/Views/forgotpassword_Screen.dart';
import 'package:assignment_assist/Views/otp_Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Services/tokenString.dart';
import '../Utils/CustomWidgets/TextFields/authTextField.dart';
import '../Utils/CustomWidgets/customTextButton.dart';
import '../Utils/CustomWidgets/mobile_Tab.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'signup_Screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  var _value = 'Email';
  bool isEmail = false;

  var _value1 = 'seeker';
  bool isSeeker = true;
  bool showPassword = false;
  bool isLoading = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  FirebaseMessaging messaging = FirebaseMessaging.instance;



  getNotificationData()async{
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print("sdsdsdsd ${settings.authorizationStatus}");

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }
  String? token;

  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp();

    print("Handling a background message: ${message.messageId}");
  }

  getToken() async {
    var fcmToken = await FirebaseMessaging.instance.getToken();
    setState(() {
      token = fcmToken.toString();
    });
    print("FCM ID=== $token");
  }

  emailPasswordLogin(String type)async{
    SharedPreferences prefs  = await SharedPreferences.getInstance();
    var headers = {
      'Cookie': 'ci_session=ecadd729e7ab27560c282ba3660d365c7e306ca0'
    };
    var request = http.MultipartRequest('POST', Uri.parse('${ApiPath.baseUrl}login'));
    request.fields.addAll({
      'type': '$type',
      'email': emailController.text,
      'ps': passwordController.text,
      'token':token.toString(),
    });
    print("checking fields here ${request.fields}");
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
      });
      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = json.decode(finalResponse);
      print("oooooooo ${jsonResponse}");
      if(jsonResponse['staus'] == 'true'){
        Fluttertoast.showToast(msg: '${jsonResponse['message']}');
        print("ooooooookkkkkkkkkkk ${jsonResponse['data']['id']}");
        String userid = jsonResponse['data']['id'];
        String userEmail = jsonResponse['data']['email'];
        String userType = jsonResponse['type'];
      //  String userName = jsonResponse['data']['name'];
        if(type == 'seeker'){
          String userName = jsonResponse['data']['name']  + " " + " " +  jsonResponse['data']['surname'];
          print("checking user name ${userName}");
          await prefs.setString(TokenString.userName, userName);
        }
        else{
          String userName = jsonResponse['data']['name'];
          await prefs.setString(TokenString.userName, userName);
        }
        String userMobile = jsonResponse['data']['mno'];
        await prefs.setString(TokenString.userMobile, userMobile);
       // await prefs.setString(TokenString.userName, userName);
        await prefs.setString(TokenString.userType, userType);
        await prefs.setString(TokenString.userid, userid);
        await prefs.setString(TokenString.userEmail, userEmail);
        setState(() {
          print("final response here ${jsonResponse}");
          CUR_USERID = jsonResponse['data']['id'];
        });
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> UserProfile()));

      }
      else{
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: "${jsonResponse['message']}");
      }
    }
    else {
      setState(() {
        isLoading = false;
      });
      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = json.decode(finalResponse);
      print(jsonResponse.toString());
    }
  }

  int? otp;
  bool loading = false;
  mobileLogin(String type)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var headers = {
      'Cookie': 'ci_session=0eaf4ebac75de632de1c0763f08419b4a3c1bdec'
    };
    var request = http.MultipartRequest('POST', Uri.parse(ApiPath.loginWithOtp));
    request.fields.addAll({
      'mobile': mobileController.text,
      'token':token.toString(),
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {

      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = json.decode(finalResponse);
      print('final response here ${jsonResponse['otp']} and ');
      if(jsonResponse['status'] == true){
        setState(() {
          loading = false;
        });
        print('final response heresdddddddddd ${jsonResponse['otp']} and ${jsonResponse['data'][0]['id']}');
        String userid = jsonResponse['data'][0]['id'];
        await prefs.setString(TokenString.userid, userid);

        String userEmail = jsonResponse['data'][0]['email'];
        await prefs.setString(TokenString.userEmail, userEmail);

          String userName = jsonResponse['data'][0]['name'];
          await prefs.setString(TokenString.userName, userName);

        String userMobile = jsonResponse['data'][0]['mobile'];
        await prefs.setString(TokenString.userMobile, userMobile);

        // String userProfile = jsonResponse['data'][0]['image'];
        // await prefs.setString(TokenString.userProfile, '${ApiPath.imageUrl}$userProfile');

       // await prefs.setString(TokenString.userName, userName);
       //  await prefs.setString(TokenString.userType, userType);

        Fluttertoast.showToast(msg: "${jsonResponse['message']}");
        setState(() {
          print("final response here ${jsonResponse} $userid");
          otp = jsonResponse['otp'];
          CUR_USERID = jsonResponse['data'][0]['id'];
        });
        Navigator.push(context, MaterialPageRoute(builder: (context) =>
            OTPScreen(code: otp.toString(),mobile: mobileController.text,type: jsonResponse['type'])));
      }
      else{
        setState(() {
          loading = false;
        });
        Fluttertoast.showToast(msg: "${jsonResponse['message']}");
      }
    }
    else {
      print(response.reasonPhrase);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getToken();
    getNotificationData();
  }

  Future<bool> showExitPopup() async {
    return await showDialog( //show confirm dialogue
      //the return value will be from "Yes" or "No" options
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Exit App'),
        content: Text('Do you want to exit an App?'),
        actions:[
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(false),
            //return false when click on "NO"
            child:Text('No'),
          ),

          ElevatedButton(
            onPressed: (){
              exit(0);
              // Navigator.pop(context,true);
              // Navigator.pop(context,true);
            },
            //return true when click on "Yes"
            child:Text('Yes'),
          ),
        ],
      ),
    )??false; //if showDialouge had returned null, then return false
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: showExitPopup,
      child: SafeArea(
          child: Scaffold(
              backgroundColor: primaryColor,
              body: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 170,
                      decoration: BoxDecoration(
                        color: primaryColor,
                      ),
                      child: Image.asset(
                        'assets/jobdekho_logo.png',
                        scale: 1.5,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(14),
                      width: size.width,
                      height: size.height / 1.3,
                      decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: const BorderRadius.only(topRight: Radius.circular(70))),
                      child: ListView(
                       // mainAxisAlignment: MainAxisAlignment.start,
                        shrinkWrap: true,
                        children: [
                         const  Align(
                            alignment:Alignment.center,
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 32),
                            ),
                          ),
                        const  SizedBox(
                            height: 10,
                          ),
                            // Column(
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: [
                            //     Container(
                            //       child: Row(
                            //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            //         crossAxisAlignment: CrossAxisAlignment.start,
                            //         children: [
                            //           Expanded(
                            //             child: Row(
                            //               children: [
                            //                 Radio(
                            //                   fillColor: MaterialStateColor.resolveWith(
                            //                           (states) => primaryColor),
                            //                   activeColor: primaryColor,
                            //                   value: 'seeker',
                            //                   groupValue: _value1,
                            //                   onChanged: (value) {
                            //                     setState(() {
                            //                       _value1 = value.toString();
                            //                       isSeeker = true;
                            //                     });
                            //                   },
                            //                 ),
                            //                 Text(
                            //                   'Job Seeker',
                            //                   style: TextStyle(fontWeight: FontWeight.bold),
                            //                 ),
                            //               ],
                            //             ),
                            //           ),
                            //           Expanded(
                            //             child: Row(
                            //               children: [
                            //                 Radio(
                            //                     activeColor: Colors.red,
                            //                     fillColor: MaterialStateColor.resolveWith(
                            //                             (states) => primaryColor),
                            //                     value: 'recruiter',
                            //                     groupValue: _value1,
                            //                     onChanged: (value) {
                            //                       setState(() {
                            //                         _value1 = value.toString();
                            //                         isSeeker = false;
                            //                       });
                            //                     }),
                            //                 Text(
                            //                   'Recruiter',
                            //                   style: TextStyle(fontWeight: FontWeight.bold),
                            //                 ),
                            //               ],
                            //             ),
                            //           )
                            //         ],
                            //       ),
                            //     ), //
                            //     Container(
                            //       child: Row(
                            //         crossAxisAlignment: CrossAxisAlignment.start,
                            //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            //         children: [
                            //           Expanded(
                            //             child: Row(
                            //               children: [
                            //                 Radio(
                            //                   fillColor: MaterialStateColor.resolveWith(
                            //                           (states) => primaryColor),
                            //                   activeColor: primaryColor,
                            //                   value: 'Email',
                            //                   groupValue: _value,
                            //                   onChanged: (value) {
                            //                     setState(() {
                            //                       _value = value.toString();
                            //                       isEmail = true;
                            //                     });
                            //                   },
                            //                 ),
                            //                 Text(
                            //                   'Email',
                            //                   style: TextStyle(fontWeight: FontWeight.bold),
                            //                 ),
                            //               ],
                            //             ),
                            //           ),
                            //           Expanded(
                            //             child: Row(
                            //               children: [
                            //                 Radio(
                            //                     activeColor: Colors.red,
                            //                     fillColor: MaterialStateColor.resolveWith(
                            //                             (states) => primaryColor),
                            //                     value: 'Mobile',
                            //                     groupValue: _value,
                            //                     onChanged: (value) {
                            //                       setState(() {
                            //                         _value = value.toString();
                            //                         isEmail = false;
                            //                       });
                            //                     }),
                            //                 Text(
                            //                   'Mobile',
                            //                   style: TextStyle(fontWeight: FontWeight.bold),
                            //                 ),
                            //               ],
                            //             ),
                            //           )
                            //         ],
                            //       ),
                            //     ), // Email & Mobile Radio Button
                            //   ],
                            // ),
                          Column(
                              children: [
                      //           isEmail ?
                      //           /// email login section
                      //          // EmailTabs()
                      //     Container(
                      //       child: Column(
                      //       children: [
                      //       SizedBox(height: 20,),
                      //       AuthTextField(
                      //         obsecureText: false,
                      //         controller: emailController,
                      //         iconImage: Image.asset('assets/AuthAssets/Icon material-email.png', scale: 1.3),
                      //         hintText: 'Enter Email',),
                      //       AuthTextField(
                      //           suffixIcons: InkWell(
                      //               onTap: (){
                      //                 setState(() {
                      //                   showPassword = !showPassword;
                      //                 });
                      //               },
                      //               child: Icon(showPassword == true ? Icons.visibility : Icons.visibility_off,color: primaryColor,)),
                      //         obsecureText:showPassword == true ? false : true,
                      //         controller: passwordController,
                      //         iconImage: Image.asset('assets/AuthAssets/Icon ionic-ios-lock.png', scale: 1.3, color: primaryColor,),
                      //         hintText: 'Enter Password',
                      //       ),
                      //       SizedBox(height: 10,),
                      //       GestureDetector(
                      //         onTap: (){
                      //           Get.to(ForgotPasswordScreen());
                      //         },
                      //         child: Padding(
                      //           padding: EdgeInsets.symmetric(horizontal: 20),
                      //           child: Align(
                      //               alignment: Alignment.centerRight,
                      //               child: Text('Forgot Password?', style: TextStyle(color: greyColor1,fontWeight: FontWeight.bold,),)),
                      //         ),
                      //       ),
                      //
                      //       SizedBox(height: 50,),
                      //         GestureDetector(
                      //           onTap: (){
                      //             setState(() {
                      //               isLoading = true;
                      //             });
                      //             if(emailController.text.isEmpty && passwordController.text.isEmpty){
                      //               Fluttertoast.showToast(msg: "All fields are required");
                      //               setState(() {
                      //                 isLoading = false;
                      //               });
                      //             }
                      //             else{
                      //               emailPasswordLogin(_value1);
                      //             }
                      //           },
                      //           child: Container(
                      //             width: MediaQuery.of(context).size.width / 1.1,
                      //             height: 52,
                      //             alignment: Alignment.center,
                      //             //padding: EdgeInsets.all(6),
                      //             decoration: BoxDecoration(
                      //                 color: primaryColor,
                      //                 borderRadius: BorderRadius.circular(10)
                      //             ),
                      //             child: isLoading ?
                      //                 Center(
                      //                   child: Container(
                      //                     width: 30,
                      //                     height: 30,
                      //                     child: CircularProgressIndicator(
                      //                       color: Colors.white,
                      //                     ),
                      //                   ),
                      //                 )
                      //             : Text("Sign In", style: buttonTextStyle,),
                      //
                      //           ),
                      //         )
                      //
                      //       // Container(
                      //       //   child:isLoading
                      //       //     ?CircularProgressIndicator(
                      //       //       strokeWidth: 3, color: Colors.white
                      //       //   )
                      //       //  : CustomTextButton(buttonText: 'Sign In', onTap: (){
                      //       //    setState(() {
                      //       //    isLoading = true;
                      //       //    });
                      //       //    Future.delayed(const Duration(seconds: 3), () {
                      //       //      setState(() {
                      //       //        if(emailController.text.isEmpty && passwordController.text.isEmpty){
                      //       //          Fluttertoast.showToast(msg: "All fields are required");
                      //       //          isLoading = false;
                      //       //        }
                      //       //        else{
                      //       //          emailPasswordLogin(_value1);
                      //       //        }
                      //       //        isLoading = true;
                      //       //      });
                      //       //    });
                      //       //
                      //       //    if(emailController.text.isEmpty && passwordController.text.isEmpty){
                      //       //       Fluttertoast.showToast(msg: "All fields are required");
                      //       //       isLoading=false;
                      //       //     }
                      //       //     else{
                      //       //       emailPasswordLogin(_value1);
                      //       //       isLoading = true;
                      //       //     }
                      //       //     //Navigator.push(context, MaterialPageRoute(builder: (context)=> SeekerDrawerScreen()));
                      //       //   }),
                      //       // ),
                      //   ],
                      // ),
                      //     )
                      //               :
                                /// mobile login section
                               // MobileTabs()
                Container(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(height: 40,),
                    AuthTextField(
                      obsecureText: false,
                      controller: mobileController,
                      length: 10,
                      keyboardtype: TextInputType.number,
                      iconImage: Image.asset('assets/AuthAssets/Icon ionic-ios-call.png', scale: 1.3, color: primaryColor,),
                      hintText: 'Enter Mobile Number',
                    ),
                    SizedBox(height: 70,),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          loading = true;
                        });
                        if(mobileController.text.length != 10){
                          setState(() {
                            loading = false;
                          });
                          var snackBar = SnackBar(
                            backgroundColor: primaryColor,
                            content:  Text('Please enter valid mobile number'),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                        else{

                          mobileLogin(_value1.toString());
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 1.1,
                        height: 52,
                        alignment: Alignment.center,
                        //padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: loading ? Center(
                          child: Container(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(
                              color: whiteColor,
                            ),
                             ),
                        ): Text("Send OTP", style: buttonTextStyle,),

                      ),
                    )
                   //  CustomTextButton(buttonText: 'Send OTP', onTap: (){
                   // if(mobileController.text.length != 10){
                   //   var snackBar = SnackBar(
                   //     backgroundColor: primaryColor,
                   //     content:  Text('Please enter valid mobile number'),
                   //   );
                   //
                   //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
                   // }
                   // else{
                   //   mobileLogin(_value1.toString());
                   // }
                   //  },
                   //  loading: loading,)
                  ],
              ),
                )
                              ]),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account? ",
                                style: TextStyle(
                                    color: greyColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    Get.to(SignUpScreen());
                                  },
                                  child: Text(
                                    "Sign Up",
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold),
                                  ))
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ))),
    );
  }
}
