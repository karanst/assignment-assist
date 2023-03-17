import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:assignment_assist/Utils/CustomWidgets/snack_bar.dart';
import 'package:assignment_assist/Utils/style.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';



String razorPayKey="rzp_test_UUBtmcArqOLqIY";
String razorPaySecret="NTW3MUbXOtcwUrz5a4YCshqk";
class RazorPayHelper{
  String amount;
  String? orderId;
  final BuildContext context;
  ValueChanged onResult;
  Razorpay? _razorpay;
  bool addAmoint = false;

  RazorPayHelper(
      this.amount,
      @required this.context, this.onResult,);
  static const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));


  // init(isOrderProduct,{amount, addAmointTr}){
  //   addAmoint = addAmointTr;
  //   CircularProgressIndicator(color: secondaryColor,);
  //   _razorpay = Razorpay();
  //   _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
  //   _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  //   _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  //   // if(isOrderProduct){
  //   //   openCheckoutOrder(isAmooubnt: amount,addAMoun: addAmointTr);
  //   // }else {
  //   //   openCheckout();
  //   // }
  // }

  initiated({amount}){
    // addAmoint = addAmointTr;
    CircularProgressIndicator(color:secondaryColor,);
    _razorpay = Razorpay();
    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess1);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    // if(isOrderProduct){
    //   openCheckoutOrder(isAmooubnt: amount,addAMoun: addAmointTr);
    // }else {
    //   openCheckout();
    // }
  }



  void getOrder(amount) async {
    String username = razorPayKey;
    String password = razorPaySecret;
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));
    double newmoney = double.parse(amount.toString());

    int nw=newmoney.toInt();
    print("nw---$nw");
    Map data = {
      "amount": nw.toString(),
      "currency": "INR",
      "receipt": "receipt_" + getRandomString(5)
    }; // as per my experience the receipt doesn't play any role in helping you generate a certain pattern in your Order ID!!

    var res = await http.post(Uri.parse('https://api.razorpay.com/v1/orders'),
        headers: <String, String>{'authorization': basicAuth}, body: data);
    print(res.body);
    if (res.statusCode == 200) {
      Map data2 = json.decode(res.body);
      orderId = data2['id'];

    }
    else {
      print(res.body);
      print(res.statusCode);
    }
  }
  //
  // void openCheckout() async {
  //   await App.init();
  //   var options = {
  //     'key': razorPayKey,
  //     'amount': amount,
  //     'name': 'Attica Gold',
  //     "order_id": orderId,
  //     'description': "Order #"+getRandomString(5),
  //     'external': {
  //       'wallets': ['paytm']
  //     },
  //     'prefill': {
  //       'name': name,
  //       'contact': App.localStorage.getString("phone"),
  //     },
  //     "notify": {
  //       "sms": true,
  //       "email": true
  //     },
  //     "reminder_enable": true,
  //   };
  //
  //   try {
  //     _razorpay!.open(options);
  //   } catch (e) {
  //     debugPrint('Error: e');
  //   }
  // }
  //
  // void openCheckoutOrder({isAmooubnt, addAMoun}) async {
  //   // await App.init();
  //   var options = {
  //     'key': razorPayKey,
  //     'amount': isAmooubnt  ,
  //     'name': 'Attica Gold',
  //     "order_id": orderId,
  //     'description': "Order #"+getRandomString(5),
  //     'external': {
  //       'wallets': ['paytm']
  //     },
  //     'prefill': {
  //       'name': name,
  //       'contact': App.localStorage.getString("phone"),
  //     },
  //     "notify": {
  //       "sms": true,
  //       "email": true
  //     },
  //     "reminder_enable": true,
  //   };
  //
  //   try {
  //     _razorpay!.open(options);
  //   } catch (e) {
  //     debugPrint('Error: e');
  //   }
  // }

  // void _handlePaymentSuccess(PaymentSuccessResponse response) async {
  //   // if(isWalletUset != null && isWalletUset!){
  //   //   navigateScreen(context, OrderConfirmed());
  //   // }else{
  //   //   if(!isOrderProduct && gramValue != null && gramValue.toString().length > 1
  //   //       && addAmoint == null ){
  //   if(gramValue != null && gramValue.toString().length > 1
  //   ){
  //     PruchaseModel? a =  await purchaseGold(userid, amount,
  //         gramValue, isGold, context);
  //     if(a != null && a.message != null ){
  //       Fluttertoast.showToast(
  //           backgroundColor: colors.secondary2,
  //           fontSize: 18, textColor: colors.blackTemp,
  //           msg: "Order confirm");
  //       navigateScreen(context, OrderConfirmed());
  //     }
  //   }else{
  //     AddAmountModel? a = await addAmountBalance(
  //         amount: amount,
  //         orderId: response.paymentId,
  //         status: "success",
  //         tranxId: response.paymentId,
  //         userId: App.localStorage.getString("userId"));
  //     if(a != null && a.message != null ){
  //       Fluttertoast.showToast(
  //           backgroundColor: colors.secondary2,
  //           fontSize: 18, textColor: colors.blackTemp,
  //           msg: "Amount added successfully");
  //     }
  //   }
  //
  //   // }
  // }
  // void _handlePaymentSuccess(PaymentSuccessResponse response ) async {
  //   print("this is txnID ---------->>>><<<> ${response.paymentId.toString()} aaaand ${apiAmount.toString()}");
  //   if(isWalletUset != null && isWalletUset!){
  //     // navigateScreen(context, OrderConfirmed());
  //   }else{
  //     if(!isOrderProduct && gramValue != null && gramValue.toString().length > 1 && addAmoint == null ){
  //       PruchaseModel? a =  await purchaseGold(userid, apiAmount,
  //           gramValue, isGold, context);
  //       if(a != null && a.message != null ){
  //         Fluttertoast.showToast(
  //             backgroundColor: Colors.green,
  //             fontSize: 18, textColor: Colors.yellow,
  //             msg: "Order confirm");
  //       }
  //     }else{
  //       AddAmountModel? a = await addAmountBalance(
  //           amount: amount,
  //           orderId: response.paymentId,
  //           status: "success",
  //           tranxId: response.paymentId,
  //           userId: App.localStorage.getString("userId"));
  //       if(a != null && a.message != null ){
  //         Fluttertoast.showToast(
  //             backgroundColor: Colors.green,
  //             fontSize: 18, textColor: Colors.yellow,
  //             msg: "${a.message.toString()}");
  //       }
  //     }
  //
  //   }
  // }

  // void _handlePaymentSuccess(PaymentSuccessResponse response) async {
  //
  //   if (isWalletUset != null && isWalletUset!) {
  //     navigateScreen(context, OrderConfirmed());
  //   } else {
  //
  //     if (!isOrderProduct && gramValue != null && gramValue
  //         .toString()
  //         .length > 1
  //         && addAmoint == null) {
  //       if (gramValue != null && gramValue
  //           .toString()
  //           .length > 1
  //       ) {
  //         PruchaseModel? a = await purchaseGold(userid, amount,
  //             gramValue, isGold, context);
  //         if (a != null && a.message != null) {
  //           Fluttertoast.showToast(
  //               backgroundColor: colors.secondary2,
  //               fontSize: 18, textColor: colors.blackTemp,
  //               msg: "Order confirm");
  //           navigateScreen(context, OrderConfirmed());
  //         }
  //       } else {
  //         AddAmountModel? a = await addAmountBalance(
  //             amount: amount,
  //             orderId: response.paymentId,
  //             status: "success",
  //             tranxId: response.paymentId,
  //             userId: App.localStorage.getString("userId"));
  //         if (a != null && a.message != null) {
  //           Fluttertoast.showToast(
  //               backgroundColor: colors.secondary2,
  //               fontSize: 18, textColor: colors.blackTemp,
  //               msg: "Amount added successfully");
  //         }
  //       }
  //     }
  //   }
  // }

  void _handlePaymentSuccess1(PaymentSuccessResponse response) async {
    // if(isWalletUset != null && isWalletUset!){
    onResult("success");
    // navigateScreen(context, OrderConfirmed());
    // }else{
    //   if(!isOrderProduct && gramValue != null && gramValue.toString().length > 1
    //       && addAmoint == null ){
    // if(gramValue != null && gramValue.toString().length > 1){
    //   PruchaseModel? a =  await purchaseGold(userid, amount,
    //       gramValue, isGold, context);
    //   if(a != null && a.message != null ){
    //     Fluttertoast.showToast(
    //         backgroundColor: colors.secondary2,
    //         fontSize: 18, textColor: colors.blackTemp,
    //         msg: "Order confirm");
    //     navigateScreen(context, OrderConfirmed());
    //   }
    // }else{
    //   AddAmountModel? a = await addAmountBalance(
    //       amount: amount,
    //       orderId: response.paymentId,
    //       status: "success",
    //       tranxId: response.paymentId,
    //       userId: App.localStorage.getString("userId"));
    //   if(a != null && a.message != null ){
    //     Fluttertoast.showToast(
    //         backgroundColor: colors.secondary2,
    //         fontSize: 18, textColor: colors.blackTemp,
    //         msg: "Amount added successfully");
    //   }
    // }
    // }
  }



  void _handlePaymentError(PaymentFailureResponse response) {
    setSnackbar("Payment Cancelled", context);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    onResult(response.walletName);
  }
}