import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:assignment_assist/Services/api_path.dart';
import 'package:assignment_assist/Services/tokenString.dart';
import 'package:assignment_assist/Utils/CustomWidgets/TextFields/customTextFormField.dart';
import 'package:assignment_assist/Utils/CustomWidgets/customTextButton.dart';
import 'package:assignment_assist/Utils/style.dart';
import 'package:assignment_assist/Views/bottom_bar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ViewDocuments extends StatefulWidget {
  const ViewDocuments({Key? key}) : super(key: key);

  @override
  State<ViewDocuments> createState() => _ViewDocumentsState();
}

class _ViewDocumentsState extends State<ViewDocuments> {

  String? resumeData;
  TextEditingController titleController =TextEditingController();
  TextEditingController descriptionController =TextEditingController();
  TextEditingController submissionDateController =TextEditingController();
  TextEditingController mobileController =TextEditingController();
  TextEditingController noOfPageController =TextEditingController();
  TextEditingController timeController =TextEditingController();
  TextEditingController referralController =TextEditingController();

  int _currentIndex = 0 ;
  String type = '0';

  var filesPath;
  String? fileName;

  TimeOfDay? selectedTime1;
  TimeOfDay? selectedTime2;

  _selectStartTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
        context: context,
        useRootNavigator: true,
        initialTime: TimeOfDay.now(),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
                colorScheme: ColorScheme.light(primary: secondaryColor),
                buttonTheme: ButtonThemeData(
                    colorScheme: ColorScheme.light(primary: secondaryColor))),
            child: MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(alwaysUse24HourFormat: false),
                child: child!),
          );
        });
    if (timeOfDay != null && timeOfDay != selectedTime1) {
      setState(() {
        selectedTime1 = timeOfDay.replacing(hour: timeOfDay.hourOfPeriod);
        timeController.text = selectedTime1!.format(context);
      });
    }
    var per = selectedTime1!.period.toString().split(".");
    print(
        "selected time here ${selectedTime1!.format(context).toString()} and ${per[1]}");
  }

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
      content: const Text('Document uploaded successfully!'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }


  uploadDocument()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userid = prefs.getString(TokenString.userid);
    var headers = {
      'Cookie': 'ci_session=8d12b1698ae8ebfc1747a8f74b92e35634f3150c'
    };
    var request = http.MultipartRequest('POST', Uri.parse(ApiPath.uploadAssignment));
    request.fields.addAll({
      'mobile': mobileController.text.toString(),
      'title': titleController.text.toString(),
      'description': descriptionController.text.toString(),
      'end_date': submissionDateController.text.toString(),
      'time': selectedTime1.toString(),
      'referral_code': referralController.text.toString(),
      // 'pages': noOfPageController.text.toString(),
      'type': type,
      'timezone': timeZone,
      'device_token': deviceId.toString()
    });

    // filesPath == null ? null : request.files.add(await http.MultipartFile.fromPath('resume', filesPath.toString()));
    filesPath == null ? null : request.files.add(await http.MultipartFile.fromPath('assignment[]', filesPath.toString()));

    audioFile == null ? null : request.files.add(await http.MultipartFile.fromPath('assignment[]', audioFile!.path.toString()));
    // print("params here ${request.fields} and also ${request.files.toString()}  >>>>> ${imageFile!.path.toString()}");
    request.headers.addAll(headers);
    print("this is assignment uploading request ------> ${request.files.toString()} aand ${request.fields.toString()}");
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

  Widget tabBar(){
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20, left: 10.0, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: (){
              setState(() {
                _currentIndex = 0 ;
                type = "0";
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
                  "Assignments",
                  style: TextStyle(
                    fontWeight: _currentIndex == 0 ? FontWeight.w600 : FontWeight.normal,
                      color: _currentIndex == 0 ? whiteColor : primaryColor
                  ),),
              ),
            ),
          ),
          InkWell(
            onTap: (){
              setState(() {
                _currentIndex = 1 ;
                type = "1";
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
                  "Quiz/Tests/Exams",
                  style: TextStyle(
                      fontWeight: _currentIndex == 1 ? FontWeight.w600 : FontWeight.normal,
                      color: _currentIndex == 1 ? whiteColor : primaryColor
                  ),),
              ),
            ),
          )
        ],
      ),
    );
  }
  String timeZone = "";
  @override
  void initState() {
    // initRecorder();
    super.initState();
    getDeviceId();
    timeZone =  '${DateTime.now().timeZoneName} ${DateTime.now().timeZoneOffset}';
    print("this is timezone offset $timeZone");
  }
  String? deviceId;
  getDeviceId() async{
  deviceId = await PlatformDeviceId.getDeviceId;
  }

  @override
  void dispose() {
    recorder.closeRecorder();
    super.dispose();
  }

  String _dateValue = '';
  var dateFormate;
  String convertDateTimeDisplay(String date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat('yyyy-MM-dd');
    final DateTime displayDate = displayFormater.parse(date);
    final String formatted = serverFormater.format(displayDate);
    return formatted;
  }
  Future _selectDate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate:  DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2025),
        //firstDate: DateTime.now().subtract(Duration(days: 1)),
        // lastDate: new DateTime(2022),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
                primaryColor: primaryColor,
                accentColor: Colors.black,
                colorScheme:  ColorScheme.light(primary:  primaryColor),
                // ColorScheme.light(primary: const Color(0xFFEB6C67)),
                buttonTheme:
                ButtonThemeData(textTheme: ButtonTextTheme.accent)),
            child: child!,
          );
        });
    if (picked != null) {
      setState(() {
        String yourDate = picked.toString();
        _dateValue = convertDateTimeDisplay(yourDate);
        print(_dateValue);
        dateFormate = DateFormat("dd/MM/yyyy").format(DateTime.parse(_dateValue ?? ""));
        submissionDateController = TextEditingController(text: _dateValue);
      });
    }
  }

  final recorder = FlutterSoundRecorder();

  Future initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw 'Permission not granted';
    }
    await recorder.openRecorder();
    recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  Future startRecord() async {
    await recorder.startRecorder(toFile: "audio");
  }
  File? audioFile;
  Future stopRecorder() async {
    final filePath = await recorder.stopRecorder();
    audioFile = File(filePath!);
    print('Recorded file path: $filePath');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryColor,
        appBar: AppBar(
          leading: GestureDetector(
            onTap: (){
              // Get.to(SeekerDrawerScreen());
            },
            child: Icon(
              Icons.add,
              color: primaryColor,
            )
          ),
          elevation: 0,
          backgroundColor: primaryColor,
          title:  const Text("Upload Documents"),
          centerTitle: true,
        ),
        body:  Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration:  BoxDecoration(
              color: whiteColor,
              // borderRadius: const BorderRadius.only(topLeft: Radius.circular(45),
              //     topRight: Radius.circular(45))
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                tabBar(),
                CustomTextFormField(label: "Title", labelColor: greyColor2,fieldcontroller: titleController),
                CustomTextFormField(label: "Description", labelColor: greyColor2,fieldcontroller: descriptionController),
                CustomTextFormField(label: "Contact Number", labelColor: greyColor2,fieldcontroller: mobileController,
                  length: 10,
                  keyboardType: TextInputType.number,),
                // CustomTextFormField(label: "Total no. of pages", labelColor: greyColor2,fieldcontroller: noOfPageController,
                //   length: 10,
                //   keyboardType: TextInputType.number,),
                // Material(
                //   elevation: 3,
                //   borderRadius: BorderRadius.circular(15),
                //   child: Container(
                //     // height: height,
                //     child: Text(dateFormate != null || dateFormate != "" ?
                //     dateFormate :
                //     ),
                //   ),
                // ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: (){
                            FocusManager.instance.primaryFocus?.unfocus();
                            _selectDate();
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width/2,
                            child: CustomTextFormField(
                              enabled: false,
                                label: "Date & Time", labelColor: greyColor2,fieldcontroller: submissionDateController),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: InkWell(
                            onTap: () {
                              _selectStartTime(context);
                            },
                            child: Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                height: 60,
                                width: MediaQuery.of(context).size.width/2 - 25,
                              child:
                              selectedTime1 != null
                                  ?
                              Row (
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(selectedTime1!.format(context),
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: primaryColor,
                                    ),),
                                  Icon(Icons.access_time,
                                    color: secondaryColor,)
                                ],
                              )
                                  : Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "",
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 15),
                                  ),
                                  Icon(Icons.access_time,
                                    color: secondaryColor,)
                                ],
                              ),
                            )
                            ),
                            // TextFormField( controller: locationController,
                            //   validator: (v){
                            //     if(v!.isEmpty){
                            //       return "Enter time";
                            //     }
                            //   },
                            //   readOnly: true,
                            //   decoration: InputDecoration(
                            //       hintText: "Select time",
                            //       border: OutlineInputBorder(
                            //           borderRadius: BorderRadius.circular(7),
                            //           borderSide: BorderSide(color: appColorBlack.withOpacity(0.5))
                            //       )
                            //   ),),
                          ),
                        ),
                      ],
                    ),

                ///UPLOAD DOCUMENT////////////
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, bottom: 8, top: 8),
                  child: Text("Upload Document", style: TextStyle(color: greyColor2,fontSize: 15, fontWeight: FontWeight.bold),),
                ),
                // const SizedBox(height: 8,),
                InkWell(
                  onTap: (){
                    _pickFile();
                    // FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.any);
                    //
                    // if (result != null) {
                    //  setState(() {
                    //     resume = File(result.files.single.path.toString());
                    //  });
                    // } else {
                    //   // User canceled the picker
                    // }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15),
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)
                      ),
                      child: Container(
                        height: 60,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        // child: resumeData ==  null  || resumeData == "" ? filesPath == null || filesPath == "" ? Text('Upload resume',style: TextStyle(color: greyColor1,fontSize: 14,fontWeight: FontWeight.w500),) :
                        // Text("${resumeData}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 10),)
                        //     : Text("${resumeData}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 10),),
                        child: resumeData == null || resumeData == "" ? filesPath == null ?  Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Upload Assignment"),
                            Icon(Icons.upload_file_outlined, color: primaryColor)
                          ],
                        ) : Text("${filesPath}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 10),)  : Text("${resumeData}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 10),),

                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15,),
                ///UPLOAD DOCUMENT////////////
                CustomTextFormField(label: "Have a referral code", labelColor: greyColor2,fieldcontroller: referralController,),
                ///RECORD AUDIO////////////
                //    Padding(
                //      padding: const EdgeInsets.only(left: 20.0, bottom: 8),
                //      child: Text("Record Audio", style: TextStyle(color: greyColor2,fontSize: 15, fontWeight: FontWeight.bold),),
                //    ),
                // Padding(
                //   padding: const EdgeInsets.only(left: 15.0, right: 15),
                //   child: Card(
                //     elevation: 3,
                //     shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(12)
                //     ),
                //     child: Container(
                //       // height: 60,
                //       padding: const EdgeInsets.symmetric(horizontal: 10),
                //       alignment: Alignment.centerLeft,
                //       decoration: BoxDecoration(
                //           color: Colors.white,
                //           borderRadius: BorderRadius.circular(10)
                //       ),
                //       // child: resumeData ==  null  || resumeData == "" ? filesPath == null || filesPath == "" ? Text('Upload resume',style: TextStyle(color: greyColor1,fontSize: 14,fontWeight: FontWeight.w500),) :
                //       // Text("${resumeData}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 10),)
                //       //     : Text("${resumeData}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 10),),
                //       child: Column(
                //         children: [
                //           Padding(
                //             padding: const EdgeInsets.only(left: 15.0, right: 15),
                //             child: Row(
                //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //               children: [
                //                 StreamBuilder<RecordingDisposition>(
                //                   builder: (context, snapshot) {
                //                     final duration = snapshot.hasData
                //                         ? snapshot.data!.duration
                //                         : Duration.zero;
                //
                //                     String twoDigits(int n) => n.toString().padLeft(2, '0');
                //
                //                     final twoDigitMinutes =
                //                     twoDigits(duration.inMinutes.remainder(60));
                //                     final twoDigitSeconds =
                //                     twoDigits(duration.inSeconds.remainder(60));
                //
                //                     return Text(
                //                       '$twoDigitMinutes:$twoDigitSeconds',
                //                       maxLines: 2,
                //                       style: const TextStyle(
                //                         overflow: TextOverflow.ellipsis,
                //                         color: Colors.black,
                //                         fontSize: 20,
                //                         fontWeight: FontWeight.bold,
                //                       ),
                //                     );
                //                   },
                //                   stream: recorder.onProgress,
                //                 ),
                //                 ElevatedButton(
                //                   style: ElevatedButton.styleFrom(
                //                     primary: recorder.isRecording ? secondaryColor : primaryColor
                //                   ),
                //                   onPressed: () async {
                //                     if (recorder.isRecording) {
                //                       await stopRecorder();
                //                       setState(() {});
                //                     } else {
                //                       await startRecord();
                //                       setState(() {});
                //                     }
                //                   },
                //                   child: Icon(
                //                     recorder.isRecording ? Icons.stop : Icons.mic,
                //                     size: 20,
                //                   ),
                //                 ),
                //               ],
                //             ),
                //           ),
                //           audioFile != null ?
                //           Text(audioFile!.path.toString())
                //           :const SizedBox.shrink(),
                //         ],
                //       )
                //     ),
                //   ),
                // ),
                ///RECORD AUDIO////////////
                // const SizedBox(height: 20),

                const SizedBox(height: 15,),
                Align(
                  alignment: Alignment.center,
                  child: CustomTextButton(buttonText: "Upload Document",
                    onTap: (){
                    if(mobileController.text.isNotEmpty && titleController.text.isNotEmpty && descriptionController.text.isNotEmpty && submissionDateController.text.isNotEmpty) {
                      uploadDocument();
                    }else{
                      Fluttertoast.showToast(msg: "All Fields are required!");
                    }
                    },
                  ),
                ),
                const SizedBox(height: 30,),

              ],
            ),
          ),
        )
    );
  }
}

