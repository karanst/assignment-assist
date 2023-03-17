import 'dart:convert';
import 'dart:io';
import 'package:assignment_assist/Views/onboarding.dart';
import 'package:assignment_assist/Views/refer_earn.dart';
import 'package:assignment_assist/Views/scan_screen.dart';
import 'package:assignment_assist/Views/scrolling_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:assignment_assist/Model/assignment_list_model.dart';
import 'package:assignment_assist/Model/banner_model.dart';
import 'package:assignment_assist/Services/api_path.dart';
import 'package:assignment_assist/Services/tokenString.dart';
import 'package:assignment_assist/Utils/style.dart';

import 'package:assignment_assist/Views/assignment_details.dart';
import 'package:assignment_assist/Views/bottom_bar.dart';
import 'package:assignment_assist/Views/completed_assignments.dart';
import 'package:assignment_assist/Views/faq.dart';
import 'package:assignment_assist/Views/privacypolicy_Screen.dart';
import 'package:assignment_assist/Views/signin_Screen.dart';
import 'package:assignment_assist/Views/termsandcondition_Screen.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Model/get_profile_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _currentIndex = 0 ;
  BannerModel? bannerModal;
  List<Assignments>? assignments = [];
  String? userPic;
  String? userName;
  String? userId;
  bool highlight = false;
  int currentindex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey =  GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();


  Widget _banner(BuildContext context) {
    return bannerModal == null
        ? Center(
        child: Container(
          height: 30,
          width: 30,
          child: CircularProgressIndicator(
            color: primaryColor,
          ),
        ))
        : ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Column(
        children: [
          Container(
            height: 220,
            width: double.infinity,
            child: CarouselSlider(
              options: CarouselOptions(
                viewportFraction: 0.8,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration:
                Duration(milliseconds: 1200),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
                height: 180,
                onPageChanged: (position, reason) {
                  setState(() {
                    currentindex = position;
                  });
                  print(reason);
                  print(CarouselPageChangedReason.controller);
                },
              ),
              items: bannerModal!.data!.map((val) {
                return InkWell(
                  onTap: () {
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          "${val.img}",
                          fit: BoxFit.fill,
                        )),
                  ),
                );
              }).toList(),
            ),
            // margin: EdgeInsetsDirectional.only(top: 10),
            // child: PageView.builder(
            //   itemCount: homeSliderList.length,
            //   scrollDirection: Axis.horizontal,
            //   controller: _controller,
            //   pageSnapping: true,
            //   physics: AlwaysScrollableScrollPhysics(),
            //   onPageChanged: (index) {
            //     context.read<HomeProvider>().setCurSlider(index);
            //   },
            //   itemBuilder: (BuildContext context, int index) {
            //     return pages[index];
            //   },
            // ),
          ),
          Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: bannerModal!.data!.map((e) {
                int index = bannerModal!.data!.indexOf(e);
                return Container(
                    width: 8.0,
                    height: 8.0,
                    margin: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: currentindex == index
                          ? secondaryColor
                          : primaryColor,
                    ));
              }).toList()),
        ],
      ),
    );
  //   Padding(
  //     padding: const EdgeInsets.only(left: 8.0, right: 8, top: 65),
  //     child: ImageSlideshow(
  //       width: double.infinity,
  //       height: 200,
  //       initialPage: 0,
  //       indicatorColor: Colors.black,
  //       indicatorBackgroundColor: Colors.grey,
  //       children: bannerModal!.data!
  //           .map(
  //             (item) {
  //               print("this is image data=====>>${item.img.toString()}");
  //               return  Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 10),
  //           child: ClipRRect(
  //               borderRadius: BorderRadius.circular(20),
  //               child: CachedNetworkImage(
  //                 imageUrl: item.img!,
  //                 fit: BoxFit.fill,
  //                 placeholder: (context, url) => Center(
  //                   child: Container(
  //                     margin: const EdgeInsets.all(70.0),
  //                     child: Center(
  //                         child: Container(
  //                           height: 30,
  //                           width: 30,
  //                           child: CircularProgressIndicator(
  //                             color: secondaryColor,
  //                           ),
  //                         )),
  //                   ),
  //                 ),
  //                 errorWidget: (context, url, error) => Container(
  //                   height: 5,
  //                   width: 5,
  //                   child: Icon(
  //                     Icons.error,
  //                   ),
  //                 ),
  //               )),
  //         );
  // }
  //       )
  //           .toList(),
  //       onPageChanged: (value) {
  //         print('Page changed: $value');
  //       },
  //     ),
  //   );
  }


  openWhatsapp() async {
    // var whatsapp = "${whatsNumber}";
    var whatsapp = "+91$whatsappNo";
    var whatsappURl_android = "whatsapp://send?phone=$whatsapp&text=Hello, I am messaging from Assignment assist App, I am interested for assignment related work, Can we have chat? ";
    var whatappURL_ios = "https://wa.me/$whatsapp?text=${Uri.parse("hello")}";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunch(whatappURL_ios)) {
        await launch(whatappURL_ios, forceSafariVC: false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content:  Text("Whatsapp does not exist in this device")));
      }
    } else {
      // android , web
      if (await canLaunch(whatsappURl_android)) {
        await launch(whatsappURl_android);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text("Whatsapp does not exist in this device")));
      }
    }
  }


  Widget tabBar(){
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: (){
              setState(() {
                _currentIndex = 0 ;
              });
            },
            child: Container(
              width: MediaQuery.of(context).size.width/2 - 20,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: _currentIndex == 0 ? secondaryColor : primaryColor
                ),
                color: _currentIndex == 0 ? secondaryColor : whiteColor
              ),
              child: Center(
                child: Text(
                  "View Documents",
                style: TextStyle(
                  color: _currentIndex == 0 ? whiteColor : primaryColor
                ),),
              ),
            ),
          ),
          InkWell(
            onTap: (){
              setState(() {
                _currentIndex = 1 ;
              });
            },
            child: Container(
              width: MediaQuery.of(context).size.width/2 - 20,
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                      color: _currentIndex == 1 ? secondaryColor : primaryColor
                  ),
                  color: _currentIndex == 1 ? secondaryColor : whiteColor
              ),
              child: Center(
                child: Text(
                  "Upload Documents",
                  style: TextStyle(
                      color: _currentIndex == 1 ? whiteColor : primaryColor
                  ),),
              ),
            ),
          )
        ],
      ),
    );
  }

  _getBanners() async {
    var uri = Uri.parse(ApiPath.getBannersUrl);
    var request =  http.MultipartRequest("GET", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    // request.fields['vendor_id'] = userID;
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);

    if (mounted) {
      setState(() {
        bannerModal = BannerModel.fromJson(userData);
      });
    }

    print(responseData);
  }

  getAssignmentLists()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userid = prefs.getString(TokenString.userid);
    var headers = {
      'Cookie': 'ci_session=21ebc11f1bb101ac0f04e6fa13ac04dc55609d2e'
    };
    var request = http.MultipartRequest('POST', Uri.parse(ApiPath.assignmentListUrl));
    request.fields.addAll({
      'user_id': '$userid',
      'device_token': deviceId.toString()
    });
    print("this sis request ====>>> ${request.fields.toString()}");
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = AssignmentListModel.fromJson(json.decode(finalResponse));
      setState(() {
        assignments = jsonResponse.data!;
      });
      print("this is new assignment data ====>>>>${assignments!.length}");
    }
    else {
      print(response.reasonPhrase);
    }
  }

  getDrawer() {
    // print("checking user pic ${userPic}");
    return Drawer(
      backgroundColor: whiteColor,
      child: ListView(
        padding: EdgeInsets.all(0),
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: primaryColor,
            ), //BoxDecoration
            child: Row(
              children: [
                SizedBox(
                  height: 20,
                ),
                userPic == null || userPic == "" ?
                CircleAvatar(
                    backgroundColor: secondaryColor,
                    radius: 40,
                    child: Icon(
                      Icons.person,
                      size: 44,
                    )
                  //Image.network(userPic.toString()),
                )
                    :
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child:Image.network("$userPic",fit: BoxFit.fill, height: 80, width: 80,),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                       const  Text(
                          "Hello!",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          userName == null || userName == ""?
                          "Guest"
                              :  "${userName.toString()}"
                          ,
                          style: TextStyle(
                              color: whiteColor, fontSize: 17),
                        ),
                        // Row(
                        //   children: [
                        //     Icon(
                        //       Icons.account_balance_wallet_outlined,
                        //       color: Colors.white,
                        //       size: 18,
                        //     ),
                        //
                        //     Text(
                        //       " ₹ 500",
                        //       /*textScaleFactor: 1.3,*/
                        //       style: TextStyle(
                        //           fontWeight: FontWeight.w500,
                        //           color: Colors.white
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 30),
                //   child: Column(
                //     children: [
                //       Text(onOff ? "Online":"Offline", style: TextStyle(fontSize: 15, color: onOff ? Colors.green: Colors.red, fontWeight: FontWeight.w600,),
                //       ),
                //       const SizedBox(
                //         height: 5,
                //       ),
                //       InkWell(
                //         onTap: () async{
                //           setState((){
                //             onOff = !onOff;
                //           });
                //           onOffStatus();
                //
                //
                //           // if(!statusOn){
                //           //   print("okkk");
                //           //   setState(() {
                //           //     // Status = index!;
                //           //   });
                //           //   OnOffModel? model = await onOffStatus();
                //           //   if (model! == false) {
                //           //     final snackBar = SnackBar(
                //           //       content: Text(
                //           //         model.message.toString(),
                //           //         style: TextStyle(
                //           //           color: Colors.white,
                //           //         ),
                //           //       ),
                //           //     );
                //           //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
                //           //   }
                //           // }else{
                //           //   setState((){
                //           //     changeOnTap = false;
                //           //   });
                //           // setSnackbar("Status Update");
                //           // }
                //         },
                //         child: Stack(
                //           children: [
                //             Container(
                //               height: 25,
                //               width: 50,
                //               decoration: BoxDecoration(
                //                   color: Colors.white,
                //                   borderRadius: BorderRadius.circular(40)
                //               ),
                //             ),
                //             onOff ?  Padding(
                //               padding: const EdgeInsets.only(left: 27.0, top: 2),
                //               child: Container(
                //                 width: 20,
                //                 height: 20,
                //                 decoration: BoxDecoration(
                //                     color: Colors.green,
                //                     shape: BoxShape.circle
                //                 ),
                //               ),
                //             )
                //                 : Padding(
                //               padding: const EdgeInsets.only(left: 3.0, top: 3),
                //               child: Container(
                //                 width: 20,
                //                 height: 20,
                //                 decoration: BoxDecoration(
                //                     color: Colors.red,
                //                     shape: BoxShape.circle
                //                 ),
                //
                //               ),
                //             )
                //           ],
                //         ),
                //       ),
                //       // ToggleSwitch(
                //       //   customWidths: [35.0, 35.0],
                //       //   cornerRadius: 20.0,
                //       //   activeBgColors: [[Colors.green], [Colors.red]],
                //       //   activeFgColor: Colors.white,
                //       //   inactiveBgColor: Colors.grey,
                //       //   inactiveFgColor: Colors.white,
                //       //   totalSwitches: 2,
                //       //   // labels: ['YES', ''],
                //       //   // icons: [null, FontAwesomeIcons.times],
                //       //   onToggle: (index) async {
                //       //     if(!statusOn){
                //       //       print("okkk");
                //       //       setState(() {
                //       //         // Status = index!;
                //       //       });
                //       //       OnOffModel? model = await onOffStatus();
                //       //       if (model! == false) {
                //       //         final snackBar = SnackBar(
                //       //           content: Text(
                //       //             model.message.toString(),
                //       //             style: TextStyle(
                //       //               color: Colors.white,
                //       //             ),
                //       //           ),
                //       //         );
                //       //         ScaffoldMessenger.of(context).showSnackBar(snackBar);
                //       //       }
                //       //     }else{
                //       //       setState((){
                //       //         changeOnTap = false;
                //       //       });
                //       //       // setSnackbar("Status Update");
                //       //     }
                //       //     // onOffStatus();
                //       //     print('switched to: $index');
                //       //   },
                //       // ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ), //DrawerHeader
          ListTile(
            // leading: Icon(Icons.home),
            // leading: Image.asset("assets),
            leading:  Icon(Icons.home, size: 25,
            color: secondaryColor,),
            // Image.asset("images/icons/home_fill.png", color: Colors.white, height: 25, width: 25,),
            // leading: const ImageIcon(AssetImage("images/icons/Home.png", )),
            title:  Text('Home', style: TextStyle(color: secondaryColor, fontSize: 16, fontWeight: FontWeight.w500),),
            onTap: () {
              Navigator.push(
                context, MaterialPageRoute(builder: (context) => BottomNav()),
              );
            },
          ),
          ListTile(
            // leading: Icon(Icons.list),
            leading:  Icon(Icons.upload_file_sharp, size: 25,
              color: secondaryColor,),
            // leading: const ImageIcon(AssetImage("images/icons/booking.png")),
            title:  Text('Upload Assignments',style: TextStyle(color: secondaryColor, fontSize: 16, fontWeight: FontWeight.w500)),
            // selected: index == _selectedIndex,
            onTap: () {
              // setState(() {
              //   _selectedIndex = index;
              // });
              Navigator.push(
                context,
                // MaterialPageRoute(builder: (context) => ChatPage( chatId: "1", title: "Karan")),
                MaterialPageRoute(builder: (context)=>BottomNav(index: 1,),
                ),
              );
            },
          ),

          ListTile(
            // leading: Icon(Icons.list),
            leading:  Icon(Icons.upload_file_outlined, size: 25,
              color: secondaryColor,),
            // leading: const ImageIcon(AssetImage("images/icons/booking.png")),
            title: Text('Completed Assignments',style: TextStyle(color: secondaryColor, fontSize: 16, fontWeight: FontWeight.w500)),
            // selected: index == _selectedIndex,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CompletedAssignments()));

            },
          ),

          ListTile(
            // leading: Icon(Icons.home),
            // leading: Image.asset("assets),
            leading:  Icon(Icons.safety_divider_outlined, size: 25,
              color: secondaryColor,),
            // Image.asset("images/icons/home_fill.png", color: Colors.white, height: 25, width: 25,),
            // leading: const ImageIcon(AssetImage("images/icons/Home.png", )),
            title:  Text('Refer and Earn', style: TextStyle(color: secondaryColor, fontSize: 16, fontWeight: FontWeight.w500),),
            onTap: () {
              Navigator.push(
                context, MaterialPageRoute(builder: (context) => const ReferEarnScreen()),
              );
            },
          ),
          ListTile(
            // leading: Icon(Icons.security),
            leading: Icon(Icons.privacy_tip_outlined, color: secondaryColor, size: 25,),
            // leading: const ImageIcon(AssetImage("assets/Icons/Refferal.png")),
            title:  Text('Privacy Policy', style: TextStyle(color: secondaryColor, fontSize: 16, fontWeight: FontWeight.w500)),
            onTap: () {
              Navigator.push(
                context,
                // MaterialPageRoute(builder: (context) => ChatPage( chatId: "1", title: "Karan")),
                MaterialPageRoute(builder: (context)=> PrivacyPolicyScreen()),
              );
            },
          ),
          ListTile(
            // leading: Icon(Icons.report),
            leading: Icon(Icons.people_alt_outlined, color: secondaryColor, size: 25,),
            // leading: const ImageIcon(AssetImage("assets/Icons/Emergancy contect.png")),
            title:  Text('Terms and Conditions', style: TextStyle(color: secondaryColor, fontSize: 16, fontWeight: FontWeight.w500)),
            onTap: () {
              Navigator.push(
                context,
                // MaterialPageRoute(builder: (context) => ChatPage( chatId: "1", title: "Karan")),
                MaterialPageRoute(builder: (context)=> TermsAndConditionScreen()),
              );
            },
          ),
          ListTile(
            // leading: Icon(Icons.support),
            leading: Icon(Icons.support_agent, size: 25, color: secondaryColor,),
            // leading: const ImageIcon(AssetImage("assets/Icons/FAQ.png")),
            title:  Text('FAQs', style: TextStyle(color: secondaryColor,fontSize: 16, fontWeight: FontWeight.w500)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FaqScreen()),
              );
            },
          ),

          ListTile(
            onTap: () async{
              SharedPreferences prefs = await SharedPreferences.getInstance();
              setState(() {
                prefs.setString(TokenString.userid, '');
              });
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => OnboardingScreen()));
            },
            // leading: Icon(Icons.logout_outlined),
            leading: Icon(Icons.logout, size: 25, color: secondaryColor,),
            title: Text('Log Out', style: TextStyle(color: secondaryColor, fontSize: 16, fontWeight: FontWeight.w500)),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(top: 10),
          //   child: Divider(color: Colors.black,),
          // ),
          //
          // Padding(
          //   padding: const EdgeInsets.only(left:20,top:10),
          //   child: Text('Sod @ Service on demand'),
          // ),
         const SizedBox(
            height: 35,
          ),
         const Padding(
            padding:  EdgeInsets.only(left: 15),
            child: Text("Follow Us", style: TextStyle(fontSize: 15, color: Colors.white)),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(top: 25, left: 20),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children: [
          //       Padding(
          //         padding: const EdgeInsets.only(right: 10),
          //         child: Image.asset(
          //           "images/icons/youtube.png",
          //           height: 30,
          //         ),
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.only(right: 10),
          //         child: Image.asset(
          //           "images/icons/facebook.png",
          //           height: 30,
          //         ),
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.only(right: 10),
          //         child: Image.asset(
          //           "images/icons/insta.png",
          //           height: 30,
          //         ),
          //       ),
          //       Image.asset(
          //         "images/icons/twitter.png",
          //         height: 30,
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.only(left: 10),
          //         child: Image.asset(
          //           'images/icons/linkedin.png',
          //           height: 30,
          //         ),
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.only(left: 10),
          //         child: Image.asset(
          //           'images/icons/google.png',
          //           height: 30,
          //         ),
          //       )
          //     ],
          //   ),
          // ),
         const SizedBox(
            height: 40,
          )
        ],
      ),
    );
  }

  getUserDetails ()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
     userId = prefs.getString(TokenString.userid);
     userName = prefs.getString(TokenString.userName);
     userPic = prefs.getString(TokenString.userProfile);
     print("this is current userId ${userId.toString()}");
  }

  Future<Null> _refresh() async {
    // getSeller();
    return callApi();
  }
  callApi(){
    _getBanners();
    getAssignmentLists();
    getProfileData();
    getAdminData();
    getUserDetails();
  }
  String timeZone = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDeviceId();
    Future.delayed(const Duration(milliseconds: 500),(){
      callApi();
    });


   timeZone =  '${DateTime.now().timeZoneName} ${DateTime.now().timeZoneOffset}';
    print("this is timezone offset $timeZone");

  }
  String? deviceId;
  getDeviceId() async{
    deviceId = await PlatformDeviceId.getDeviceId;
  }
  GetProfileModel? seekerProfileModel;
  var adminData;
  String? whatsappNo;

  getAdminData()async{
    var headers = {
      'Cookie': 'ci_session=9ff3faec3b11769c4d8f70378f2b79c31810097e'
    };
    var request = http.MultipartRequest('POST', Uri.parse(ApiPath.allPage));
    request.fields.addAll({
      'type': ''
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResponse  = await response.stream.bytesToString();
      final jsonResponse = json.decode(finalResponse);
      setState(() {
        adminData = jsonResponse['data'];
        whatsappNo = adminData['whatsapp'];
      });
      print("this is whatsapp no. ${whatsappNo}");
    }
    else {
      print(response.reasonPhrase);
    }
  }

  getProfileData()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userid = prefs.getString(TokenString.userid);
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
        userName =  seekerProfileModel!.data![0].name;
        userPic = '${seekerProfileModel!.data![0].image}';
      });
    }
    else {
      print(response.reasonPhrase);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: primaryColor,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: (){
            _scaffoldKey.currentState!.openDrawer();
            // Get.to(SeekerDrawerScreen());
          },
          child: Image.asset('assets/ProfileAssets/menu_icon.png', scale: 1.6,),
        ),
        elevation: 0,
        backgroundColor: primaryColor,
        title:  Container(
          height: 80,
          decoration: BoxDecoration(
            color: primaryColor,
          ),
          child: Image.asset(
            'assets/jobdekho_logo.png',
            scale: 1.5,
          ),
        ),
        centerTitle: true,
        actions: [
          userId == null || userId== ''?
              const SizedBox.shrink()
          :
          IconButton(
              onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=> ScanScreen()));
          }, icon: const Icon(Icons.qr_code_scanner, color: Colors.white,))
              // : const SizedBox.shrink()
        ],
      ),
      bottomSheet: Container(
        height: 40,
        color: Colors.red,
        child: ScrollingText(
          text: "Contact on this whatsApp number $whatsappNo for any query and problems!",
          textStyle: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      floatingActionButton:  Container(
        margin: const EdgeInsets.only(bottom: 30),
        // key: whatsapppBoxKey,
        height: 50.0,
        width: 50.0,
        child: FloatingActionButton(
          backgroundColor: Colors.green.withOpacity(0.7),
          onPressed: () {
            openWhatsapp();
          },
          child: const Icon(Icons.whatsapp_outlined, color: Colors.white, size: 40,)
          //Image.asset("assets/whatsapp.png", height: 35, width: 35,),
        ),
      ),
      drawer:  getDrawer(),
      body: RefreshIndicator(
    color: primaryColor,
    key: _refreshIndicatorKey,
    onRefresh: _refresh,
     child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration:  BoxDecoration(
          color: whiteColor,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(90),
          // topRight: Radius.circular(45)
          )
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 45,),
              _banner(context),
              Padding(
                padding: const EdgeInsets.only(left: 25.0, top: 15, bottom: 15),
                child: Text("My Assignments",style: TextStyle(
                  color: primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w600
                ),),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 55),
                child: ListView.builder(
                  shrinkWrap: true,
                  reverse: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: assignments!.length,
                    itemBuilder: (context, index){
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                    ),
                    elevation: 3,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: secondaryColor,
                          )
                      ),
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Last date of submission :    ",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: secondaryColor
                                ),),
                              Text(assignments![index].endDate.toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                ),),
                            ],
                          ),
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                               Text("Mobile No. :    ",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: secondaryColor
                              ),),
                              Text(assignments![index].mobile.toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                ),),
                            ],
                          ),
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("No. of pages :    ",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: secondaryColor
                                ),),
                              Text(assignments![index].pages.toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                ),),
                            ],
                          ),
                          RichText(
                            text:  TextSpan(
                              text: 'Description : ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: secondaryColor
                            ),
                              children: [
                                 TextSpan(
                                    text: assignments![index].description.toString(),
                                   style: TextStyle(
                                       fontSize: 16,
                                     color: primaryColor,
                                     fontWeight: FontWeight.w400
                                   ),),
                              ],
                            ),
                          ),
                          Center(
                            child: ElevatedButton(
                                onPressed: (){
                                  bool isAccepted = false;
                                  if(assignments![index].status == '1') {
                                    setState(() {
                                      isAccepted = false;
                                    });
                                  }else{
                                      setState(() {
                                        isAccepted = true;
                                      });
                                  }
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> AssignmentDetails(
                                    data : assignments![index],
                                    isAccepted: isAccepted,
                                  )));
                                },
                              style: ElevatedButton.styleFrom(
                                primary: primaryColor
                              ),
                                child: const Text("Show Details",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600
                                ),),
                            ),
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Status : ",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: secondaryColor
                                ),),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color:
                                  assignments![index].status.toString() == '1' ?
                                      Colors.yellow :
                                  assignments![index].status.toString() == '2' ?
                                  Colors.yellow :
                                  assignments![index].status.toString() == '3' ?
                                  primaryColor :
                                  assignments![index].status.toString() == '4' ?
                                  Colors.green :
                                  assignments![index].status.toString() == '5' ?
                                  Colors.red :
                                  assignments![index].status.toString() == '6' ?
                                  Colors.red :
                                      Colors.green
                                ),
                                child: Center(
                                  child: Text(
                                    assignments![index].status.toString() == "1"?
                                    'Pending':
                                    assignments![index].status.toString() == "2"?
                                    'InProgress' :
                                    assignments![index].status.toString() == "3"?
                                    'Quotation shared' :
                                    assignments![index].status.toString() == "4"?
                                    'Accepted' :
                                    assignments![index].status.toString() == "5"?
                                    'Rejected by user':
                                    assignments![index].status.toString() == "6"?
                                    'Rejected by admin'
                                    : 'Completed',
                                    style:  TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: assignments![index].status.toString() == '1' ?
                                      Colors.black :
                                      assignments![index].status.toString() == '2' ?
                                      Colors.black :
                                      assignments![index].status.toString() == '3' ?
                                      Colors.white :
                                      Colors.white
                                    ),),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              )
            ],
          ),
        ),
      )
      )
    );
  }
}
