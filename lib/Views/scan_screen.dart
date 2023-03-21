import 'package:assignment_assist/Services/tokenString.dart';
import 'package:assignment_assist/Utils/style.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  // Barcode? result;
  QRViewController? controller ;
  MobileScannerController cameraController = MobileScannerController();
  @override
  void initState() {
    super.initState();
    _onQRViewCreated;

  }
  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  // @override
  // void reassemble() {
  //   super.reassemble();
  //   if (Platform.isAndroid) {
  //     controller!.pauseCamera();
  //   } else if (Platform.isIOS) {
  //     controller!.resumeCamera();
  //   }
  // }

  loginScannedUser(String url)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userid = prefs.getString(TokenString.userid);
    var headers = {
      'Cookie': 'ci_session=21ebc11f1bb101ac0f04e6fa13ac04dc55609d2e'
    };
    var request = http.MultipartRequest('POST', Uri.parse('$url/$userid'));
    request.fields.addAll({
      // 'seeker_email': '$userid'
    });
    print("this is request url $url/$userid");
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResponse = await response.stream.bytesToString();
      Fluttertoast.showToast(msg: "Successfully logged on web");
      Navigator.pop(context);
      // final jsonResponse = GetProfileModel.fromJson(json.decode(finalResponse));
      // setState(() {
      //   seekerProfileModel = jsonResponse;
      //   userName =  seekerProfileModel!.data![0].name;
      //   userPic = '${seekerProfileModel!.data![0].image}';
      // });
    }
    else {
      print(response.reasonPhrase);
    }
  }

  var result;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
         Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white,),),
        centerTitle: true,
        backgroundColor: primaryColor,
        title: const Text("Scan and Connect", style: TextStyle(color: Colors.white),),
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(height: 40,),
          Container(
            padding: const EdgeInsets.all(6),
            width: 326,
            height: 326,
            decoration: BoxDecoration(
                color: secondaryColor,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10)
            ),
            // child: MobileScanner(
            //     fit: BoxFit.cover,
            //     // allowDuplicates: false,
            //     controller: cameraController,
            //     onDetect: (barcode) {
            //       if (barcode.barcodes == null) {
            //         debugPrint('Failed to scan Barcode');
            //       } else {
            //         // storeSharedPreference();
            //         result = barcode.barcodes;
            //         debugPrint('Barcode found! $result');
            //         if(result !=""|| result != null){
            //           List ans;
            //           ans = result.split('_');
            //           print("checking here ans value ${ans} and ${ans[1]}");
            //           //   bool? oType = pref!.getBool('isTakeAway');
            //           cameraController.dispose();
            //           //  Navigator.of(context).pop();
            //
            //
            //           // checkRestrauntBooking(ans[0].toString(), orderType.toString(), result);
            //
            //           ///  test mode section here
            //
            //           // print("order type here ${oType}");
            //           // if(ans[1] == 0 || ans[1] == "0") {
            //           //   print("aaaaa");
            //           //   checkRestrauntBooking(
            //           //       ans[0].toString(), orderType.toString(), result);
            //           //   //Fluttertoast.showToast(msg: "Its working fine  with ${result}");
            //           // }
            //           // else{
            //           //   Navigator.of(context).pop();
            //           //   Fluttertoast.showToast(msg: "Please select a different qr");
            //           // }
            //           // if(ans[1] != 0 || ans[1] != "0"){
            //           //   print("cccc");
            //           //   checkTableBooking("${ans[0]}","${ans[1]}".toString());
            //           // }
            //           // else{
            //           //   Navigator.of(context).pop();
            //           //   Fluttertoast.showToast(msg: "Please select a different qr");
            //           // }
            //
            //         }
            //       }
            //     }),
           child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          SizedBox(height: 20,),
          Center(
            child: InkWell(
              onTap: () {
                //_onQRViewCreated(controller!);
                // Navigator.push(context, MaterialPageRoute(builder: (context)=> ScanTransaction(
                //   goldRate: livePrice.gold1.toString(),
                //   gold1Rate: livePrice.gold2.toString(),
                // )));
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => BuyDigitalGold(
                //       goldRate: livePrice.gold1.toString(),
                //       gold1Rate : livePrice.gold2.toString()
                //
                //   )),
                // );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: secondaryColor,
                    // gradient: LinearGradient(
                    //   colors: [Color(0xffF1D459), Color(0xffB27E29)],
                    //   begin: Alignment.topCenter,
                    //   end: Alignment.bottomCenter,
                    // ),
                    borderRadius: BorderRadius.circular(30.0)),
                height: 45,
                width: MediaQuery.of(context).size.width-150,
                child: const Center(
                  child: Text(
                    "Scan & Connect",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
            ),
          ),
          // Expanded(
          //   flex: 1,
          //   child: Center(
          //     child: (result != null)
          //         ? Text(
          //         'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
          //         : Text('Scan a code'),
          //   ),
          // )
        ],
      ),
    );
  }

  _onQRViewCreated( QRViewController controller) {

    this.controller = controller;
    controller.resumeCamera();
    controller.scannedDataStream.listen((scanData) {
      print("this is Scanned data $scanData   and ${scanData.code}  and ${scanData.format}");
      setState(() {
        result = scanData;
      });
      print("this is result ${result!.code.toString()}");
      if(result != null){
        String url = result!.code.toString();
        loginScannedUser(url);
        // Navigator.push(context, MaterialPageRoute(builder: (context)=> ScanTransaction(
        //   goldRate: gold1.toString(),
        //   gold1Rate: gold2.toString(),
        // )));
        controller.dispose();
      }

    });

  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}


