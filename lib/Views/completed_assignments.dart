import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:assignment_assist/Model/assignment_list_model.dart';
import 'package:assignment_assist/Services/api_path.dart';
import 'package:assignment_assist/Services/tokenString.dart';
import 'package:assignment_assist/Utils/style.dart';
import 'package:assignment_assist/Views/assignment_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompletedAssignments extends StatefulWidget {
  const CompletedAssignments({Key? key}) : super(key: key);

  @override
  State<CompletedAssignments> createState() => _CompletedAssignmentsState();
}

class _CompletedAssignmentsState extends State<CompletedAssignments> {
  List<Assignments>? assignments = [];
  getAssignmentLists() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userid = prefs.getString(TokenString.userid);
    var headers = {
      'Cookie': 'ci_session=21ebc11f1bb101ac0f04e6fa13ac04dc55609d2e'
    };
    var request =
        http.MultipartRequest('POST', Uri.parse(ApiPath.assignmentListUrl));
    request.fields.addAll({'user_id': '$userid',});
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResponse = await response.stream.bytesToString();
      final jsonResponse =
          AssignmentListModel.fromJson(json.decode(finalResponse));
      setState(() {
        assignments = jsonResponse.data!;
      });
      print("this is new assignment data ====>>>>${assignments!.length}");
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAssignmentLists();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: primaryColor,
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: whiteColor,
            ),
          ),
          backgroundColor: primaryColor,
          title: const Text("Completed Assignments"),
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topRight: Radius.circular(90)),
              color: Colors.white),
          width: size.width,
          height: size.height,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: assignments!.length,
                itemBuilder: (context, index) {
                  print(
                      "this is new data ${assignments![index].description.toString()}");
                  return assignments![index].status.toString() == "7"
                      ? Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          elevation: 3,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: secondaryColor,
                                )),
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Mobile No. : ",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: secondaryColor),
                                    ),
                                    Text(
                                      assignments![index].mobile.toString(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "Description : ",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: secondaryColor),
                                ),
                                Text(
                                  assignments![index].description.toString(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Center(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AssignmentDetails(
                                                      data: assignments![
                                                          index])));
                                    },
                                    style: ElevatedButton.styleFrom(
                                        primary: primaryColor),
                                    child: const Text(
                                      "Show Details",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Status : ",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: secondaryColor),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: assignments![index]
                                                      .status
                                                      .toString() ==
                                                  '1'
                                              ? Colors.yellow
                                              : assignments![index]
                                                          .status
                                                          .toString() ==
                                                      '2'
                                                  ? Colors.yellow
                                                  : assignments![index]
                                                              .status
                                                              .toString() ==
                                                          '3'
                                                      ? primaryColor
                                                      : assignments![index]
                                                                  .status
                                                                  .toString() ==
                                                              '4'
                                                          ? Colors.green
                                                          : assignments![index]
                                                                      .status
                                                                      .toString() ==
                                                                  '5'
                                                              ? Colors.red
                                                              : assignments![index]
                                                                          .status
                                                                          .toString() ==
                                                                      '6'
                                                                  ? Colors.red
                                                                  : Colors
                                                                      .green),
                                      child: Center(
                                        child: Text(
                                          assignments![index]
                                                      .status
                                                      .toString() ==
                                                  "1"
                                              ? 'Pending'
                                              : assignments![index]
                                                          .status
                                                          .toString() ==
                                                      "2"
                                                  ? 'InProgress'
                                                  : assignments![index]
                                                              .status
                                                              .toString() ==
                                                          "3"
                                                      ? 'Quotation shared'
                                                      : assignments![index]
                                                                  .status
                                                                  .toString() ==
                                                              "4"
                                                          ? 'Accepted'
                                                          : assignments![index]
                                                                      .status
                                                                      .toString() ==
                                                                  "5"
                                                              ? 'Rejected by user'
                                                              : assignments![index]
                                                                          .status
                                                                          .toString() ==
                                                                      "6"
                                                                  ? 'Rejected by admin'
                                                                  : 'Completed',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: assignments![index]
                                                          .status
                                                          .toString() ==
                                                      '1'
                                                  ? Colors.black
                                                  : assignments![index]
                                                              .status
                                                              .toString() ==
                                                          '2'
                                                      ? Colors.black
                                                      : assignments![index]
                                                                  .status
                                                                  .toString() ==
                                                              '3'
                                                          ? Colors.white
                                                          : Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(
                          height: MediaQuery.of(context).size.height - 150,
                          child: Center(
                            child: Text(
                              "No completed assignments yet!",
                              style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14),
                            ),
                          ),
                        );
                }),
          ),
        ));
  }
}
