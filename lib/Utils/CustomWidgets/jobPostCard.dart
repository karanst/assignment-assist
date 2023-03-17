import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:assignment_assist/Model/AllJobModel.dart';
import 'package:assignment_assist/Services/api_path.dart';
import 'package:assignment_assist/Utils/CustomWidgets/customTile.dart';
import 'package:assignment_assist/Utils/CustomWidgets/jobcardbottomtab.dart';
import 'package:get/get.dart';
import 'package:assignment_assist/Utils/iconUrl.dart';
import 'package:assignment_assist/Views/updatejobpost_Screen.dart';
import 'package:assignment_assist/Views/viewjobpost_Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Services/tokenString.dart';
import '../style.dart';
import 'package:http/http.dart' as http;

class JobPostCard extends StatefulWidget {
  final Data? model;
  JobPostCard({this.model});

  @override
  State<JobPostCard> createState() => _JobPostCardState();
}

class _JobPostCardState extends State<JobPostCard> {
  Future<void> share() async {
    await FlutterShare.share(
        title: 'Example share',
        text: 'Job ID - ${widget.model!.id}\nDesignation - ${widget.model!.designation}\nJob Description - ${widget.model!.description}\n Location - ${widget.model!.location}\n${widget.model!.min} - ${widget.model!.max} Per ${widget.model!.salaryRange}',
        linkUrl: 'https://play.google.com/store/apps/details?id=com.assignmentassist',
        chooserTitle: 'Example Chooser Title'
    );
  }
  AllJobModel? allJobModel;

  getMyJobs()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userid = prefs.getString(TokenString.userid);
    var headers = {
      'Cookie': 'ci_session=056439a05a0899b4ea52dc1ac181a060af22ccd2'
    };
    var request = http.MultipartRequest('POST', Uri.parse('${ApiPath.baseUrl}job_lists'));
    request.fields.addAll({
      'user_id': '$userid'
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = AllJobModel.fromJson(json.decode(finalResponse));
      setState(() {
        allJobModel = jsonResponse;
      });
    }
    else {
      print(response.reasonPhrase);
    }
  }

  openDeleteDialog(){
    return showDialog(context: context, builder: (context){
      return StatefulBuilder(builder: (context,setState){
        return AlertDialog(
          title: Text("Are you sure want to delete job ?",style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),
          content: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: (){
                  deleteApp();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.center,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.green,
                  ),
                  child:  Text("Confirm",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 14),),
                ),
              ),
              SizedBox(width: 10,),
              InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.center,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.red,
                  ),
                  child:  Text("Cancel",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 14),),
                ),
              ),
            ],
          ),
        );
      });
    });
  }

  deleteApp()async{
    var headers = {
      'Cookie': 'ci_session=d5ff45f8db1109c832e6b7e44b3ad13f93bc1b91'
    };
    var request = http.MultipartRequest('POST', Uri.parse('${ApiPath.baseUrl}delete_job_post'));
    request.fields.addAll({
      'id': '${widget.model!.id}'
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResponse =  await response.stream.bytesToString();
      final jsonResponse = json.decode(finalResponse);
      print("jsonResponse here ${jsonResponse}");
      var snackBar = SnackBar(
        content: Text('${jsonResponse['message']}'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      Navigator.pop(context,true);
     // setState(() {
     //   getMyJobs();
     // });
     //  Future.delayed(Duration(milliseconds: 200),(){
     //    return deleteApp();
     //  });
    }
    else {
      print(response.reasonPhrase);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 22),
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(40),
        child: Container(
          padding: EdgeInsets.all(15),
          width: 350,
          // height: 500,
          decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(40)
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
           // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("Job ID - ${widget.model!.id}", style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(height: 5,),
              Text("${widget.model!.designation}", style: TextStyle(color: primaryColor ,fontWeight: FontWeight.bold),),
              SizedBox(height: 5,),
              Text('JOB DESCRIPTION:'),
              SizedBox(height: 5,),
              Text('${widget.model!.description}'),
              SizedBox(height: 5,),
              CustomTile(labelText: '${widget.model!.location}', imageIcon: Image.asset(locationIcon, scale: 1.5,)),
              SizedBox(height: 5,),
              CustomTile(labelText: '${widget.model!.min} - ${widget.model!.max} Per ${widget.model!.salaryRange}', imageIcon: Image.asset(ruppeeIcon, scale: 1.5,)),
              SizedBox(height: 5,),
              CustomTile(labelText: '${widget.model!.experience} years Experience Required', imageIcon: Image.asset(experienceIcon, scale: 1.5,)),
              SizedBox(height: 10,),
              JobCardBottomTile(
                shareOnTap: (){
                  share();
                },
                deleteOnTap: ()async{
                 final result = await openDeleteDialog();
                 print("checking result here ${result}");
                 if(result == true){
                  setState(() {
                    getMyJobs();
                  });
                 }
                },
                editOnTap: (){Get.to(UpdateJobPostScreen(id: widget.model!.id,));},
                viewOnTap: (){Get.to(ViewJobPostScreen(model: widget.model,));},)
            ],
          ),
        ),
      ),
    );
  }
}
