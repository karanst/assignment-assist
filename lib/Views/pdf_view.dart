// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:assignment_assist/Utils/style.dart';
//
// class PDFScreen extends StatefulWidget {
//   final String? path;
//
//   PDFScreen({Key? key, this.path}) : super(key: key);
//
//   _PDFScreenState createState() => _PDFScreenState();
// }
//
// class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {
//   final Completer<PDFViewController> _controller =
//   Completer<PDFViewController>();
//   int? pages = 0;
//   int? currentPage = 0;
//   bool isReady = false;
//   String errorMessage = '';
//   Uri? uri;
//   String? url = 'https://developmentalphawizz.com/assignment-portal/uploads/assignment/Customizations_forming_part_of_project_proposal2.pdf';
//   String? path;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     uri = Uri.parse(url.toString());
//     path = uri.toString();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: primaryColor,
//         title: const Text("Document"),
//         // actions: <Widget>[
//         //   // IconButton(
//         //   //   icon: Icon(Icons.share),
//         //   //   onPressed: () {},
//         //   // ),
//         // ],
//       ),
//       body: Stack(
//         children: <Widget>[
//           PDFView(
//             filePath: path,
//             //'https://developmentalphawizz.com/assignment-portal/uploads/assignment/Customizations_forming_part_of_project_proposal2.pdf',
//             //widget.path,
//             enableSwipe: true,
//             swipeHorizontal: true,
//             autoSpacing: false,
//             pageFling: true,
//             pageSnap: true,
//             defaultPage: currentPage!,
//             fitPolicy: FitPolicy.BOTH,
//             preventLinkNavigation:
//             false, // if set to true the link is handled in flutter
//             onRender: (_pages) {
//               setState(() {
//                 pages = _pages;
//                 isReady = true;
//               });
//             },
//             onError: (error) {
//               setState(() {
//                 errorMessage = error.toString();
//               });
//               print(error.toString());
//             },
//             onPageError: (page, error) {
//               setState(() {
//                 errorMessage = '$page: ${error.toString()}';
//               });
//               print('$page: ${error.toString()}');
//             },
//             onViewCreated: (PDFViewController pdfViewController) {
//               _controller.complete(pdfViewController);
//             },
//             onLinkHandler: (String? uri) {
//               print('goto uri: $uri');
//             },
//             onPageChanged: (int? page, int? total) {
//               print('page change: $page/$total');
//               setState(() {
//                 currentPage = page;
//               });
//             },
//           ),
//           errorMessage.isEmpty
//               ? !isReady
//               ? Center(
//             child: CircularProgressIndicator(),
//           )
//               : Container()
//               : Center(
//             child: Text(errorMessage),
//           )
//         ],
//       ),
//       floatingActionButton: FutureBuilder<PDFViewController>(
//         future: _controller.future,
//         builder: (context, AsyncSnapshot<PDFViewController> snapshot) {
//           if (snapshot.hasData) {
//             return FloatingActionButton.extended(
//               backgroundColor: primaryColor,
//               label: const Text("Go to top"),
//               onPressed: () async {
//                 await snapshot.data!.setPage(pages! ~/ 2);
//               },
//             );
//           }
//
//           return Container();
//         },
//       ),
//     );
//   }
// }