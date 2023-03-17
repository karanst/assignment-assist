import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:assignment_assist/Model/AddJobDataModel.dart';
import 'package:assignment_assist/Model/get_profile_model.dart';
import 'package:assignment_assist/Services/api_path.dart';
import 'package:assignment_assist/Services/tokenString.dart';
import 'package:assignment_assist/Utils/CustomWidgets/TextFields/customTextFormField.dart';
import 'package:assignment_assist/Views/bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Utils/CustomWidgets/customTextButton.dart';
import '../Utils/style.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  var gender;
  var selectedPreferedLocation;
  var specialization;
  var selectedExperience;
  var selectedRole;
  var selectedCurrentRole;
  var selectedDesignation;
  var selectedJobType;
  var selectedQualification;
  var resume;
  var status;
  var profileImage;
  var noticePeriods;

  var yearOfPassing,currentCTC,expected;

  String genders = "";

  GetProfileModel? seekerProfileModel;

  String? resumeData;
  String? userid;

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
        firstNameController = TextEditingController(text: seekerProfileModel!.data![0].name);
        emailController = TextEditingController(text: seekerProfileModel!.data![0].email);
        mobileController = TextEditingController(text: seekerProfileModel!.data![0].mobile);
        profileImage = '${seekerProfileModel!.data![0].image}';
      });
      print("select qualification here ${selectedQualification}");
    }
    else {
      print(response.reasonPhrase);
    }
  }

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController yearOfPassingController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController currentAddressController = TextEditingController();
  TextEditingController keySkillController = TextEditingController();
  TextEditingController percentageController = TextEditingController();
  TextEditingController currentCTCController  = TextEditingController();
  TextEditingController expectedCtcController = TextEditingController();
  TextEditingController noticePeriodController =  TextEditingController();

  intialFunction()async{
    print("working this api here");
    setState(() {
      // selectedPreferedLocation = seekerProfileModel!.data!.location == "0" || seekerProfileModel!.data!.location == null ? null : seekerProfileModel!.data!.location.toString() ;
      // specialization = seekerProfileModel!.data!.specialization == "0" || seekerProfileModel!.data!.specialization == "" || seekerProfileModel!.data!.specialization == null  ? null : seekerProfileModel!.data!.specialization.toString();
      // selectedExperience = seekerProfileModel!.data!.exp == "0" || seekerProfileModel!.data!.exp == null ? null : seekerProfileModel!.data!.exp.toString();
      // selectedRole = seekerProfileModel!.data!.jobRole == "0" || seekerProfileModel!.data!.jobRole == null || seekerProfileModel!.data!.jobRole == "" ? null : seekerProfileModel!.data!.jobRole.toString() ;
      // selectedDesignation = seekerProfileModel!.data!.designation == "0" || seekerProfileModel!.data!.designation == null || seekerProfileModel!.data!.designation == "" ? null :seekerProfileModel!.data!.designation.toString() ;
      // selectedJobType = seekerProfileModel!.data!.jobType == "0" || seekerProfileModel!.data!.jobType == null || seekerProfileModel!.data!.jobType == " " ? null : seekerProfileModel!.data!.jobType.toString() ;
      // selectedQualification = seekerProfileModel!.data!.qua == "0" || seekerProfileModel!.data!.qua == null || seekerProfileModel!.data!.qua == "null" ? null : seekerProfileModel!.data!.qua.toString();
      // gender = seekerProfileModel!.data!.gender == "0" || seekerProfileModel!.data!.gender == null  ?  "" : seekerProfileModel!.data!.gender.toString();
      // // filesPath = seekerProfileModel!.data!.resume == "0" || seekerProfileModel!.data!.resume == null  ? "" : seekerProfileModel!.data!.resume;
      // resumeData =  seekerProfileModel!.data!.resume == "0" || seekerProfileModel!.data!.resume == null  ? "" : seekerProfileModel!.data!.resume;
      // status = seekerProfileModel!.data!.status == "0" || seekerProfileModel!.data!.status == null  ? "" : seekerProfileModel!.data!.status;
      // profileImage = seekerProfileModel!.data!.img == "0" || seekerProfileModel!.data!.img == null ? "" : seekerProfileModel!.data!.img;
    });

    print("resume data here ${resumeData}");
  }

  var filesPath;
  String? fileName;

  void _pickFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    setState(() {
      filesPath = result.files.first.path ?? "";
      fileName = result.files.first.name;
      // reportList.add(result.files.first.path.toString());
      resumeData = null;
    });
    var snackBar = SnackBar(
      backgroundColor: primaryColor,
      content: const Text('Document uploaded successfully'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  AddJobDataModel? addJobDataModel;
  addJobDataFunction()async{
    var headers = {
      'Cookie': 'ci_session=b54ea4dc21bb9562023ebd8c74e28340f129a573'
    };
    var request = http.Request('GET', Uri.parse('${ApiPath.baseUrl}job_post_lists'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = AddJobDataModel.fromJson(json.decode(finalResponse));
      setState(() {
        addJobDataModel = jsonResponse;
      });
      print("final data here ${addJobDataModel!.data!.jobRoles![0].name}");
    }
    else {
      print(response.reasonPhrase);
    }
  }
  bool isGuest = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // if(userid != null || userid != '') {
    //   setState(() {
    //     isGuest = false;
    //   });
    // }
    // else{
    //   setState(() {
    //     isGuest = true;
    //   });
    // }
    Future.delayed(const Duration(milliseconds: 1000), () {
      return getProfileData();
    });
    // Future.delayed(Duration(milliseconds: 100),(){
    //   return addJobDataFunction();
    // });
  }

  final ImagePicker _picker = ImagePicker();
  File? imageFile;

  _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
      Navigator.pop(context);
    }
  }

  _getFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
      Navigator.pop(context);
    }
  }

  updateProfile()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userid = prefs.getString(TokenString.userid);
    var headers = {
      'Cookie': 'ci_session=8d12b1698ae8ebfc1747a8f74b92e35634f3150c'
    };
    var request = http.MultipartRequest('POST', Uri.parse('${ApiPath.updateProfile}/$userid'));
    request.fields.addAll({
      'name': firstNameController.text,
      'email': emailController.text,
      'mobile':mobileController.text
    });

    // filesPath == null ? null : request.files.add(await http.MultipartFile.fromPath('resume', filesPath.toString()));
    imageFile == null ? null : request.files.add(await http.MultipartFile.fromPath('image', imageFile!.path.toString()));
    print("params here ${request.fields} and also ${request.files.toString()}  >>>>> ${imageFile!.path.toString()}");
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var finalResult =  await response.stream.bytesToString();
      final jsonResponse = json.decode(finalResult);
      print("final json response  ${jsonResponse}");
      if(jsonResponse['status'] == 'true' || jsonResponse['status']== true){
        var snackBar = SnackBar(
          backgroundColor: primaryColor,
          content: Text('${jsonResponse['message']}',style: TextStyle(color: Colors.white),),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BottomNav()));
      }
      setState(() {
      });
    }
    else {
      print(response.reasonPhrase);
    }
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
  Widget build(BuildContext context){
    final size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
          backgroundColor: primaryColor,
          appBar: AppBar(
            leading: GestureDetector(
                onTap: (){
                  // Get.to(SeekerDrawerScreen());
                },
                child: Icon(Icons.arrow_back_ios, color: primaryColor,)
            ),
            elevation: 0,
            backgroundColor: primaryColor,
            title: const Text('My Profile'),
            centerTitle: true,
          ),
          // backgroundColor: primaryColor,
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(topRight: Radius.circular(90),),
              color: profileBg,
            ),
            alignment: Alignment.center,
            width: size.width,
            height: size.height / 0.35,
            child: SingleChildScrollView(
              child:
              seekerProfileModel == null  ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: (){
                      // showModalBottomSheet(
                      //     context: context,
                      //     builder: (context){
                      //       return Container(
                      //         height: 250,
                      //         decoration: BoxDecoration(
                      //             borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10))
                      //         ),
                      //         child: Column(
                      //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //           crossAxisAlignment: CrossAxisAlignment.start,
                      //           children: [
                      //             const Text("Assignment Assist: Take Image From", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                      //             ListTile(leading: ImageIcon(const AssetImage('assets/ProfileAssets/cameraicon.png'),
                      //               size: 30,
                      //               color: secondaryColor,),
                      //               // Image.asset('assets/ProfileAssets/cameraicon.png', scale: 1.5,),
                      //               title: const Text('Camera', style: TextStyle(fontWeight: FontWeight.bold)),
                      //               onTap: (){
                      //                 _getFromCamera();
                      //               },
                      //             ),
                      //             ListTile(leading: ImageIcon(const AssetImage('assets/ProfileAssets/galleryicon.png'),
                      //               size: 30,
                      //               color: secondaryColor,),
                      //               title: const Text('Gallery', style: TextStyle(fontWeight: FontWeight.bold)),
                      //               onTap: (){
                      //                 _getFromGallery();
                      //               },
                      //             ),
                      //             ListTile(leading: ImageIcon(const AssetImage('assets/ProfileAssets/cancelicon.png'),
                      //               size: 30,
                      //               color: secondaryColor,),
                      //               title: const Text('Cancel',style: TextStyle(fontWeight: FontWeight.bold)),
                      //               onTap: (){
                      //                 Navigator.pop(context);
                      //               },
                      //             )
                      //           ],
                      //         ),
                      //       );
                      //     });
                    },
                    child: Align(
                      alignment: Alignment.center,
                      child: Stack(
                        children: [
                          // profileImage == null || profileImage == "" || imageFile != null ?
                          Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: whiteColor
                            ),
                            child:imageFile != null ? ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child:Image.file(imageFile!,fit: BoxFit.cover,)) : Image.asset('assets/ProfileAssets/sampleprofile.png'),
                          ) ,
                          //     : Container(
                          //   width: 150,
                          //   height: 150,
                          //   decoration: BoxDecoration(
                          //       shape: BoxShape.circle,
                          //       color: whiteColor
                          //   ),
                          //   child: ClipRRect(
                          //     borderRadius: BorderRadius.circular(100),
                          //     child:Image.network("${profileImage}",fit: BoxFit.fill,),
                          //   ),
                          // ),
                          // Positioned(
                          //   bottom: 20,
                          //   right: 10,
                          //   child: Container(
                          //       width: 30,
                          //       height: 30,
                          //       decoration: const BoxDecoration(
                          //           color: Colors.white,
                          //           shape: BoxShape.circle
                          //       ),
                          //       child: Icon(Icons.camera_alt_outlined, color: secondaryColor,)
                          //   ),),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 10,),
                  Center(child: Text("Hello, Guest User!", style: TextStyle(color: greyColor2,fontSize: 24, fontWeight: FontWeight.bold),)),
                  // CustomTextFormField(label: "Full Name*", labelColor: greyColor2,fieldcontroller: firstNameController,),
                  // CustomTextFormField(label: "Email*", labelColor: greyColor2,fieldcontroller: emailController,),
                  CustomTextFormField(label: "Mobile", labelColor: greyColor2,fieldcontroller: mobileController,keyboardType: TextInputType.number,),

                  const SizedBox(height: 20,),
                  // Align(
                  //   alignment: Alignment.center,
                  //   child: CustomTextButton(buttonText: "Update",
                  //     onTap: (){
                  //       updateProfile();
                  //     },
                  //   ),
                  // ),
                ],
              ) :
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: (){
                      showModalBottomSheet(
                          context: context,
                          builder: (context){
                            return Container(
                              height: 250,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10))
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Assignment Assist: Take Image From", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                                  ListTile(leading: ImageIcon(const AssetImage('assets/ProfileAssets/cameraicon.png'),
                                  size: 30,
                                  color: secondaryColor,),
                                  // Image.asset('assets/ProfileAssets/cameraicon.png', scale: 1.5,),
                                    title: const Text('Camera', style: TextStyle(fontWeight: FontWeight.bold)),
                                    onTap: (){
                                      _getFromCamera();
                                    },
                                  ),
                                  ListTile(leading: ImageIcon(const AssetImage('assets/ProfileAssets/galleryicon.png'),
                                    size: 30,
                                    color: secondaryColor,),
                                    title: const Text('Gallery', style: TextStyle(fontWeight: FontWeight.bold)),
                                    onTap: (){
                                      _getFromGallery();
                                    },
                                  ),
                                  ListTile(leading: ImageIcon(const AssetImage('assets/ProfileAssets/cancelicon.png'),
                                    size: 30,
                                    color: secondaryColor,),
                                    title: const Text('Cancel',style: TextStyle(fontWeight: FontWeight.bold)),
                                    onTap: (){
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              ),
                            );
                          });
                    },
                    child: Align(
                      alignment: Alignment.center,
                      child: Stack(
                        children: [
                          profileImage == null || profileImage == "" || imageFile != null ?  Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: whiteColor
                            ),
                            child:imageFile != null ? ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child:Image.file(imageFile!,fit: BoxFit.cover,)) : Image.asset('assets/ProfileAssets/sampleprofile.png'),
                          ) :
                          Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: whiteColor
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child:Image.network("${profileImage}",fit: BoxFit.fill,),
                            ),
                          ),
                          Positioned(
                            bottom: 20,
                            right: 10,
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle
                              ),
                              child: Icon(Icons.camera_alt_outlined, color: secondaryColor,)
                            ),),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 10,),
                  CustomTextFormField(label: "Full Name*", labelColor: greyColor2,fieldcontroller: firstNameController,),
                  CustomTextFormField(label: "Email*", labelColor: greyColor2,fieldcontroller: emailController,),
                  CustomTextFormField(label: "Mobile*", labelColor: greyColor2,fieldcontroller: mobileController,keyboardType: TextInputType.number,),

                  const SizedBox(height: 20,),
                  Align(
                    alignment: Alignment.center,
                    child: CustomTextButton(buttonText: "Update",
                      onTap: (){
                        updateProfile();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
