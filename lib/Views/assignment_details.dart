import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:assignment_assist/Model/assignment_list_model.dart';
import 'package:assignment_assist/Services/api_path.dart';
import 'package:assignment_assist/Services/tokenString.dart';
import 'package:assignment_assist/Utils/style.dart';
import 'package:assignment_assist/Views/chat_page.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AssignmentDetails extends StatefulWidget {
  Assignments data;
  final bool? isAccepted;
  AssignmentDetails({Key? key, required this.data, this.isAccepted}) : super(key: key);

  @override
  State<AssignmentDetails> createState() => _AssignmentDetailsState();
}

class _AssignmentDetailsState extends State<AssignmentDetails> {
  bool isAccepted = false;
  late Razorpay _razorpay;
  double advancePercent = 50;
  String advanceAmount = '';
  String? pricerazorpayy;


  acceptRejectQuotation(String quotationId, assignmentId, status) async {
    var headers = {
      'Cookie': 'ci_session=9ff3faec3b11769c4d8f70378f2b79c31810097e'
    };
    var request =
        http.MultipartRequest('POST', Uri.parse(ApiPath.accRejQuotation));
    request.fields.addAll({
      'quotation_id': quotationId,
      'assignment_id': assignmentId,
      'status': status // 2 = Accept, 3 = Reject
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = json.decode(finalResponse);
      if (jsonResponse['status'] == true) {
        var snackBar = SnackBar(
          backgroundColor: primaryColor,
          content: Text('${jsonResponse['message'].toString()}'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        setState(() {
          isAccepted = true;
        });
      } else {
        var snackBar = SnackBar(
          backgroundColor: primaryColor,
          content: Text('${jsonResponse['message'].toString()}'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      // setState(() {
      //   TermConditionData = jsonResponse['data']['body'];
      // });
    } else {
      print(response.reasonPhrase);
    }
  }

  downloadFile(String url, String filename) async {

    FileDownloader.downloadFile(
        url: "${url}",
        name: "${filename}",
        onDownloadCompleted: (path) {
          print(path);
          String tempPath = path.toString().replaceAll("Download", "Assignment-assist");
          final File file = File(tempPath);
          print("path here ${file}");
          var snackBar = SnackBar(
            backgroundColor: primaryColor,
            content: Row(
              children: [
                const Text('Assignment Saved in your storage'),
                TextButton(onPressed: (){}, child: Text("View"))

              ],
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          //This will be the path of the downloaded file
        });
  }
  Future<String> createFolderInAppDocDir(String folderNames) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.accessMediaLocation,
      // Permission.manageExternalStorage,
      Permission.storage,
    ].request();
    // var manage = await Permission.manageExternalStorage.status;
    var media = await Permission.accessMediaLocation.status;
    if(media==PermissionStatus.granted){

      print(statuses[Permission.location]);
      //Get this App Document Directory

      // final Directory? _appDocDir = await getTemporaryDirectory();
      // //App Document Directory + folder name
      // final Directory _appDocDirFolder =
      // Directory('${_appDocDir!.path}/$folderName/');
      //
      // if (await _appDocDirFolder.exists()) {
      //   //if folder already exists return path
      //   print("checking directory path ${_appDocDirFolder.path} and ${_appDocDirFolder}");
      //   return _appDocDirFolder.path;
      // } else {
      //   //if folder not exists create folder and then return its path
      //   final Directory _appDocDirNewFolder =
      //   await _appDocDirFolder.create(recursive: true);
      //   print("checking directory path 1111 ${_appDocDirFolder.path} and ${_appDocDirFolder}");
      //   return _appDocDirNewFolder.path;
      // }
      final folderName = folderNames;
      final path= Directory("storage/emulated/0/$folderName");
      final path1 =  await getExternalStorageDirectory();
      print("ssdsds ${path1}");
      print("11111111111 ${path}");
      var status = await Permission.storage.status;
      print("mmmmmmmmmmm ${status} and ${status.isGranted}");
      if (!status.isGranted) {
        print("chacking status ${status.isGranted}");
        await Permission.storage.request();
      }
      print(" path here ${path} and ${await path.exists()}");
      if ((await path.exists())) {
        // final taskId = await FlutterDownloader.enqueue(
        //   url: '${widget.model.user.resume}/report.pdf',
        //   headers: {}, // optional: header send with url (auth token etc)
        //   savedDir: '$path',
        //   showNotification: true, // show download progress in status bar (for Android)
        //   openFileFromNotification: true, // click on notification to open downloaded file (for Android)
        // );
        // print("okokko ${taskId}");
        print("here path is ${path}");
        // var dir = await DownloadsPathProvider.
        print("ooooooooo and $path/$folderNames");
        // await Dio().download(
        //     widget.model.user.resume.toString(),
        //     '$path/$folderNames/',
        //     onReceiveProgress: (received, total) {
        //       print("kkkkkkkk ${received} and $path/$folderNames");
        //       if (total != -1) {
        //        // print((received / total * 100).toStringAsFixed(0) + "%");
        //       }
        //     });
        return path.path;
      } else {
        print("here path is 1 ${path}");
        path.create();
        return path.path;
      }}else{
      print("permission denied");
    }
    return "";
  }


  advancePayment(String quotationId, assignmentId, trnId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString(TokenString.userid);
    var headers = {
      'Cookie': 'ci_session=9ff3faec3b11769c4d8f70378f2b79c31810097e'
    };
    var request =
    http.MultipartRequest('POST', Uri.parse(ApiPath.paymentSuccess));
    request.fields.addAll({
      'amount': advanceAmount,
      'transaction_id':trnId,
      'payment_status':'1',
      'payment_method':'Razorpay',
      'user_id': '$userId',
      'quotation_id': quotationId,
      'assignment_id': assignmentId,
    });
    request.headers.addAll(headers);
    print("this is advance payment success ----${request.fields.toString()}");
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = json.decode(finalResponse);
      if (jsonResponse['status'] == true) {
        var snackBar = SnackBar(
          backgroundColor: primaryColor,
          content: Text(jsonResponse['message'].toString()),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        setState(() {
          isAccepted = true;
        });
        Navigator.pop(context);
      } else {
        var snackBar = SnackBar(
          backgroundColor: primaryColor,
          content: Text('${jsonResponse['message'].toString()}'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      // setState(() {
      //   TermConditionData = jsonResponse['data']['body'];
      // });
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.isAccepted != null){
      setState(() {
        isAccepted = widget.isAccepted!;
      });
    }
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }



  void openCheckout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userMobile = prefs.getString(TokenString.userMobile);
    String? userEmail = prefs.getString(TokenString.userEmail);
    if (widget.data.advanceAmount.toString() != "0.00") {
      setState(() {
        pricerazorpayy = widget.data.totalAmount.toString();
        advanceAmount = widget.data.advanceAmount.toString();
      });
    }

    // if(totalValue == null || totalValue == ""){
    //   pricerazorpayy= cartModel!.getCartList!.total! * 100;
    // }
    // else{
    //   pricerazorpayy= int.parse(totalValue.toString()) * 100;
    // }
    print("checking razorpay price ${advanceAmount.toString()}");
    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag',
      'amount': advanceAmount,
      'name': 'Assignment-assist',
      'description': 'Assignment-assist',
      'prefill': {'contact': '$userMobile', 'email': '$userEmail'},
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    // RazorpayDetailApi();
    // Order_cash_ondelivery();
    advancePayment( widget.data.quotation!.id
        .toString(),
      widget.data.quotation!
          .assignmentId
          .toString(),
    response.paymentId);

    Fluttertoast.showToast(
        msg: "Successful",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
    // Navigator.push(context, MaterialPageRoute(builder: (context)=>DashBoardScreen()));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Fluttertoast.showToast(
    //     msg: "ERROR: " + response.code.toString() + " - " + response.message!,
    //     toastLength: Toast.LENGTH_SHORT);
    Fluttertoast.showToast(
        msg: "Payment cancelled by user",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName!,
        toastLength: Toast.LENGTH_SHORT);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: primaryColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: primaryColor,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: whiteColor,
            ),
          ),
          title: const Text("Assignment Details"),
          centerTitle: true,
          actions: [
            widget.data.quotation != null ?
            IconButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> ChatPage(
                bookingId: widget.data.quotation!.assignmentId.toString(),
              )));
            }, icon: const Icon(Icons.chat))
                : const SizedBox.shrink()
          ],
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(topRight: Radius.circular(90)),
              color: Colors.white),
          width: size.width,
          height: size.height,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Last date of submission : ",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: secondaryColor
                              ),),
                            Text(widget.data.endDate.toString(),
                              style: const TextStyle(
                                fontSize: 16,
                              ),),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Mobile No. : ",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: secondaryColor
                              ),),
                            Text(widget.data.mobile.toString(),
                              style: const TextStyle(
                                fontSize: 16,
                              ),),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("No. of pages : ",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: secondaryColor
                              ),),
                            Text(widget.data.pages.toString(),
                              style: const TextStyle(
                                fontSize: 16,
                              ),),
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
                          widget.data.description.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Quotation",
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                widget.data.quotation != null ?
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: secondaryColor,
                        )),
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Status : ",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: secondaryColor),
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, top: 2, bottom: 2),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: widget.data.quotation!.status
                                              .toString() ==
                                          '1'
                                      ? Colors.yellow
                                      : widget.data.quotation!.status
                                                  .toString() ==
                                              '2'
                                          ? Colors.green
                                          : Colors.red),
                              child: Center(
                                child: Text(
                                  widget.data.quotation!.status.toString() ==
                                          "1"
                                      ? 'InProgress'
                                      : widget.data.quotation!.status
                                                  .toString() ==
                                              "3"
                                          ? 'Rejected'
                                          : 'Accepted',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: widget.data.quotation!.status
                                                  .toString() ==
                                              "1"
                                          ? Colors.black
                                          : Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            // Text(widget.data!.quotation!.status.toString(),
                            //   style: const TextStyle(
                            //     fontSize: 16,
                            //   ),),
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Payment Status : ",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: secondaryColor),
                            ),
                            // Container(
                            //   padding: const EdgeInsets.all(8),
                            //   decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.circular(12),
                            //       color:
                            //       widget.data!.quotation!.paymentStatus.toString() == '0' ?
                            //       Colors.yellow :
                            //       widget.data!.quotation!.paymentStatus.toString() == '1' ?
                            //       Colors.red :
                            //       Colors.green
                            //   ),
                            //   child: Center(
                            //     child: Text(
                            //       widget.data!.quotation!.paymentStatus.toString() == "0"?
                            //       'Unpaid' :
                            //       widget.data!.quotation!.paymentStatus.toString() == "1"?
                            //       '50% Paid'
                            //           : 'Paid',
                            //       style: const TextStyle(
                            //           fontSize: 14,
                            //           fontWeight: FontWeight.w600
                            //       ),),
                            //   ),
                            // ),
                            Text(
                              widget.data.quotation!.paymentStatus
                                          .toString() ==
                                      "0"
                                  ? 'Unpaid'
                                  : widget.data.quotation!.paymentStatus
                                              .toString() ==
                                          "1"
                                      ? '$advancePercent% Paid'
                                      : 'Paid',
                              style: const TextStyle(
                                fontSize: 14,
                                // fontWeight: FontWeight.w600
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Amount : ",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: secondaryColor),
                            ),
                            // Container(
                            //   padding: const EdgeInsets.all(8),
                            //   decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.circular(12),
                            //       color:
                            //       widget.data!.quotation!.paymentStatus.toString() == '0' ?
                            //       Colors.yellow :
                            //       widget.data!.quotation!.paymentStatus.toString() == '1' ?
                            //       Colors.red :
                            //       Colors.green
                            //   ),
                            //   child: Center(
                            //     child: Text(
                            //       widget.data!.quotation!.paymentStatus.toString() == "0"?
                            //       'Unpaid' :
                            //       widget.data!.quotation!.paymentStatus.toString() == "1"?
                            //       '50% Paid'
                            //           : 'Paid',
                            //       style: const TextStyle(
                            //           fontSize: 14,
                            //           fontWeight: FontWeight.w600
                            //       ),),
                            //   ),
                            // ),
                            Text(
                              widget.data.quotation!.amount.toString(),
                              style: const TextStyle(
                                fontSize: 14,
                                // fontWeight: FontWeight.w600
                              ),
                            ),
                          ],
                        ),
                         widget.data.quotation!.status.toString() == "1" && !isAccepted
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Center(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            acceptRejectQuotation(
                                                widget.data!.quotation!.id
                                                    .toString(),
                                                widget.data!.quotation!
                                                    .assignmentId
                                                    .toString(),
                                                '3');
                                          },
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.red),
                                          child: const Text(
                                            "Decline",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            acceptRejectQuotation(
                                                widget.data!.quotation!.id
                                                    .toString(),
                                                widget.data!.quotation!
                                                    .assignmentId
                                                    .toString(),
                                                '2');
                                          },
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.green),
                                          child: const Text(
                                            "Accept",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                      : const SizedBox.shrink(),
                                 widget.data.quotation!.status.toString() == "2" && isAccepted ? Center(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        openCheckout();
                                      },
                                      style: ElevatedButton.styleFrom(
                                          primary: primaryColor),
                                      child: const Text(
                                        "Pay Now",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  )
                            : const SizedBox.shrink()
                        // : const SizedBox.shrink()
                      ],
                    ),
                  ),
                )
                : const Center(
                    child: Text("No quotations found!")),
                widget.data.quotation != null ?
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      createFolderInAppDocDir('Assignment-assist');
                      downloadFile(widget.data.document![0].toString(),'Assignment-assist');
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => PDFScreen(
                      //             path:
                      //                 'https://developmentalphawizz.com/assignment-portal/uploads/assignment/Customizations_forming_part_of_project_proposal2.pdf'
                      //             //widget.data!.document![0].toString(),
                      //             )));
                    },
                    style: ElevatedButton.styleFrom(primary: primaryColor),
                    child: const Text(
                      "Download Assignments",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                )
                : const SizedBox.shrink(),
              ],
            ),
          ),
        ));
  }
}
