import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:assignment_assist/Utils/style.dart';
import 'package:assignment_assist/Views/user_profile.dart';
import 'package:assignment_assist/Views/home_screen.dart';
import 'package:assignment_assist/Views/upload_documents.dart';

// class BottomBar extends StatefulWidget {
//   final int? index;
//   const BottomBar({Key? key, this.index}) : super(key: key);
//
//   @override
//   State<BottomBar> createState() => _BottomBarState();
// }
//
// class _BottomBarState extends State<BottomBar> {
//   int pageIndex = 0;
//
//   final pages = [
//     const HomeScreen(),
//     const ViewDocuments(),
//     // const Leaderboard(),
//     const UserProfile(),
//   ];
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     if (widget.index != null) {
//       pageIndex = widget.index!;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//         onWillPop: () async {
//           showDialog(
//               context: context,
//               barrierDismissible: false,
//               builder: (BuildContext context) {
//                 return AlertDialog(
//                   title: Text("Confirm Exit"),
//                   content: Text("Are you sure you want to exit?"),
//                   actions: <Widget>[
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(primary: secondaryColor),
//                       child: Text("YES"),
//                       onPressed: () {
//                         SystemNavigator.pop();
//                       },
//                     ),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(primary: secondaryColor),
//                       child: Text("NO"),
//                       onPressed: () {
//                         Navigator.of(context).pop();
//                       },
//                     )
//                   ],
//                 );
//               });
//           return true;
//         },
//         child: Scaffold(
//           // drawer: Drawer(
//           //   // backgroundColor: colors.whit,
//           //   child: Container(
//           //     // width: MediaQuery.of(context).size.width,
//           //     decoration: const BoxDecoration(
//           //         image: DecorationImage(
//           //             fit: BoxFit.fill,
//           //             image: AssetImage('assets/images/drawer_bg.png')
//           //         )
//           //     ),
//           //     // width: MediaQuery.of(context).size.width/2,
//           //     child: Padding(
//           //       padding: const EdgeInsets.only(left: 20, top: 40),
//           //       child: Column(
//           //         children: [
//           //           Row(
//           //             children: [
//           //               CircleAvatar(
//           //                 radius: 40,
//           //                 child: Image.asset("assets/images/user3.png"),
//           //               ),
//           //               const SizedBox(width: 15,),
//           //               Column(
//           //                 crossAxisAlignment: CrossAxisAlignment.start,
//           //                 children: const[
//           //                   Text(
//           //                   //   name != null ?
//           //                   // "$name"
//           //                   //     :
//           //                   "Kevin Rock",
//           //                     style:  TextStyle(
//           //                       fontSize: 18,
//           //                       fontWeight: FontWeight.bold,
//           //                       color: colors.secondary,
//           //                     ),) ,
//           //                    SizedBox(height: 5,),
//           //                    Text("+61987123456",
//           //                     style: TextStyle(
//           //                       fontSize: 14,
//           //                       fontWeight: FontWeight.bold,
//           //                       color: colors.fntClr,
//           //                     ),)
//           //                   // titleText("7896546544", context, 14)
//           //
//           //                 ],
//           //               )
//           //
//           //             ],
//           //           ),
//           //           const SizedBox(height: 30,),
//           //           drawerItem('assets/icons/drawer1.png', "Availability", (){
//           //             Navigator.push(context, MaterialPageRoute(builder: (context)=> Availability()));
//           //           }),
//           //           drawerItem('assets/icons/drawer2.png', "Invoice", (){
//           //             Navigator.push(context, MaterialPageRoute(builder: (context)=> InvoiceHistory()));
//           //           }),
//           //           drawerItem('assets/icons/drawer4.png', "Outlook", (){
//           //           }),
//           //           drawerItem('assets/icons/drawer3.png', "Sharepoint", (){}),
//           //           drawerItem('assets/icons/drawer5.png', "Skool", (){}),
//           //           drawerItem('assets/icons/drawer6.png', "FAQ", (){
//           //             Navigator.push(context, MaterialPageRoute(builder: (context)=> FaqScreen()));
//           //           }),
//           //           drawerItem('assets/icons/drawer7.png', "Privacy Policy", (){
//           //             Navigator.push(context, MaterialPageRoute(builder: (context)=> PrivacyPolicy()));
//           //           }),
//           //           drawerItem('assets/icons/drawer8.png', "Terms & Conditions", (){
//           //             Navigator.push(context, MaterialPageRoute(builder: (context)=> TermCondition()));
//           //           }),
//           //           // const SizedBox(height: 30,),
//           //           drawerItem('assets/icons/drawer9.png', "Logout", (){
//           //             Navigator.push(context, MaterialPageRoute(builder: (context)=> Login()));
//           //           }),
//           //
//           //         ],
//           //       ),
//           //     ),
//           //   ),
//           // ),
//           // backgroundColor: const Color(0xffC4DFCB),
//           body: pages[pageIndex],
//           bottomNavigationBar: buildMyNavBar(context),
//         ));
//   }
//
//   bottomBarElement(String title, int index, IconData icon) {
//     return InkWell(
//       onTap: () {
//         setState(() {
//           pageIndex = index;
//         });
//       },
//       child: Container(
//         padding: EdgeInsets.only(left: 10, right: 10),
//         // width: 80,
//         height: 40,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           color: pageIndex == index ? secondaryColor : whiteColor,
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               icon,
//               color: pageIndex == index ? whiteColor : primaryColor,
//             ),
//             // ImageIcon(
//             //   AssetImage(image),
//             //   color: pageIndex == index ? whiteColor : primaryColor,
//             // ),
//             const SizedBox(
//               width: 3,
//             ),
//             // Image.asset(image),
//             pageIndex == index
//                 ? Text(
//                     title,
//                     style: TextStyle(
//                       color: pageIndex == index ? whiteColor : primaryColor,
//                     ),
//                   )
//                 : const SizedBox.shrink()
//           ],
//         ),
//       ),
//     );
//   }
//
//   Container buildMyNavBar(BuildContext context) {
//     return Container(
//       height: 60,
//       decoration: BoxDecoration(
//         boxShadow: <BoxShadow>[
//           BoxShadow(
//               color: Colors.grey, blurRadius: 8.0, offset: Offset(0.75, 0.00))
//         ],
//         color: primaryColor,
//         // borderRadius: const BorderRadius.only(
//         //   topLeft: Radius.circular(20),
//         //   topRight: Radius.circular(20),
//         // ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           bottomBarElement("Home", 0, Icons.home_filled),
//           bottomBarElement("View Documents", 1, Icons.document_scanner),
//           // bottomBarElement("Leaderboard", "assets/icons/dashboard3.png", 2),
//           bottomBarElement("Profile", 2, Icons.person),
//           // IconButton(
//           //   enableFeedback: false,
//           //   onPressed: () {
//           //     setState(() {
//           //       pageIndex = 0;
//           //     });
//           //   },
//           //   icon: pageIndex == 0
//           //       ? const Icon(
//           //     Icons.home_filled,
//           //     // color: Colors.white,
//           //     size: 35,
//           //   )
//           //       : const Icon(
//           //     Icons.home_outlined,
//           //     // color: Colors.white,
//           //     size: 35,
//           //   ),
//           // ),
//           // IconButton(
//           //   enableFeedback: false,
//           //   onPressed: () {
//           //     setState(() {
//           //       pageIndex = 1;
//           //     });
//           //   },
//           //   icon: pageIndex == 1
//           //       ? const Icon(
//           //     Icons.work_rounded,
//           //     // color: Colors.white,
//           //     size: 35,
//           //   )
//           //       : const Icon(
//           //     Icons.work_outline_outlined,
//           //     // color: Colors.white,
//           //     size: 35,
//           //   ),
//           // ),
//           // IconButton(
//           //   enableFeedback: false,
//           //   onPressed: () {
//           //     setState(() {
//           //       pageIndex = 2;
//           //     });
//           //   },
//           //   icon: pageIndex == 2
//           //       ? const Icon(
//           //     Icons.widgets_rounded,
//           //     // color: Colors.white,
//           //     size: 35,
//           //   )
//           //       : const Icon(
//           //     Icons.widgets_outlined,
//           //     // color: Colors.white,
//           //     size: 35,
//           //   ),
//           // ),
//           // IconButton(
//           //   enableFeedback: false,
//           //   onPressed: () {
//           //     setState(() {
//           //       pageIndex = 3;
//           //     });
//           //   },
//           //   icon: pageIndex == 3
//           //       ? const Icon(
//           //     Icons.person,
//           //     // color: Colors.white,
//           //     size: 35,
//           //   )
//           //       : const Icon(
//           //     Icons.person_outline,
//           //     // color: Colors.white,
//           //     size: 35,
//           //   ),
//           // ),
//         ],
//       ),
//     );
//   }
// }

class BottomNav extends StatefulWidget {
  final int? index;
  const BottomNav({Key? key, this.index}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  // final items=  [
  //
  // Card(
  //   elevation: 3,
  //   child:  Icon(Icons.home,color: secondaryColor ),),
  //   Icon(Icons.upload_file_outlined,color:Color(0xFF4B4B4B)),
  //   Icon(Icons.person,color: Color(0xFF4B4B4B)),
  //   // Icon(Icons.person,color:Color(0xFF4B4B4B)),
  // ];
  int index = 0;
  void CurvedNavigationar;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.index != null) {
      setState(() {
        index = widget.index!;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Confirm Exit"),
              content: Text("Are you sure you want to exit?"),
              actions: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: secondaryColor),
                  child: Text("YES"),
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: secondaryColor),
                  child: Text("NO"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
      return true;
    },
    child:
      Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 50,
        buttonBackgroundColor: secondaryColor,
        items: <Widget>[
          // Card(
          //   elevation: 2,
          //   child:
            Icon(Icons.home,
                color: index == 0 ? whiteColor : primaryColor ),
          // ),
          // Card(
          //   elevation: 2,
          //   child:
            Icon(Icons.upload_file_outlined,
                color: index == 1 ? whiteColor : primaryColor),
          // ),
          // Card(
          //   elevation: 2,
          //   child:
            Icon(Icons.person,
                color: index == 2 ? whiteColor : primaryColor),
          // ),
        ],
        index: index,
        onTap: (selectedIndex) {
          setState(() {
            index = selectedIndex;
          });
        },
        backgroundColor: greyColor,
      ),
      body: Container(
        child: getSelectedWidget(index: index),
      ),
    )
    );
  }

  Widget getSelectedWidget({required int index}) {
    Widget widget;
    switch (index) {
      case 0:
        widget = const HomeScreen();
        break;
      case 1:
        widget = const ViewDocuments();
        break;
      case 2:
        widget = const UserProfile();
        break;
      // case 3:
      //   widget=const UserProfileScreen();
      //   break;
      default:
        widget = const  HomeScreen();
    }
    return widget;
  }
}
