import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:assignment_assist/Services/api_path.dart';

import '../Utils/style.dart';
import 'package:http/http.dart' as http;

class FaqScreen extends StatefulWidget {
  const FaqScreen({Key? key}) : super(key: key);

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {

  var Faq;

  getTermCondition()async{
    var headers = {
      'Cookie': 'ci_session=9ff3faec3b11769c4d8f70378f2b79c31810097e'
    };
    var request = http.MultipartRequest('POST', Uri.parse(ApiPath.faqs));
    // request.fields.addAll({
    //   'type': 'faqs'
    // });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResponse  = await response.stream.bytesToString();
      final jsonResponse = json.decode(finalResponse);
      setState(() {
        Faq = jsonResponse['data'];
      });
    }
    else {
      print(response.reasonPhrase);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 200),(){
      return getTermCondition();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
            backgroundColor: primaryColor,
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              backgroundColor: primaryColor,
              leading: GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back_ios, color: whiteColor, size: 20),
                //Icon(Icons.arrow_back_ios, color: whiteColor, size: 22),
              ),
              title:  Text('FAQ', style: TextStyle(color: whiteColor, fontSize: 18, fontWeight: FontWeight.bold),),
            ),
            body: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(90)),
                  color: Colors.white
              ),
              width: size.width,
              height: size.height,
              child: Faq == null || Faq == "" ?
              Center(
                child: CircularProgressIndicator(
                color: primaryColor,
              ),) :
                 Padding(
                   padding: const EdgeInsets.only(top: 30.0),
                   child: ListView.builder(
                     itemCount: Faq.length,
                       itemBuilder: (context, index){
                     return
                       Card(
                         shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(12)
                         ),
                       child: ExpansionTile(
                         title: Text(Faq[index]['title'], style: const TextStyle(
                         fontWeight: FontWeight.w600,
                         fontSize: 16
                     ),),
                     children: [
                       Text(Faq[index]['description'],style: TextStyle(
                           color: primaryColor
                       ),),
                     ],)
                       );

                       // Card(
                       //   shape: RoundedRectangleBorder(
                       //       borderRadius: BorderRadius.circular(12)
                       //   ),
                     //     child:  Padding(
                     //       padding: const EdgeInsets.all(10.0),
                     //       child: Container(
                     //         width: MediaQuery.of(context).size.width - 30,
                     //         child: Column(
                     //           crossAxisAlignment: CrossAxisAlignment.start,
                     //           children: [
                     //             Text(Faq[index]['title'], style: const TextStyle(
                     //                 fontWeight: FontWeight.w600,
                     //                 fontSize: 16
                     //             ),),
                     //             Text(Faq[index]['description'],style: TextStyle(
                     //                 color: primaryColor
                     //             ),),
                     //           ],
                     //         ),
                     //       ),
                     //     )
                     // );
                   }),
                 )
            )
        ));
  }
}
